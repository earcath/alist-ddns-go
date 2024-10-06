password=$(awk -F': ' '/initial password is/ {print $2}' /data/alist-ddns-go/logs/alist_run.log)
echo "初始密码为:"
echo $password