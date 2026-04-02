# 机器人增益和底盘能量数据 (命令码: 0x0204)
# 以3Hz频率发送

uint8 recovery_buff         # 机器人回血增益（百分比）
uint8 cooling_buff          # 机器人射击热量冷却倍率
uint8 defence_buff          # 机器人防御增益（百分比）
uint8 vulnerability_buff    # 机器人负防御增益（百分比）
uint16 attack_buff          # 机器人攻击增益（百分比）
uint8 remaining_energy      # 机器人剩余能量值反馈
