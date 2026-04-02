# 对方队伍的宏观状态信息 (命令码: 0x0A04)
# 雷达无线链路数据，频率上限为10Hz

uint16 remaining_gold              # 对方剩余金币数
uint16 total_gold                  # 对方累计总金币数
bool supply_area_occupied          # 对方补给区占领状态
uint8 central_highland_status      # 对方中央高地的占领状态
bool trapezoid_highland_status     # 对方梯形高地的占领状态
uint8 fortress_status              # 对方堡垒增益点的占领状态
uint8 outpost_status               # 对方前哨站增益点的占领状态
bool base_status                   # 对方基地增益点的占领状态
uint8 terrain_cross_status         # 各地形跨越增益点状态
