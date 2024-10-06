<div align="right">
<a href="/README.md">中文</a> &nbsp;|&nbsp;
<a href="/README_en-US.md">EN</a>
</div>

<div align="center">
<h1>alist-ddns-go</h1>
</div>

这是一个Magisk模块，它为安卓系统提供了Alist和ddns-go服务支持

![Release](https://img.shields.io/github/tag/earcath/alist-ddns-go?style=flat-square&label=Release) ![Stars](https://img.shields.io/github/stars/earcath/alist-ddns-go?style=flat-square&label=Stars&logo=github "GitHub Repo stars") ![Downloads](https://img.shields.io/github/downloads/earcath/alist-ddns-go/total?style=flat-square&label=Download&logo=github)

# 模块工作目录
`data/alist-ddns-go`

# 使用教程&说明
> ## Alist官方文档
> #### https://alist.nn.ci/zh/

> ## ddns-go的GitHub仓库
> #### https://github.com/jeessy2/ddns-go

> ## 提示
> 首次安装时Alist的账号为：`admin`
>
> 密码可在 `/data/alist-ddns-go/tools` 中使用 `快速获取初始密码.sh` 脚本获取
>
> 另外，这里提供一些ddns-go通过接口获取ip的接口：
>
> ipv4:
> ```
> https://myip4.ipip.net,https://ddns.oray.com/checkip,https://ip.3322.net,https://4.ipw.cn,https://ipinfo.io,https://cip.cc,https://ident.me,https://v4.ident.me
> ```
> ipv6:
> ```
> https://ipv6.ddnspod.com,https://api-ipv6.ip.sb/ip,https://v6.myip.la/json
> ```

> [!NOTE]
> 对于模块来说，原文档提供的命令将无法使用，模块提供了脚本来打开或关闭对应功能，脚本位于
> 
> `/data/alist-ddns-go/tools`
