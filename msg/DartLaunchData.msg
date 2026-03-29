# 飞镖发射相关数据 (命令码: 0x0105)
# 以1Hz频率发送

uint8 dart_remaining_time    # 己方飞镖发射剩余时间（秒）
uint8 last_hit_target        # 最近一次己方飞镖击中的目标
uint8 target_hit_count       # 对方最近被击中的目标累计被击中次数
uint8 selected_target        # 飞镖此时选定的击打目标
