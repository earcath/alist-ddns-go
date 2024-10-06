# 检查并创建日志目录
[ ! -d "$LOG_DIR" ] && mkdir -p "$LOG_DIR"

# 检查旧日志文件的大小，如果超过1MB则轮转日志
FILE_SIZE=$(stat -c%s "$LOGS_FILE" 2>/dev/null || echo 0)
if [ "$FILE_SIZE" -ge 512000 ]; then
    rm "$LOGS_FILE.gz"
    gzip "$LOGS_FILE"

    > "$LOGS_FILE"
fi

log() {
    local message="$1"
    local timestamp=$(TZ=Asia/Shanghai date "+%Y-%m-%d %H:%M:%S")

    echo "[$timestamp] $message" >> "$LOGS_FILE"
    echo "$message"
}
