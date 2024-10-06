scripts=`realpath $0`
scripts_dir=`dirname ${scripts}`
. /data/alist-ddns-go/config.prop
. ${MODDIR}/logs.sh

update() {
    # 读取版本号
    alist_version=$(jq -r '.version.alist' "${config_file}")
    ddnsgo_version=$(jq -r '.version.ddnsgo' "${config_file}")

    log "info: 检查更新中..."
    version_retrieval alist

    if [ "${alist_version}" == "${latest_version}" ]; then
        log "info: alist 已为最新版"
    else
        log "info: 检测到 alist 新版本: ${latest_version}"
        log "info: 正在更新 alist"

        # 下载最新版本的 alist
        curl --progress-bar -L -o alist_android_arm64.tar.gz "${proxy}${download_link}"

        if [ ! -f "alist_android_arm64.tar.gz" ]; then
            log "err: alist 下载失败"
            return
        else
            log "info: alist 下载完成，开始替换旧版本"

            # 创建临时目录并解压文件
            [ ! -d ${DATAPATH}/bin/temp ] && mkdir -p ${DATAPATH}/bin/temp
            tar -xzvf alist_android_arm64.tar.gz -C ${DATAPATH}/bin/temp

            # 替换旧版本
            if [ -f ${DATAPATH}/bin/temp/alist ]; then
                mv -f ${DATAPATH}/bin/temp/alist ${DATAPATH}/bin/alist
                rm -rf ${DATAPATH}/bin/temp
                rm -rf alist_android_arm64.tar.gz

                # 设置权限
                chmod 6755 ${DATAPATH}/bin/alist
                log "info: alist 更新完成"

                # 写入版本
                jq --arg alist_version "$latest_version" \
                   '.version.alist = $alist_version' \
                   "$config_file" > temp.json && mv temp.json "$config_file"
            else
                log "err: alist 更新失败"
            fi
        fi
    fi

    version_retrieval ddns-go

    if [ "${ddnsgo_version}" == "${latest_version}" ]; then
        log "info: ddns-go 已为最新版"
    else
        log "info: 检测到 ddns-go 新版本: ${latest_version}"
        log "info: 正在更新 ddns-go"

        # 下载最新版本的 ddns-go
        curl --progress-bar -L -o ddns-go_android_arm64.tar.gz "${proxy}${download_link}"

        if [ ! -f "ddns-go_android_arm64.tar.gz" ]; then
            log "err: ddns-go 下载失败"
            return
        else
            log "info: ddns-go 下载完成，开始替换旧版本"

            # 创建临时目录并解压文件
            [ ! -d ${DATAPATH}/bin/temp ] && mkdir -p ${DATAPATH}/bin/temp
            tar -xzvf ddns-go_android_arm64.tar.gz -C ${DATAPATH}/bin/temp

            # 替换旧版本
            if [ -f ${DATAPATH}/bin/temp/ddns-go ]; then
                mv -f ${DATAPATH}/bin/temp/ddns-go ${DATAPATH}/bin/ddns-go
                rm -rf ${DATAPATH}/bin/temp
                rm -rf ddns-go_android_arm64.tar.gz

                # 设置权限
                chmod 6755 ${DATAPATH}/bin/ddns-go
                log "info: ddns-go 更新完成"

                # 写入版本
                jq --arg ddnsgo_version "$latest_version" \
                   '.version.ddnsgo = $ddnsgo_version' \
                   "$config_file" > temp.json && mv temp.json "$config_file"
            else
                log "err: ddns-go 更新失败"
            fi
        fi
    fi

    exit
}

version_retrieval() {
    if [ "${1}" = "alist" ]; then
        REPO="alist-org/alist"
    elif [ "${1}" = "ddns-go" ]; then
        REPO="jeessy2/ddns-go"
    fi

    API_URL="https://api.github.com/repos/${REPO}/releases/latest"

    # 获取最新版本信息
    api_response=$(curl -s "${API_URL}")

    # 提取最新的版本号
    latest_version=$(echo "${api_response}" | jq -r '.tag_name' | sed 's/^v//')

    if [ -z "${latest_version}" ]; then
        log "err: 未能获取到最新版本号" >&2
        return
    fi

    # 构造下载链接
    if [ "${1}" = "ddns-go" ]; then
        filename="ddns-go_${latest_version}_android_arm64.tar.gz"
        download_link="https://github.com/${REPO}/releases/download/v${latest_version}/${filename}"
    elif [ "${1}" = "alist" ]; then
        filename="alist-android-arm64.tar.gz"
        download_link="https://github.com/${REPO}/releases/latest/download/${filename}"
    fi
}

while getopts "u" signal; do
    case ${signal} in
        u)
            update
            ;;
        ?)
            echo "无效参数: -${OPTARG}"
            ;;
    esac
done
