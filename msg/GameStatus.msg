# 比赛状态数据 (命令码: 0x0001)
# 以1Hz频率发送

# 常量定义 (参考Constants.msg)
# GAME_TYPE_ROBO_MASTER=1
# GAME_TYPE_ICRA_RM=2
# GAME_TYPE_ICRA_ROBO_MASTER=3
# GAME_TYPE_RMUL_3V3=4
# GAME_TYPE_RMUL_INFANTRY=5
# GAME_STAGE_NOT_STARTED=0
# GAME_STAGE_PREPARING=1
# GAME_STAGE_SELF_CHECK=2
# GAME_STAGE_COUNTDOWN=3
# GAME_STAGE_IN_GAME=4
# GAME_STAGE_SETTLING=5

uint8 game_type             # 比赛类型
uint8 game_progress         # 当前比赛阶段
uint16 stage_remain_time    # 当前阶段剩余时间（秒）
uint64 sync_timestamp       # UNIX时间戳
