# 裁判警告数据 (命令码: 0x0104)
# 己方判罚/判负时触发发送，其余时间以1Hz频率发送

# 常量定义 (参考Constants.msg)
# PENALTY_DOUBLE_YELLOW=1
# PENALTY_YELLOW=2
# PENALTY_RED=3
# PENALTY_LOSE=4

uint8 penalty_level     # 己方最后一次受到判罚的等级
uint8 foul_robot_id     # 己方最后一次受到判罚的违规机器人ID
uint8 foul_count        # 己方最后一次受到判罚的违规机器人对应判罚等级的违规次数
