# 选手端小地图交互数据 (命令码: 0x0303)
# 选手端触发发送

float32 target_x           # 目标位置x轴坐标（单位：m）
float32 target_y           # 目标位置y轴坐标（单位：m）
uint8 keyboard_key         # 云台手按下的键盘按键通用键值
uint16 target_robot_id     # 对方机器人ID
uint16 source_id           # 信息来源ID
