password=$(awk -F': ' '/initial password is/ {print $2}' /data/alist-ddns-go/logs/alistrun.log)
echo "初始密码为:"
echo $password