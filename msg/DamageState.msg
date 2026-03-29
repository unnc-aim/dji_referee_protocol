# 伤害状态数据 (命令码: 0x0206)
# 伤害发生后发送

# 常量定义 (参考Constants.msg)
# DAMAGE_TYPE_PROJECTILE=0
# DAMAGE_TYPE_MODULE_OFFLINE=1
# DAMAGE_TYPE_IMPACT=5

uint8 armor_id        # 装甲模块或测速模块的ID编号
uint8 damage_type     # 血量变化类型
