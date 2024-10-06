MODDIR="${0%/*}"
DATAPATH="/data/alist-ddns-go"


chmod +x ${DATAPATH}/scripts/*
chmod +x ${DATAPATH}/bin/*
chmod +x ${DATAPATH}/config.prop
chmod +x ${DATAPATH}/config.env

until [ $(getprop init.svc.bootanim) = "stopped" ] ; do
    sleep 5
done

${DATAPATH}/scripts/tool.sh -u
nohup ${DATAPATH}/scripts/service.sh -s &
