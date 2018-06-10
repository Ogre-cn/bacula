# Bacula Restore Test V1.2 #

Bacula自动化恢复测试脚本，适用于bacula版本7.0以上

## v1.2版本更新： ##

1. 修改部分内容，使脚本更通用化
1. 修改FOR循环到后台执行
1. 增加自命名通道，定义FOR循环同时并发数量，减少对系统资源的占用，防止因资源不足产生错误
1. Wait+后台子SHELL执行并限制循环并发数量，可应对百个以上JOB恢复测试

## 功能： ##

- 通用性
- 自定义恢复测试文件数量
- 自定义循环并发数量
- 占用系统资源小 可同时恢复百个以上JOB

## 自定义参数： ##

- 恢复备份存储主机：RESTORE_CLIENT
- 恢复文件数量：FILES_PER_JOB
- 自命名管道文件：BAKFIFOFILE
- 循环并发数：CONCURRENT
- 恢复文件列表和恢复文件存储路径：/backup/vol1/BaculaRestoreTest/

## 注意事项： ##

bacula配置中client名称和Job名称命名规则

- client名称:服务器名 + -fd 例如：bakXXX-fd
Job名称：Backup+ 服务器名 例如：Backup-bakXXX
- 注意区分大小写和保持名称一致性

bacula-dir配置中的Job处理规则

- 长期不再做备份计划的client和对应的job 及时在配置中删除
- 临时或短期暂停备份计划的client和对应的job 及时在配置中注释掉 以防止自动恢复测试脚本读取到
