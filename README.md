<div align="right">
<a href="/README.md">中文</a> &nbsp;|&nbsp;
<a href="/README_en-US.md">EN</a>
</div>

<div align="center">
<h1>alist-ddns-go</h1>
</div>

这是一个Magisk模块，它为安卓系统提供了Alist和ddns-go服务支持

![Release](https://img.shields.io/github/tag/liangsuimansui/alist-ddns-go?style=flat-square&label=Release) ![Stars](https://img.shields.io/github/stars/liangsuimansui/alist-ddns-go?style=flat-square&label=Stars&logo=github "GitHub Repo stars") ![Downloads](https://img.shields.io/github/downloads/liangsuimansui/alist-ddns-go/total?style=flat-square&label=Download&logo=github)

[![Coolapk](https://img.shields.io/badge/酷安-良岁-hotpink?style=flat-square)](http://www.coolapk.com/u/11696005)

# 模块工作目录
`data/alist-ddns-go`

# 使用教程&说明
> ## Alist官方文档
> #### https://alist.nn.ci/zh/

> ## ddns-go的GitHub仓库
> #### https://github.com/jeessy2/ddns-go

> ## 提示
> 首次安装Alist的账号为：`admin`
> 密码在文件`/data/alist-ddns-go/logs/alist_run.log`中的`Successfully created the admin user and the initial password is:`

> [!NOTE]
> 对于模块来说，原文档提供的命令将无法使用，模块提供了脚本来打开或关闭对应功能，脚本位于
> 
> `/data/alist-ddns-go/alist/tools`
> 
> `/data/alist-ddns-go/ddns-go/tools`
> 
> 当然，也可以通过命令的方式控制功能，详细命令如下：
> ```
> # 打开Alist
> /data/alist-ddns-go/alist/script/alist.tool -s
> # 关闭Alist
> /data/alist-ddns-go/alist/script/alist.tool -k
> # 更新Alist
> /data/alist-ddns-go/alist/script/alist.tool -u
> # 打开ddns-go
> /data/alist-ddns-go/ddns-go/script/ddns-go.tool -s
> # 关闭ddns-go
> /data/alist-ddns-go/ddns-go/script/ddns-go.tool -k
> # 更新ddns-go
> /data/alist-ddns-go/ddns-go/script/ddns-go.tool -u
> ```
> 此外，模块会在每天上午8点钟自动检查更新



