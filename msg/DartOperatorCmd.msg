# 飞镖选手端指令数据 (命令码: 0x020A)
# 以3Hz频率发送

# 常量定义 (参考Constants.msg)
# DART_STATION_OPEN=0
# DART_STATION_CLOSED=1
# DART_STATION_OPENING_CLOSING=2

uint8 dart_station_status      # 当前飞镖发射站的状态
uint16 target_switch_time      # 切换击打目标时的比赛剩余时间（秒）
uint16 last_launch_time        # 最后一次操作手确定发射指令时的比赛剩余时间（秒）
