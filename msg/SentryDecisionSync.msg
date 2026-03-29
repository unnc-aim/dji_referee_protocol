# 哨兵自主决策信息同步 (命令码: 0x020D)
# 以1Hz频率发送给哨兵机器人

# 常量定义 (参考Constants.msg)
# SENTRY_POSTURE_ATTACK=1
# SENTRY_POSTURE_DEFENSE=2
# SENTRY_POSTURE_MOVE=3

uint16 exchanged_ammo              # 哨兵机器人成功兑换的允许发弹量
uint8 remote_ammo_count            # 哨兵机器人成功远程兑换允许发弹量的次数
uint8 remote_hp_count              # 哨兵机器人成功远程兑换血量的次数
bool can_free_revive               # 哨兵机器人当前是否可以确认免费复活
bool can_buy_revive                # 哨兵机器人当前是否可以兑换立即复活
uint16 revive_cost                 # 哨兵机器人当前若兑换立即复活需要花费的金币数
bool in_disengage                  # 哨兵当前是否处于脱战状态
uint16 remaining_ammo_exchange     # 队伍17mm允许发弹量的剩余可兑换数
uint8 sentry_posture               # 哨兵当前姿态 (1:进攻, 2:防御, 3:移动)
bool can_activate_rune             # 己方能量机关是否能够进入正在激活状态
