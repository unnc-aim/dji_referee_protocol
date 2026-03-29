# 实时底盘缓冲能量和射击热量数据 (命令码: 0x0202)
# 以10Hz频率发送

uint16 chassis_current_voltage      # 底盘当前电压（保留）
uint16 chassis_current_current      # 底盘当前电流（保留）
float32 chassis_current_power       # 底盘当前功率（保留）
uint16 buffer_energy                # 缓冲能量（单位：J）
uint16 shooter_17mm_barrel_heat     # 17mm发射机构的射击热量
uint16 shooter_42mm_barrel_heat     # 42mm发射机构的射击热量
