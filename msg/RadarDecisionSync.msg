# 雷达自主决策信息同步 (命令码: 0x020E)
# 以1Hz频率发送给雷达机器人

uint8 double_vulnerability_chance    # 雷达是否拥有触发双倍易伤的机会
bool enemy_double_vulnerability      # 对方是否正在被触发双倍易伤
uint8 encryption_level               # 己方加密等级（即对方干扰波难度等级）
bool can_modify_key                  # 当前是否可以修改密钥
