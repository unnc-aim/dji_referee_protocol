# 场地事件数据 (命令码: 0x0101)
# 以1Hz频率发送

# 补给区状态
bool supply_area_1           # 己方与资源区不重叠的补给区占领状态
bool supply_area_2           # 己方与资源区重叠的补给区占领状态
bool rmul_supply_area        # 己方补给区的占领状态（仅RMUL适用）

# 能量机关状态
# ENERGY_MECH_INACTIVE=0, ENERGY_MECH_ACTIVATING=1, ENERGY_MECH_ACTIVATED=2
uint8 small_energy_mech      # 己方小能量机关的激活状态 (0-2)
uint8 big_energy_mech        # 己方大能量机关的激活状态 (0-2)

# 高地状态
uint8 central_highland       # 己方中央高地的占领状态
bool trapezoid_highland      # 己方梯形高地的占领状态

# 飞镖击中信息
uint16 dart_last_hit_time    # 对方飞镖最后一次击中己方前哨站或基地的时间
uint8 dart_last_hit_target   # 对方飞镖最后一次击中的目标

# 增益点状态
uint8 center_buff_point      # 中心增益点的占领状态（仅RMUL适用）
uint8 fortress_buff_point    # 己方堡垒增益点的占领状态
uint8 outpost_buff_point     # 己方前哨站增益点的占领状态
bool base_buff_point         # 己方基地增益点的占领状态
