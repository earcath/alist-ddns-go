#!/system/bin/sh

ghproxy="https://mirror.ghproxy.com/"
bin_path="/data/alist-ddns-go/bin"
obtain_alist_filename="alist-android-arm64.tar"
alist_version_path="/data/alist-ddns-go/alist/version/version.txt"
alist_data_path="/data/alist-ddns-go/alist"
alist_log_module="/data/alist-ddns-go/logs/alist-module.log"
alist_log_run="/data/alist-ddns-go/logs/alist-run.log"

export PATH="${bin_path}:${PATH}"

alist_version_local="$(cat ${alist_version_path} | tr -d '[:space:]')"
alist_version_remote="$(curl --silent "https://api.github.com/repos/alist-org/alist/tags" | jq -r '.[] | .name' | sort -V | tail -n 1)"

log(){
    echo "`TZ=Asia/Shanghai date "+%Y/%m/%d %H:%M:%S"` $1" >> ${alist_log_module}
}

update_alist(){
    log " 检查更新中…"

    if [ "${alist_version_local}" == "${alist_version_remote}" ]; then
        log "info: 当前为最新版${alist_version_local}"
    else
        log "info: 本地版本为: ${alist_version_local}, 最新版为: ${alist_version_remote}"
        log "info: 正在更新Alist"

        wget -T 10 -q -P ${alist_data_path}/temp "${ghproxy}https://github.com/alist-org/alist/releases/latest/download/${obtain_alist_filename}.gz"

        busybox tar -zxf ${alist_data_path}/temp/${obtain_alist_filename}.gz -C ${alist_data_path}/temp

        if [ -f ${alist_data_path}/temp/alist ]; then
            rm -f ${alist_data_path}/bin/alist
            mv ${alist_data_path}/temp/alist ${alist_data_path}/bin/alist
            chmod +x ${alist_data_path}/bin/alist
            echo "${alist_version_remote}" > ${alist_version_path}
            find ${alist_data_path}/temp -mindepth 1 -delete
            log "info: 更新完成"
        else
            find ${alist_data_path}/temp -mindepth 1 -delete
            log "err: 更新失败"
            return
        fi
    fi
}

start_alist(){
    log "info: 启动Alist"
    ${alist_data_path}/bin/alist server --data ${alist_data_path}/data >> ${alist_log_run} 2>&1
}

stop_alist(){
    log "info: 已停止Alist"
    kill -9 $(pgrep alist)
}

while getopts ":sku" signal; do
    case ${signal} in
        s)
            start_alist
            ;;
        k)
            stop_alist
            ;;
        u)
            update_alist
            ;;
        ?)
            echo ""
            ;;
    esac
done
