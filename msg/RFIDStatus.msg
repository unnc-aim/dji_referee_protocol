# 机器人RFID模块状态 (命令码: 0x0209)
# 以3Hz频率发送

uint32 detected_rfid_bits_low     # 检测到的RFID卡位掩码（低32位）
uint8 detected_rfid_bits_high     # 检测到的RFID卡位掩码（高8位）
