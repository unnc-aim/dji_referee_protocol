# 对方各机器人当前增益效果 (命令码: 0x0A05)
# 雷达无线链路数据，频率上限为10Hz

# 常量定义 (参考Constants.msg)
# SENTRY_POSTURE_ATTACK=1
# SENTRY_POSTURE_DEFENSE=2
# SENTRY_POSTURE_MOVE=3

# 对方英雄机器人增益
uint8 hero_recovery
uint16 hero_cooling
uint8 hero_defence
uint8 hero_vulnerability
uint16 hero_attack

# 对方工程机器人增益
uint8 engineer_recovery
uint16 engineer_cooling
uint8 engineer_defence
uint8 engineer_vulnerability
uint16 engineer_attack

# 对方3号步兵机器人增益
uint8 infantry_3_recovery
uint16 infantry_3_cooling
uint8 infantry_3_defence
uint8 infantry_3_vulnerability
uint16 infantry_3_attack

# 对方4号步兵机器人增益
uint8 infantry_4_recovery
uint16 infantry_4_cooling
uint8 infantry_4_defence
uint8 infantry_4_vulnerability
uint16 infantry_4_attack

# 对方哨兵机器人增益
uint8 sentry_recovery
uint16 sentry_cooling
uint8 sentry_defence
uint8 sentry_vulnerability
uint16 sentry_attack
uint8 sentry_posture    # 哨兵当前姿态
