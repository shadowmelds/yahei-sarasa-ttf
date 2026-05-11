# 介绍

根据项目 [ZH-Font-Replacement](https://github.com/ReRokutosei/ZH-Font-Replacement) 将 更纱黑体 UI SC 的信息改为微软雅黑和 Segoe UI，用来替换 Windows 系统的默认字体。

根据[这篇帖子](https://bbs.pcbeta.com/forum.php?mod=viewthread&tid=1960120&extra=page%3D1&page=1)补充了：

1. SegUIVar.ttf
2. tahoma.ttf
3. tahomabd.ttf

根据 [yahei-sarasa](https://github.com/chenh96/yahei-sarasa) 补充了宋体：

1. simsun.ttc
2. simsunb.ttf

## 其他

推荐 Windows 11 英语版本，整体字体显示效果最好，资源管理器字体需要通过 [Explorer Font Changer](https://windhawk.net/mods/explorer-font-changer) 修改

如果不用 Explorer Font Changer，可能需要现将 Windows 显示语言设置为中文然后重启设备，再设置回英语重启设备来让字体好一点点，其他方式似乎都改不了资源管理器的字体。

# 备份

替换前可以运行 `BackupFonts.ps1` 将会被替换的系统字体备份到 `backup_fonts` 文件夹