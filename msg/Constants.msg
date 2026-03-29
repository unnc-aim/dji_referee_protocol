# DJI裁判系统常量定义
# 此文件定义所有enum形式的常量，方便使用者调用

# ==================== 机器人ID ====================
# 红方机器人 (1-11)
uint8 ROBOT_ID_RED_HERO=1
uint8 ROBOT_ID_RED_ENGINEER=2
uint8 ROBOT_ID_RED_INFANTRY_3=3
uint8 ROBOT_ID_RED_INFANTRY_4=4
uint8 ROBOT_ID_RED_INFANTRY_5=5
uint8 ROBOT_ID_RED_AERIAL=6
uint8 ROBOT_ID_RED_SENTRY=7
uint8 ROBOT_ID_RED_DART=8
uint8 ROBOT_ID_RED_RADAR=9
uint8 ROBOT_ID_RED_OUTPOST=10
uint8 ROBOT_ID_RED_BASE=11

# 蓝方机器人 (101-111)
uint8 ROBOT_ID_BLUE_HERO=101
uint8 ROBOT_ID_BLUE_ENGINEER=102
uint8 ROBOT_ID_BLUE_INFANTRY_3=103
uint8 ROBOT_ID_BLUE_INFANTRY_4=104
uint8 ROBOT_ID_BLUE_INFANTRY_5=105
uint8 ROBOT_ID_BLUE_AERIAL=106
uint8 ROBOT_ID_BLUE_SENTRY=107
uint8 ROBOT_ID_BLUE_DART=108
uint8 ROBOT_ID_BLUE_RADAR=109
uint8 ROBOT_ID_BLUE_OUTPOST=110
uint8 ROBOT_ID_BLUE_BASE=111

# ==================== 比赛类型 ====================
uint8 GAME_TYPE_ROBO_MASTER=1           # RoboMaster机甲大师超级对抗赛
uint8 GAME_TYPE_ICRA_RM=2               # RoboMaster机甲大师高校单项赛
uint8 GAME_TYPE_ICRA_ROBO_MASTER=3      # ICRA RoboMaster高校人工智能挑战赛
uint8 GAME_TYPE_RMUL_3V3=4              # RoboMaster机甲大师高校联盟赛3V3对抗
uint8 GAME_TYPE_RMUL_INFANTRY=5         # RoboMaster机甲大师高校联盟赛步兵对抗

# ==================== 比赛阶段 ====================
uint8 GAME_STAGE_NOT_STARTED=0          # 未开始比赛
uint8 GAME_STAGE_PREPARING=1            # 准备阶段
uint8 GAME_STAGE_SELF_CHECK=2           # 十五秒裁判系统自检阶段
uint8 GAME_STAGE_COUNTDOWN=3            # 五秒倒计时
uint8 GAME_STAGE_IN_GAME=4              # 比赛中
uint8 GAME_STAGE_SETTLING=5             # 比赛结算中

# ==================== 比赛结果 ====================
uint8 GAME_RESULT_DRAW=0                # 平局
uint8 GAME_RESULT_RED_WIN=1             # 红方胜利
uint8 GAME_RESULT_BLUE_WIN=2            # 蓝方胜利

# ==================== 判罚等级 ====================
uint8 PENALTY_DOUBLE_YELLOW=1           # 双方黄牌
uint8 PENALTY_YELLOW=2                  # 黄牌
uint8 PENALTY_RED=3                     # 红牌
uint8 PENALTY_LOSE=4                    # 判负

# ==================== 伤害类型 ====================
uint8 DAMAGE_TYPE_PROJECTILE=0          # 装甲模块被弹丸攻击导致扣血
uint8 DAMAGE_TYPE_MODULE_OFFLINE=1      # 装甲模块或超级电容管理模块离线导致扣血
uint8 DAMAGE_TYPE_IMPACT=5              # 装甲模块受到撞击导致扣血

# ==================== 弹丸类型 ====================
uint8 PROJECTILE_TYPE_17MM=1            # 17mm弹丸
uint8 PROJECTILE_TYPE_42MM=2            # 42mm弹丸

# ==================== 发射机构ID ====================
uint8 SHOOTER_ID_17MM=1                 # 17mm发射机构
uint8 SHOOTER_ID_RESERVED=2             # 保留位
uint8 SHOOTER_ID_42MM=3                 # 42mm发射机构

# ==================== 飞镖目标 ====================
uint8 DART_TARGET_NONE=0                # 未选定/选定前哨站
uint8 DART_TARGET_OUTPOST=1             # 击中前哨站
uint8 DART_TARGET_BASE_FIXED=2          # 击中基地固定目标
uint8 DART_TARGET_BASE_RANDOM_FIXED=3   # 击中基地随机固定目标
uint8 DART_TARGET_BASE_RANDOM_MOVING=4  # 击中基地随机移动目标
uint8 DART_TARGET_BASE_END_MOVING=5     # 击中基地末端移动目标

# ==================== 哨兵姿态 ====================
uint8 SENTRY_POSTURE_ATTACK=1           # 进攻姿态
uint8 SENTRY_POSTURE_DEFENSE=2          # 防御姿态
uint8 SENTRY_POSTURE_MOVE=3             # 移动姿态

# ==================== 飞镖发射站状态 ====================
uint8 DART_STATION_CLOSED=1             # 关闭
uint8 DART_STATION_OPENING_CLOSING=2    # 正在开启或者关闭中
uint8 DART_STATION_OPEN=0               # 已经开启

# ==================== 能量机关状态 ====================
uint8 ENERGY_MECH_INACTIVE=0            # 未激活
uint8 ENERGY_MECH_ACTIVATING=1          # 正在激活
uint8 ENERGY_MECH_ACTIVATED=2           # 已激活

# ==================== 颜色 ====================
uint8 COLOR_UNKNOWN=0
uint8 COLOR_RED=1
uint8 COLOR_BLUE=2
