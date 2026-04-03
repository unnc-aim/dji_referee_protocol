# 选手端小地图接收雷达数据 (命令码: 0x0305)
# V1.3.0: 数据长度从24字节扩展至48字节，包含对方和己方各6个机器人坐标
# 频率上限为5Hz

# 位置单位：cm

# 对方机器人坐标 (offset 0-23)
uint16 opponent_hero_x
uint16 opponent_hero_y
uint16 opponent_engineer_x
uint16 opponent_engineer_y
uint16 opponent_infantry_3_x
uint16 opponent_infantry_3_y
uint16 opponent_infantry_4_x
uint16 opponent_infantry_4_y
uint16 opponent_aerial_x
uint16 opponent_aerial_y
uint16 opponent_sentry_x
uint16 opponent_sentry_y

# 己方机器人坐标 (offset 24-47)
uint16 ally_hero_x
uint16 ally_hero_y
uint16 ally_engineer_x
uint16 ally_engineer_y
uint16 ally_infantry_3_x
uint16 ally_infantry_3_y
uint16 ally_infantry_4_x
uint16 ally_infantry_4_y
uint16 ally_aerial_x
uint16 ally_aerial_y
uint16 ally_sentry_x
uint16 ally_sentry_y
