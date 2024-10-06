DATAPATH="/data/alist-ddns-go"

mkdir -p ${DATAPATH}

if [ -f "${DATAPATH}/config.json" ];then
    ui_print "- config.json 文件已存在，跳过覆盖"
    rm -rf ${MODPATH}/alist-ddns-go/config.json
fi

cp -af ${MODPATH}/alist-ddns-go/* ${DATAPATH}/
rm -rf ${MODPATH}/alist-ddns-go
