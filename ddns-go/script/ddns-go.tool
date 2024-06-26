#!/system/bin/sh

ghproxy="https://mirror.ghproxy.com/"
bin_path="/data/alist-ddns-go/bin"
ddnsgo_version_path="/data/alist-ddns-go/ddns-go/version/version.txt"
ddnsgo_data_path="/data/alist-ddns-go/ddns-go"
ddnsgo_log_module="/data/alist-ddns-go/logs/ddns-go-module.log"
ddnsgo_log_run="/data/alist-ddns-go/logs/ddns-go-run.log"

export PATH=${bin_path}:${PATH}

ddnsgo_version_local="$(cat ${ddnsgo_version_path} | tr -d '[:space:]')"
ddnsgo_version_remote="$(curl --silent "https://api.github.com/repos/jeessy2/ddns-go/tags" | jq -r '.[] | .name' | sort -V | tail -n 1)"
obtain_ddnsgo_version="$(curl --silent "https://api.github.com/repos/jeessy2/ddns-go/tags" | jq -r '.[] | .name' | sort -V | tail -n 1 | tr -d 'v')"

obtain_ddnsgo_filename="ddns-go_${obtain_ddnsgo_version}_android_arm64.tar"

log(){
    echo "`TZ=Asia/Shanghai date "+%Y/%m/%d %H:%M:%S"` $1" >> ${ddnsgo_log_module}
}

update_ddnsgo(){
    log " 检查更新中…"

    if [ "${ddnsgo_version_local}" == "${ddnsgo_version_remote}" ]; then
        log "info: 当前为最新版${ddnsgo_version_local}"
    else
        log "info: 本地版本为: ${ddnsgo_version_local}, 最新版为: ${ddnsgo_version_remote}"
        log "info: 正在更新ddns-go"

        
        wget -T 10 -q -P ${ddnsgo_data_path}/temp "${ghproxy}https://github.com/jeessy2/ddns-go/releases/latest/download/${obtain_ddnsgo_filename}.gz"

        busybox tar -zxf ${ddnsgo_data_path}/temp/${obtain_ddnsgo_filename}.gz -C ${ddnsgo_data_path}/temp

        if [ -f ${ddnsgo_data_path}/temp/ddns-go ]; then
            rm -f ${ddnsgo_data_path}/bin/ddns-go
            mv ${ddnsgo_data_path}/temp/ddns-go ${ddnsgo_data_path}/bin/ddns-go
            chmod +x ${ddnsgo_data_path}/bin/ddns-go
            echo "${ddnsgo_version_remote}" > ${ddnsgo_version_path}
            find ${ddnsgo_data_path}/temp -mindepth 1 -delete
            log "info: 更新完成"
        else
            find ${ddnsgo_data_path}/temp -mindepth 1 -delete
            log "err: 更新失败"
            return
        fi
    fi
}

start_ddnsgo(){
    log "info: 启动ddns-go"
    ${ddnsgo_data_path}/bin/ddns-go -dns 223.5.5.5 -c ${ddnsgo_data_path}/config/ddns_go_config.yaml >> ${ddnsgo_log_run} 2>&1
}

stop_ddnsgo(){
    log "info: 已停止ddns-go"
    kill -9 $(pgrep ddns-go)
}

while getopts ":sku" signal; do
    case ${signal} in
        s)
            start_ddnsgo
            ;;
        k)
            stop_ddnsgo
            ;;
        u)
            update_ddnsgo
            ;;
        ?)
            echo ""
            ;;
    esac
done
