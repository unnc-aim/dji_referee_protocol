# DJI 机甲大师裁判系统通信协议 ROS 2 功能包

[![ROS 2 Humble](https://img.shields.io/badge/ROS%202-Humble-blue)](https://docs.ros.org/en/humble/)
[![Python 3.10+](https://img.shields.io/badge/Python-3.10+-green)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow)](https://opensource.org/licenses/MIT)

## 📖 项目简介

本功能包实现了大疆机甲大师（RoboMaster）裁判系统通信协议的 ROS 2 接口。从裁判系统串口读取数据，严格按照官方协议文档解析，并将解析后的数据发布为独立的 ROS 2 话题。

### 主要功能

- ✅ 支持多个串口读取（常规链路 + 图传链路）
- ✅ 严格按照官方协议文档解析数据
- ✅ 将每类数据发布为独立的 ROS 2 话题
- ✅ 支持 YAML 配置文件控制话题发布
- ✅ 完整的中文注释和文档
- ✅ 兼容 ROS 2 Humble 版本
- ✅ 提供无 ROS 2 依赖的串口直接测试工具

### 协议版本

- 版本：V1.2.0
- 更新日期：2026.02.09

---

## 📦 目录结构

```
dji-communication-protocol/
├── dji_referee_protocol/          # Python 包
│   ├── __init__.py                # 包初始化文件
│   ├── crc_utils.py               # CRC8/CRC16 校验工具
│   ├── protocol_constants.py      # 协议常量定义
│   ├── data_types.py              # 数据类型定义（所有消息结构）
│   ├── protocol_parser.py         # 协议解析器
│   └── referee_serial_node.py     # ROS 2 主节点
├── config/
│   └── topic_config.yaml          # 话题配置文件
├── launch/
│   └── referee_serial_launch.py   # 启动文件
├── resource/
│   └── dji_referee_protocol       # 资源标记文件
├── test/                          # 测试目录
│   ├── test_serial_direct.py      # 串口直接测试（无需 ROS 2）
│   └── test_topics.py             # ROS 2 话题测试
├── reference/                     # 参考代码（老版本）
├── protocol.md                    # 官方协议文档（中文）
├── package.xml                    # ROS 2 包描述
├── setup.py                       # Python 安装配置
├── setup.cfg                      # Python 安装配置
├── README.md                      # 本文件
└── AGENTS.md                      # AI 代理文档
```

---

## 🚀 快速开始

### 1. 环境要求

- **操作系统**: Ubuntu 22.04（推荐）
- **ROS 版本**: ROS 2 Humble
- **Python 版本**: 3.10+
- **硬件**: USB 转串口设备（如 CH340）

### 2. 依赖安装

```bash
# 安装 ROS 2 Humble（如果尚未安装）
# 参考：https://docs.ros.org/en/humble/Installation.html

# 安装 Python 依赖
pip install pyserial pyyaml
```

### 3. 编译

```bash
# 创建工作空间（如果尚未创建）
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws/src

# 克隆本功能包
git clone <repository-url> DJI-communication-protocol

# 编译
cd ~/ros2_ws
colcon build --packages-select dji_referee_protocol

# 加载环境
source install/setup.bash
```

### 4. 运行

```bash
# 方式一：直接运行节点
ros2 run dji_referee_protocol referee_serial_node

# 方式二：使用启动文件（推荐）
ros2 launch dji_referee_protocol referee_serial_launch.py

# 方式三：指定串口设备
ros2 run dji_referee_protocol referee_serial_node \
    --ros-args \
    -p serial_port_normal:=/dev/ttyUSB0 \
    -p serial_port_video:=/dev/ttyUSB1

# 方式四：使用启动文件并指定参数
ros2 launch dji_referee_protocol referee_serial_launch.py \
    serial_port_normal:=/dev/ttyUSB0 \
    serial_port_video:=/dev/ttyUSB1

# 方式五：使用配置文件
ros2 launch dji_referee_protocol referee_serial_launch.py \
    config_file:=/path/to/topic_config.yaml
```

---

## 🧪 测试工具

### 串口直接测试（无需 ROS 2）

本工具直接从串口读取数据并解析，无需 ROS 2 环境，用于快速验证协议解析功能。

```bash
# 基本用法
cd ~/ros2_ws/src/DJI-communication-protocol
python3 test/test_serial_direct.py /dev/ttyUSB0

# 显示详细信息
python3 test/test_serial_direct.py /dev/ttyUSB0 -v

# 指定波特率（默认 115200）
python3 test/test_serial_direct.py /dev/ttyUSB0 -b 115200
```

**输出示例：**

```
======================================================================
  DJI 裁判系统串口直接测试工具
======================================================================
  串口设备: /dev/ttyUSB0
  波特率: 115200
  启动时间: 2026-03-10 19:18:00
======================================================================

  串口已打开: /dev/ttyUSB0
  等待数据... (按 Ctrl+C 退出)
----------------------------------------------------------------------

[19:18:00.921] 实时热量 (0x0202)
  频率: 10Hz | 长度: 14 字节 | 累计: 1
--------------------------------------------------
  缓冲能量: 60J
  17mm热量: 0 | 42mm热量: 0

[19:18:01.026] 机器人性能 (0x0201)
  频率: 10Hz | 长度: 13 字节 | 累计: 1
--------------------------------------------------
  机器人ID: 103 | 等级: 1
  血量: 200/0
  枪口冷却: 40 | 热量上限: 240 | 功率限制: 80W
```

### ROS 2 话题测试

首先启动裁判系统节点：

```bash
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
ros2 run dji_referee_protocol referee_serial_node --ros-args -p serial_port:=/dev/ttyUSB0
```

然后在另一个终端运行话题测试：

```bash
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash
python3 ~/ros2_ws/src/DJI-communication-protocol/test/test_topics.py
```

**输出示例：**

```
======================================================================
  DJI 裁判系统话题测试工具
======================================================================
  订阅话题数: 33
  启动时间: 2026-03-10 19:22:02
======================================================================

  等待数据... (按 Ctrl+C 退出)
----------------------------------------------------------------------

[19:22:05.123] 机器人性能
  话题: /referee/robot_performance
  消息 #1
--------------------------------------------------
PoseStamped:
  frame_id: referee
  position: (103.0000, 1.0000, 200.0000)
  ...

======================================================================
  统计信息
======================================================================
  运行时间: 9.14 秒
  总消息数: 1
  平均频率: 0.11 msg/s
----------------------------------------------------------------------
  各话题消息数:
----------------------------------------------------------------------
  ● /referee/robot_performance: 1
  ○ /referee/game_status: 0
  ...
```

---

## 📋 话题列表

### 常规链路数据（115200 波特率）

| 话题名称 | 命令码 | 频率 | 数据结构 | 描述 |
|---------|--------|------|----------|------|
| `/referee/game_status` | 0x0001 | 1Hz | GameStatus | 比赛状态数据 |
| `/referee/game_result` | 0x0002 | 触发 | GameResult | 比赛结果数据 |
| `/referee/robot_hp` | 0x0003 | 3Hz | RobotHP | 机器人血量数据 |
| `/referee/field_event` | 0x0101 | 1Hz | FieldEvent | 场地事件数据 |
| `/referee/referee_warning` | 0x0104 | 1Hz | RefereeWarning | 裁判警告数据 |
| `/referee/dart_launch_data` | 0x0105 | 1Hz | DartLaunchData | 飞镖发射数据 |
| `/referee/robot_performance` | 0x0201 | 10Hz | RobotPerformance | 机器人性能数据 |
| `/referee/robot_heat` | 0x0202 | 10Hz | RobotHeat | 实时热量数据 |
| `/referee/robot_position` | 0x0203 | 1Hz | RobotPosition | 机器人位置数据 |
| `/referee/robot_buff` | 0x0204 | 3Hz | RobotBuff | 机器人增益数据 |
| `/referee/damage_state` | 0x0206 | 触发 | DamageState | 伤害状态数据 |
| `/referee/shoot_data` | 0x0207 | 触发 | ShootData | 射击数据 |
| `/referee/allowed_shoot` | 0x0208 | 10Hz | AllowedShoot | 允许发弹量 |
| `/referee/rfid_status` | 0x0209 | 触发 | RFIDStatus | RFID状态数据 |
| `/referee/dart_operator_cmd` | 0x020A | 触发 | DartOperatorCmd | 飞镖操作指令 |
| `/referee/ground_robot_position` | 0x020B | 1Hz | GroundRobotPosition | 地面机器人位置 |
| `/referee/radar_mark_progress` | 0x020C | 1Hz | RadarMarkProgress | 雷达标记进度 |
| `/referee/sentry_decision_sync` | 0x020D | 触发 | SentryDecisionSync | 哨兵决策同步 |
| `/referee/radar_decision_sync` | 0x020E | 触发 | RadarDecisionSync | 雷达决策同步 |

### 选手端小地图数据

| 话题名称 | 命令码 | 频率 | 描述 |
|---------|--------|------|------|
| `/referee/map_click_data` | 0x0301 | 触发 | 小地图点击数据 |
| `/referee/map_radar_data` | 0x0304 | 1Hz | 小地图雷达数据 |
| `/referee/map_path_data` | 0x0305 | 5Hz | 小地图路径数据 |
| `/referee/map_robot_data` | 0x0306 | 1Hz | 小地图机器人数据 |

### 图传链路数据（921600 波特率）

| 话题名称 | 命令码 | 频率 | 描述 |
|---------|--------|------|------|
| `/referee/custom_controller_to_robot` | 0x0302 | 30Hz | 自定义控制器到机器人数据 |
| `/referee/robot_to_custom_controller` | 0x0309 | 10Hz | 机器人到控制器数据 |
| `/referee/robot_to_custom_client` | 0x0310 | 50Hz | 机器人到客户端数据 |
| `/referee/custom_client_to_robot` | 0x0311 | 75Hz | 客户端到机器人数据 |

### 雷达无线链路数据

| 话题名称 | 命令码 | 频率 | 描述 |
|---------|--------|------|------|
| `/referee/enemy_position` | 0x0A01 | 10Hz | 对方机器人位置 |
| `/referee/enemy_hp` | 0x0A02 | 10Hz | 对方机器人血量 |
| `/referee/enemy_ammo` | 0x0A03 | 10Hz | 对方机器人发弹量 |
| `/referee/enemy_team_status` | 0x0A04 | 10Hz | 对方队伍状态 |
| `/referee/enemy_buff` | 0x0A05 | 10Hz | 对方增益效果 |
| `/referee/enemy_jamming_key` | 0x0A06 | 10Hz | 对方干扰波密钥 |

---

## 📊 数据结构详解

### GameStatus（比赛状态）- 0x0001

| 字段 | 类型 | 说明 |
|------|------|------|
| `game_type` | uint8 | 比赛类型：1-超级对抗赛, 2-高校单项赛, 3-ICRA, 4-联盟赛3V3, 5-联盟赛步兵对抗 |
| `game_progress` | uint8 | 比赛阶段：0-未开始, 1-准备, 2-自检, 3-倒计时, 4-比赛中, 5-结算 |
| `stage_remain_time` | uint16 | 当前阶段剩余时间（秒） |
| `sync_timestamp` | uint64 | UNIX 时间戳 |

### RobotPerformance（机器人性能）- 0x0201

| 字段 | 类型 | 说明 |
|------|------|------|
| `robot_id` | uint8 | 机器人 ID |
| `robot_level` | uint8 | 机器人等级 |
| `current_hp` | uint16 | 当前血量 |
| `maximum_hp` | uint16 | 血量上限 |
| `shooter_barrel_cooling_value` | uint16 | 射击热量冷却值 |
| `shooter_barrel_heat_limit` | uint16 | 射击热量上限 |
| `chassis_power_limit` | uint16 | 底盘功率上限（瓦） |

### RobotHeat（实时热量）- 0x0202

| 字段 | 类型 | 说明 |
|------|------|------|
| `chassis_current_voltage` | uint16 | 底盘电压（保留） |
| `chassis_current_current` | uint16 | 底盘电流（保留） |
| `chassis_current_power` | float | 底盘功率（保留） |
| `buffer_energy` | uint16 | 缓冲能量（焦耳） |
| `shooter_17mm_barrel_heat` | uint16 | 17mm 发射机构热量 |
| `shooter_42mm_barrel_heat` | uint16 | 42mm 发射机构热量 |

### RobotPosition（机器人位置）- 0x0203

| 字段 | 类型 | 说明 |
|------|------|------|
| `x` | float | X 坐标（米） |
| `y` | float | Y 坐标（米） |
| `angle` | float | 朝向角度（度，正北为 0） |

---

## ⚙️ 配置文件

配置文件 `config/topic_config.yaml` 用于控制每个话题是否发布：

```yaml
# 话题发布配置
# true: 发布该话题
# false: 不发布该话题

topics:
  # 常规链路数据
  game_status: true           # 比赛状态
  game_result: true           # 比赛结果
  robot_hp: true              # 机器人血量
  field_event: true           # 场地事件
  referee_warning: true       # 裁判警告
  dart_launch_data: true      # 飞镖发射数据
  robot_performance: true     # 机器人性能
  robot_heat: true            # 实时热量
  robot_position: true        # 机器人位置
  robot_buff: true            # 机器人增益
  damage_state: true          # 伤害状态
  shoot_data: true            # 射击数据

  # 图传链路数据
  custom_controller_to_robot: true
  robot_to_custom_controller: true

  # 雷达数据（如不需要可禁用以节省资源）
  enemy_position: false
  enemy_hp: false
  enemy_ammo: false
```

---

## 🔧 参数说明

| 参数名 | 类型 | 默认值 | 描述 |
|--------|------|--------|------|
| `serial_port_normal` | string | /dev/ttyUSB0 | 常规链路串口设备 |
| `serial_port_video` | string | /dev/ttyUSB1 | 图传链路串口设备 |
| `serial_baud_normal` | int | 115200 | 常规链路波特率 |
| `serial_baud_video` | int | 921600 | 图传链路波特率 |
| `config_file` | string | "" | 配置文件路径 |
| `publish_all_topics` | bool | true | 是否发布所有话题 |

---

## 📚 协议说明

### 帧格式

```
+-------------+--------+------+-------------+
| frame_header| cmd_id | data | frame_tail  |
|   5 bytes   | 2 bytes| n B  |   2 bytes   |
+-------------+--------+------+-------------+
```

### 帧头结构（5 字节）

```
+-----+-------------+------+------+
| SOF | data_length | seq  | CRC8 |
| 0xA5|   2 bytes   | 1 B  | 1 B  |
+-----+-------------+------+------+
```

- **SOF**: 帧起始字节，固定为 0xA5
- **data_length**: 数据长度（不含帧头和帧尾）
- **seq**: 包序号，用于丢包检测
- **CRC8**: 帧头 CRC8 校验

### CRC 校验

- **CRC8**: 仅对帧头（前 4 字节）进行校验
- **CRC16**: 对整包（SOF 到 data）进行校验

### 解析流程

1. 查找帧头 SOF (0xA5)
2. 读取帧头，验证 CRC8
3. 根据 data_length 读取数据
4. 验证 CRC16
5. 根据 cmd_id 解析对应数据结构

详细协议说明请参考 `protocol.md` 文件。

---

## 🔌 串口连接

### 硬件连接

1. 将裁判系统的串口线连接到上位机的 USB 端口
2. 确保使用 USB 转串口芯片（如 CH340、CP2102 等）
3. 常规链路波特率：115200，图传链路波特率：921600

### 检查串口设备

```bash
# 查看已连接的串口设备
ls /dev/ttyUSB* /dev/ttyACM*

# 或使用 Python
python3 -m serial.tools.list_ports
```

### 串口权限

如果遇到权限问题，将当前用户添加到 `dialout` 组：

```bash
sudo usermod -aG dialout $USER
# 注销后重新登录生效
```

---

## 🛠️ 故障排除

### 问题 1：找不到串口设备 /dev/ttyUSB0

**可能原因：**
- USB 设备未正确连接
- 驱动未加载
- `brltty` 服务占用（Ubuntu 默认安装）

**解决方案：**

```bash
# 检查 USB 设备
lsusb

# 如果看到 CH340 设备但没有 ttyUSB0，可能是 brltty 占用
# 卸载 brltty
sudo apt remove --purge brltty

# 重新加载驱动
sudo modprobe -r ch341
sudo modprobe ch341

# 检查设备
ls /dev/ttyUSB*
```

### 问题 2：串口打开失败

**可能原因：**
- 权限不足
- 设备被其他程序占用

**解决方案：**

```bash
# 检查权限
ls -la /dev/ttyUSB0

# 添加用户到 dialout 组
sudo usermod -aG dialout $USER
# 注销后重新登录

# 或临时修改权限
sudo chmod 666 /dev/ttyUSB0
```

### 问题 3：CRC 校验失败

**可能原因：**
- 波特率设置错误
- 串口线质量差
- 数据传输干扰

**解决方案：**
- 确认波特率设置正确（常规链路 115200，图传链路 921600）
- 更换质量更好的 USB 转串口线
- 使用带屏蔽的串口线

### 问题 4：收不到数据

**可能原因：**
- 裁判系统未开机或未连接
- 串口号错误
- 裁判系统未配置发送该数据

**解决方案：**
- 确认裁判系统已开机并正常工作
- 使用 `test_serial_direct.py` 测试串口
- 检查裁判系统配置

### 问题 5：ROS 2 节点启动失败

**错误信息：** `AttributeError: can't set attribute 'publishers'`

**原因：** `publishers` 是 ROS 2 Node 的保留属性

**解决方案：** 确保使用最新版本代码，该问题已修复。

---

## 📝 代码风格

- 遵循 PEP 8 Python 代码风格
- 使用完整的中文注释
- 包含类型注解（兼容 Pylance）
- 函数和类都有详细的 docstring

---

## 🤝 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 📧 联系方式

如有问题，请提交 Issue 或联系维护者。

---

## 🙏 致谢

- 大疆创新 RoboMaster 组委会
- ROS 2 社区
- 所有贡献者
