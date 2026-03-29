# 选手端小地图接收机器人数据 (命令码: 0x0308)
# 频率上限为3Hz

uint16 sender_id       # 发送者的ID
uint16 receiver_id     # 接收者的ID
string message         # 字符消息（UTF-16编码，最多30字符）
