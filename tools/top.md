# top
top命令是Linux下常用的性能分析工具，能够实时显示系统中各个进程的资源占用状况。top命令提供了实时的对系统处理器的状态监视.它将显示系统中CPU最“敏感”的任务列表而且该命令的很多特性都可以通过交互式命令或者在个人定制文件中进行设定, 如下：

```
[root@TG1704 log]# top
top - 14:06:23 up 70 days, 16:44,  2 users,  load average: 1.25, 1.32, 1.35
Tasks: 206 total,   1 running, 205 sleeping,   0 stopped,   0 zombie
Cpu(s):  5.9%us,  3.4%sy,  0.0%ni, 90.4%id,  0.0%wa,  0.0%hi,  0.2%si,  0.0%st
Mem:  32949016k total, 14411180k used, 18537836k free,   169884k buffers
Swap: 32764556k total,        0k used, 32764556k free,  3612636k cached
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                                                                
28894 root      22   0 1501m 405m  10m S 52.2  1.3   2534:16 java                                                                   
18249 root      18   0 3201m 1.9g  11m S 35.9  6.0 569:39.41 java                                                                   
 2808 root      25   0 3333m 1.0g  11m S 24.3  3.1 526:51.85 java                                                                   
25668 root      23   0 3180m 704m  11m S 14.0  2.2 360:44.53 java                                                                   
  574 root      25   0 3168m 611m  10m S 12.6  1.9 556:59.63 java                                                                   
 1599 root      20   0 3237m 1.9g  11m S 12.3  6.2 262:01.14 java                                                                   
 1008 root      21   0 3147m 842m  10m S  0.3  2.6   4:31.08 java                                                                   
13823 root      23   0 3031m 2.1g  10m S  0.3  6.8 176:57.34 java                                                                   
28218 root      15   0 12760 1168  808 R  0.3  0.0   0:01.43 top                                                                    
29062 root      20   0 1241m 227m  10m S  0.3  0.7   2:07.32 java                                                                   
```
几个关键的：
- **sy：** 内核态占用率
- **us：** 用户态占用率
- **si：** 软中断占用率
- **hi：** 硬中断占用率
- **id：** CPU空闲状态，一般100 - idle就为实际的占用率。

## 常用的命令参数
1. **-H：** 显示所有线程的信息，在定位多线程用户态的时候很有效。
2. **-i time：** 指定top的刷新频率，默认为3秒，当扫描时间频率太低时，看不出来实时的占用率情况，容易被误导；
3. **-p pid0,pid1：** 指定top现实的进程信息，可以和-H结合使用，显示所有进程的线程信息。

## 常用交互式命令
1. **1：** 在top界面按1，可以显示所有CPU核的占用信息，看整体的占用率对定位问题作用不大；
2. **f：** 按f后会跳出选择显示列的界面，使用上下键选择，并使用空格键进行确认，被选中的列会高亮显示，对于多核系统选择P，如下：

## Tips
在交互式命令修改的配置后，可以使用`shift + s`保存当前配置，会保持在根目录下的.toprc文件中，下次再使用top命令就不需要重复进行配置。
