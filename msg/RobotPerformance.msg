# 机器人性能体系数据 (命令码: 0x0201)
# 以10Hz频率发送

# 常量定义 (参考Constants.msg)
# ROBOT_ID_RED_HERO=1, ROBOT_ID_RED_ENGINEER=2, ...

uint8 robot_id                           # 本机器人ID
uint8 robot_level                        # 机器人等级
uint16 current_hp                        # 机器人当前血量
uint16 maximum_hp                        # 机器人血量上限
uint16 shooter_barrel_cooling_value      # 机器人射击热量每秒冷却值
uint16 shooter_barrel_heat_limit         # 机器人射击热量上限
uint16 chassis_power_limit               # 机器人底盘功率上限

# 电源管理模块输出状态
bool power_management_gimbal_output      # 云台输出
bool power_management_chassis_output     # 底盘输出
bool power_management_shooter_output     # 发射机构输出
