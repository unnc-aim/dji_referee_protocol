"""
裁判系统 UI 绘制节点

本节点负责聚合 ROS 2 话题状态，生成 0x0301 UI 绘制数据帧，
并发布到 /referee/ui/tx_frame 供串口节点统一发送。
"""

from typing import List, Optional, Tuple

import rclpy
from rclpy.node import Node
from std_msgs.msg import UInt8MultiArray

from dji_referee_protocol.msg import (
    AllowedShoot,
    Constraints,
    ReadSuperCap,
    RobotPerformance,
    UnifiedInput,
)

from .protocol_constants import OperatorClientID
from .ui_protocol import (
    UIDrawingProtocol,
    UIDataCommandID,
    UIGraphic,
    UIGraphicOperation,
    UIGraphicType,
    UIColor,
)


class RefereeUINode(Node):
    """
    UI 绘制节点

    订阅裁判与控制状态相关话题，周期构建 UI 绘制帧并发布。
    """

    def __init__(self) -> None:
        super().__init__("referee_ui_node")

        # ==================== 声明参数 ====================
        self.declare_parameter("ui_enable_tx", True)
        self.declare_parameter("ui_update_period_sec", 0.5)
        self.declare_parameter("ui_target_client_id", 0x103)
        self.declare_parameter("ui_layer", 8)
        self.declare_parameter("ui_color", int(UIColor.SELF))
        self.declare_parameter("ui_anchor_x", 80)
        self.declare_parameter("ui_anchor_y", 860)
        self.declare_parameter("ui_line_gap", 35)
        self.declare_parameter("ui_font_size", 20)
        self.declare_parameter("ui_line_width", 2)
        self.declare_parameter("ui_tx_topic", "/referee/ui/tx_frame")

        # ==================== 参数读取 ====================
        self.ui_enable_tx = bool(self.get_parameter("ui_enable_tx").value)
        self.ui_update_period_sec = float(self.get_parameter("ui_update_period_sec").value or 0.5)
        self.ui_target_client_id = int(self.get_parameter("ui_target_client_id").value or 0)
        self.ui_layer = int(self.get_parameter("ui_layer").value or 8)
        self.ui_color = int(self.get_parameter("ui_color").value or int(UIColor.SELF))
        self.ui_anchor_x = int(self.get_parameter("ui_anchor_x").value or 80)
        self.ui_anchor_y = int(self.get_parameter("ui_anchor_y").value or 860)
        self.ui_line_gap = int(self.get_parameter("ui_line_gap").value or 35)
        self.ui_font_size = int(self.get_parameter("ui_font_size").value or 20)
        self.ui_line_width = int(self.get_parameter("ui_line_width").value or 2)
        self.ui_tx_topic = str(self.get_parameter("ui_tx_topic").value or "/referee/ui/tx_frame")

        # ==================== UI 状态缓存 ====================
        self.latest_robot_id = 0
        self.latest_shooter_heat = 0.0
        self.latest_heat_limit = 0.0
        self.latest_chassis_power = 0.0
        self.latest_chassis_power_limit = 0.0
        self.latest_fire_allowed = True
        self.latest_speed_scale = 1.0
        self.latest_projectile_allowance_17mm = 0
        self.latest_projectile_allowance_42mm = 0
        self.latest_remaining_gold_coin = 0
        self.latest_fortress_reserve_17mm = 0
        self.sp_valid = False
        self.sp_stat = 3
        self.sp_stat_str = "INTERRUPT"
        self.sp_remain_percentage = 0
        self.autoaim_enabled = False
        self.fric_enabled = False
        self.spin_enabled = False
        self.ui_tx_seq = 0
        self.ui_last_receiver_id = 0
        self.ui_initialized = False

        # ==================== 发布器/订阅器 ====================
        self.ui_frame_pub = self.create_publisher(
            UInt8MultiArray,
            self.ui_tx_topic,
            50,
        )
        self.robot_performance_sub = self.create_subscription(
            RobotPerformance,
            "/referee/ui/robot_performance",
            self._robot_performance_callback,
            10,
        )
        self.allowed_shoot_sub = self.create_subscription(
            AllowedShoot,
            "/referee/ui/allowed_shoot",
            self._allowed_shoot_callback,
            10,
        )
        self.constraints_sub = self.create_subscription(
            Constraints,
            "/referee/parsed/common/constraints",
            self._constraints_callback,
            10,
        )
        self.cap_sub = self.create_subscription(
            ReadSuperCap,
            "/ecat/supercap/read",
            self._supercap_ui_callback,
            10,
        )
        self.uni_input_sub = self.create_subscription(
            UnifiedInput,
            "/hub/rc_unified_input",
            self._input_ui_callback,
            10,
        )

        # ==================== 周期任务 ====================
        self.ui_timer = None
        if self.ui_enable_tx:
            self.ui_timer = self.create_timer(max(0.1, self.ui_update_period_sec), self._ui_timer_tick)

        self.get_logger().info("裁判系统 UI 绘制节点已启动")
        self.get_logger().info(f"UI 帧发布话题: {self.ui_tx_topic}")

    def _robot_performance_callback(self, msg: RobotPerformance) -> None:
        """更新机器人 ID 状态"""
        self.latest_robot_id = int(msg.robot_id)

    def _allowed_shoot_callback(self, msg: AllowedShoot) -> None:
        """更新允许发弹量状态"""
        self.latest_projectile_allowance_17mm = int(msg.projectile_allowance_17mm)
        self.latest_projectile_allowance_42mm = int(msg.projectile_allowance_42mm)
        self.latest_remaining_gold_coin = int(msg.remaining_gold_coin)
        self.latest_fortress_reserve_17mm = int(msg.fortress_reserve_17mm)

    def _constraints_callback(self, msg: Constraints) -> None:
        """更新约束状态"""
        self.latest_shooter_heat = float(msg.shooter_heat)
        self.latest_heat_limit = float(msg.heat_limit)
        self.latest_chassis_power = float(msg.chassis_power)
        self.latest_chassis_power_limit = float(msg.chassis_power_limit)
        self.latest_fire_allowed = bool(msg.fire_allowed)
        self.latest_speed_scale = float(msg.speed_scale)

    def _supercap_ui_callback(self, msg: ReadSuperCap) -> None:
        """更新超级电容状态"""
        self.sp_valid = bool(msg.cap_valid)
        self.sp_stat = int(msg.cap_status)
        if self.sp_stat == 0:
            self.sp_stat_str = "DISCHARGE"
        elif self.sp_stat == 1:
            self.sp_stat_str = "CHARGE"
        elif self.sp_stat == 2:
            self.sp_stat_str = "WAIT"
        else:
            self.sp_stat_str = "INTERRUPT"
        self.sp_remain_percentage = max(0, min(100, int(msg.cap_remain_percentage)))

    def _input_ui_callback(self, msg: UnifiedInput) -> None:
        """更新操作输入状态"""
        self.autoaim_enabled = bool(msg.autoaim_enabled)
        self.fric_enabled = bool(msg.friction_on)
        self.spin_enabled = bool(msg.spin_mode)

    def _build_ui_line_texts(self) -> Tuple[str, str]:
        """生成 UI 两行显示文本"""
        line1 = (
            f"A17:{self.latest_projectile_allowance_17mm} "
            f"A42:{self.latest_projectile_allowance_42mm} "
            f"G:{self.latest_remaining_gold_coin} "
            f"R:{self.latest_fortress_reserve_17mm}"
        )
        line2 = (
            f"H:{int(self.latest_shooter_heat)}/{int(self.latest_heat_limit)} "
            f"P:{int(self.latest_chassis_power)}/{int(self.latest_chassis_power_limit)} "
            f"F:{1 if self.latest_fire_allowed else 0} "
            f"S:{self.latest_speed_scale:.2f}"
        )
        return line1[:30], line2[:30]

    def _build_ui_status_text(self) -> str:
        """生成监听状态文本"""
        return (
            f"FR:{int(self.fric_enabled)} "
            f"RT:{int(self.spin_enabled)} "
            f"SP:{int(self.sp_valid)} "
            f"{self.sp_stat_str[:3]}:{self.sp_remain_percentage:3d}%"
        )[:30]

    def _build_ui_graphics(self, add_mode: bool) -> List[UIGraphic]:
        """构建 UI 图形列表（状态灯 + 电容进度条）"""
        op = int(UIGraphicOperation.ADD if add_mode else UIGraphicOperation.MODIFY)
        status_on = int(UIColor.GREEN)
        status_off = int(UIColor.PURPLE_RED)
        neutral = int(UIColor.CYAN)

        progress_x = 100
        progress_y = 80
        progress_w = 400
        progress_h = 30
        pct = max(0, min(100, int(self.sp_remain_percentage)))
        fill_w = int((progress_w - 8) * pct / 100.0)

        if self.sp_stat == 1:
            cap_color = status_on
        elif self.sp_stat == 0:
            cap_color = status_off
        else:
            cap_color = neutral

        return [
            UIGraphic(
                name="AIM",
                operation=op,
                graphic_type=int(UIGraphicType.CIRCLE),
                layer=self.ui_layer,
                color=status_on if self.autoaim_enabled else status_off,
                details_a=0,
                details_b=0,
                width=8,
                start_x=960,
                start_y=540,
                details_c=100,
                details_d=0,
                details_e=0,
            ),
            UIGraphic(
                name="PB0",
                operation=op,
                graphic_type=int(UIGraphicType.RECTANGLE),
                layer=self.ui_layer,
                color=int(UIColor.WHITE),
                details_a=0,
                details_b=0,
                width=3,
                start_x=progress_x,
                start_y=progress_y,
                details_c=0,
                details_d=progress_x + progress_w,
                details_e=progress_y + progress_h,
            ),
            UIGraphic(
                name="PB1",
                operation=op,
                graphic_type=int(UIGraphicType.RECTANGLE),
                layer=self.ui_layer,
                color=cap_color,
                details_a=0,
                details_b=0,
                width=2,
                start_x=progress_x + 4,
                start_y=progress_y + 4,
                details_c=0,
                details_d=progress_x + 4 + fill_w,
                details_e=progress_y + progress_h - 4,
            ),
            UIGraphic(
                name="FRI",
                operation=op,
                graphic_type=int(UIGraphicType.CIRCLE),
                layer=self.ui_layer,
                color=status_on if self.fric_enabled else status_off,
                details_a=0,
                details_b=0,
                width=6,
                start_x=560,
                start_y=95,
                details_c=18,
                details_d=0,
                details_e=0,
            ),
            UIGraphic(
                name="SPN",
                operation=op,
                graphic_type=int(UIGraphicType.CIRCLE),
                layer=self.ui_layer,
                color=status_on if self.spin_enabled else status_off,
                details_a=0,
                details_b=0,
                width=6,
                start_x=620,
                start_y=95,
                details_c=18,
                details_d=0,
                details_e=0,
            ),
            UIGraphic(
                name="CPV",
                operation=op,
                graphic_type=int(UIGraphicType.CIRCLE),
                layer=self.ui_layer,
                color=status_on if self.sp_valid else status_off,
                details_a=0,
                details_b=0,
                width=6,
                start_x=680,
                start_y=95,
                details_c=18,
                details_d=0,
                details_e=0,
            ),
            UIGraphic(
                name="CHG",
                operation=op,
                graphic_type=int(UIGraphicType.CIRCLE),
                layer=self.ui_layer,
                color=cap_color,
                details_a=0,
                details_b=0,
                width=6,
                start_x=740,
                start_y=95,
                details_c=18,
                details_d=0,
                details_e=0,
            ),
        ]

    def _resolve_ui_receiver_id(self) -> int:
        """解析 UI 接收者选手端 ID"""
        if self.ui_target_client_id > 0:
            return self.ui_target_client_id

        mapping = {
            1: int(OperatorClientID.RED_HERO),
            2: int(OperatorClientID.RED_ENGINEER),
            3: int(OperatorClientID.RED_INFANTRY_3),
            4: int(OperatorClientID.RED_INFANTRY_4),
            5: int(OperatorClientID.RED_INFANTRY_5),
            6: int(OperatorClientID.RED_AERIAL),
            101: int(OperatorClientID.BLUE_HERO),
            102: int(OperatorClientID.BLUE_ENGINEER),
            103: int(OperatorClientID.BLUE_INFANTRY_3),
            104: int(OperatorClientID.BLUE_INFANTRY_4),
            105: int(OperatorClientID.BLUE_INFANTRY_5),
            106: int(OperatorClientID.BLUE_AERIAL),
        }
        return mapping.get(int(self.latest_robot_id), 0)

    def _send_ui_frame(self, data_cmd_id: int, content_payload: bytes, receiver_id: int) -> bool:
        """构建并发布单帧 UI 数据"""
        if self.latest_robot_id <= 0 or receiver_id <= 0:
            return False
        try:
            frame = UIDrawingProtocol.build_robot_interaction_frame(
                seq=self.ui_tx_seq,
                data_cmd_id=data_cmd_id,
                sender_id=self.latest_robot_id,
                receiver_id=receiver_id,
                content_payload=content_payload,
            )
        except ValueError as e:
            self.get_logger().error(f"UI帧构建失败: {e}")
            return False

        self.ui_tx_seq = (self.ui_tx_seq + 1) & 0xFF
        msg = UInt8MultiArray()
        msg.data = list(frame)
        self.ui_frame_pub.publish(msg)
        return True

    def _send_ui_delete_all(self, receiver_id: int) -> bool:
        """发送 UI 全删除命令（表 1-25）"""
        payload = UIDrawingProtocol.pack_delete_payload(delete_operation=2, layer=0)
        return self._send_ui_frame(int(UIDataCommandID.DELETE), payload, receiver_id)

    def _send_ui_char_line(self, receiver_id: int, name: str, text: str, x: int, y: int, add_mode: bool) -> bool:
        """发送 UI 字符绘制命令（表 1-31）"""
        graphic = UIGraphic(
            name=name,
            operation=int(UIGraphicOperation.ADD if add_mode else UIGraphicOperation.MODIFY),
            graphic_type=int(UIGraphicType.CHAR),
            layer=self.ui_layer,
            color=self.ui_color,
            details_a=self.ui_font_size,
            details_b=len(text.encode("utf-8", errors="ignore")[:30]),
            width=self.ui_line_width,
            start_x=x,
            start_y=y,
            details_c=0,
            details_d=0,
            details_e=0,
        )
        payload = UIDrawingProtocol.pack_char_payload(graphic, text)
        return self._send_ui_frame(
            data_cmd_id=int(UIDataCommandID.DRAW_CHAR),
            content_payload=payload,
            receiver_id=receiver_id,
        )

    def _send_ui_graphics(self, receiver_id: int, graphics: List[UIGraphic]) -> bool:
        """发送图形绘制命令（表 1-26/1-28/1-29/1-30）"""
        if not graphics:
            return False
        data_cmd_id = UIDrawingProtocol.choose_graphics_data_cmd_id(len(graphics))
        payload = UIDrawingProtocol.pack_graphics_payload(graphics)
        return self._send_ui_frame(data_cmd_id, payload, receiver_id)

    def _ui_timer_tick(self) -> None:
        """周期发送 UI 绘制数据"""
        if not self.ui_enable_tx:
            return

        receiver_id = self._resolve_ui_receiver_id()
        if receiver_id <= 0 or self.latest_robot_id <= 0:
            return

        need_add = (not self.ui_initialized) or (receiver_id != self.ui_last_receiver_id)
        if need_add:
            self._send_ui_delete_all(receiver_id)
            self.ui_initialized = True
            self.ui_last_receiver_id = receiver_id

        graphics = self._build_ui_graphics(add_mode=need_add)
        self._send_ui_graphics(receiver_id, graphics)
        line1, line2 = self._build_ui_line_texts()
        status_line = self._build_ui_status_text()
        self._send_ui_char_line(receiver_id, "AS1", line1, self.ui_anchor_x, self.ui_anchor_y, add_mode=need_add)
        self._send_ui_char_line(
            receiver_id,
            "CS1",
            line2,
            self.ui_anchor_x,
            self.ui_anchor_y - self.ui_line_gap,
            add_mode=need_add,
        )
        self._send_ui_char_line(receiver_id, "ST1", status_line, 100, 125, add_mode=need_add)


def main(args: Optional[list] = None) -> None:
    """节点主入口函数"""
    rclpy.init(args=args)

    try:
        node = RefereeUINode()
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        if rclpy.ok():
            rclpy.shutdown()


if __name__ == "__main__":
    main()
