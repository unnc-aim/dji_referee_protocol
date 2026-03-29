# 选手端小地图接收路径数据 (命令码: 0x0307)
# 频率上限为1Hz

# 常量定义 (参考Constants.msg)
# SENTRY_POSTURE_ATTACK=1
# SENTRY_POSTURE_DEFENSE=2
# SENTRY_POSTURE_MOVE=3

uint8 intention              # 哨兵意图 (1:攻击, 2:防守, 3:移动)
uint16 start_x               # 路径起点x轴坐标（单位：dm）
uint16 start_y               # 路径起点y轴坐标（单位：dm）
int8[49] delta_x             # 路径点x轴增量数组
int8[49] delta_y             # 路径点y轴增量数组
uint16 sender_id             # 发送者ID
