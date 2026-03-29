# 实时射击数据 (命令码: 0x0207)
# 弹丸发射后发送

# 常量定义 (参考Constants.msg)
# PROJECTILE_TYPE_17MM=1
# PROJECTILE_TYPE_42MM=2
# SHOOTER_ID_17MM=1
# SHOOTER_ID_42MM=3

uint8 bullet_type             # 弹丸类型 (1:17mm, 2:42mm)
uint8 shooter_id              # 发射机构ID (1:17mm, 3:42mm)
uint8 launching_frequency     # 弹丸射速（单位：Hz）
float32 initial_speed         # 弹丸初速度（单位：m/s）
