scripts=`realpath $0`
scripts_dir=`dirname ${scripts}`
. /data/alist-ddns-go/config.prop
. ${MODDIR}/logs.sh

service_start() {
    enable_alist=$(jq -r '.features.enable_alist' "${config_file}")
    if [ "${enable_alist}" = "true" ]; then
        if [ ! -f "${DATAPATH}/bin/alist" ]; then
            log "err: 未找到 alist 文件"
            exit
        fi
        log "info: 启动Alist"
        alist server --data ${DATAPATH}/data > ${ALIST_RUN_LOG} 2>&1 &
    fi

    enable_ddnsgo=$(jq -r '.features.enable_ddnsgo' "${config_file}")
    if [ "${enable_ddnsgo}" = "true" ]; then
        if [ ! -f "${DATAPATH}/bin/ddns-go" ]; then
            log "err: 未找到 ddns-go 文件"
            exit
        fi
        log "info: 启动ddns-go"
        ddns-go -dns 119.29.29.29 -c ${DATAPATH}/config/ddns_go_config.yaml > ${DDNSGO_RUN_LOG} 2>&1 &
    fi
    exit
}

service_stop() {
    # 检查 alist 进程是否存在
    if pgrep -x "alist" > /dev/null; then
        log "info: alist 正在运行，正在终止..."

        # 获取 alist 进程的 PID 并发送 SIGTERM 信号
        pids=$(pgrep -x "alist")
        for pid in $pids; do
            log "info: Sending SIGTERM to PID $pid"
            kill -15 "$pid"
            sleep 1  # 等待一段时间让进程有机会正常退出

            # 检查进程是否仍然存在
            if kill -0 "$pid" > /dev/null 2>&1; then
                log "info: PID $pid 未响应 SIGTERM，发送 SIGKILL..."
                kill -9 "$pid"
            fi
        done
        log "info: alist 已被终止"
    else
        log "warn: alist 没有在运行"
    fi

    # 检查 ddns-go 进程是否存在
    if pgrep -x "ddns-go" > /dev/null; then
        log "info: ddns-go 正在运行，正在终止..."

        # 获取 ddns-go 进程的 PID 并发送 SIGTERM 信号
        pids=$(pgrep -x "ddns-go")
        for pid in $pids; do
            log "info: Sending SIGTERM to PID $pid"
            kill -15 "$pid"
            sleep 1  # 等待一段时间让进程有机会正常退出

            # 检查进程是否仍然存在
            if kill -0 "$pid" > /dev/null 2>&1; then
                log "info: PID $pid 未响应 SIGTERM，发送 SIGKILL..."
                kill -9 "$pid"
            fi
        done
        log "info: ddns-go 已被终止"
    else
        log "warn: ddns-go 没有在运行"
    fi
    exit
}

while getopts "sk" signal; do
    case ${signal} in
        s)
            service_start
            ;;
        k)
            service_stop
            ;;
        ?)
            echo "无效参数: -${OPTARG}"
            ;;
    esac
done
