# perf简介
    Perf是内置于Linux内核源码树中的性能剖析(profiling)工具。
它基于事件采样原理，以性能事件为基础，支持针对处理器相关性能指标与操作系统相关性能指标的性能剖析。
常用于性能瓶颈的查找与热点代码的定位。
 
    CPU周期(cpu-cycles)是默认的性能事件，所谓的CPU周期是指CPU所能识别的最小时间单元，通常为亿分之几秒，
是CPU执行最简单的指令时所需要的时间，例如读取寄存器中的内容，也叫做clock tick。
 
Perf是一个包含22种子工具的工具集，以下是最常用的5种：
- perf-list
- perf-top
- perf-record
- perf-report

# 常用用法

## perf-list

    Perf-list用来查看perf所支持的性能事件，有软件的也有硬件的。
 
1. 性能事件的分布
	- hw：Hardware event，9个
	- sw：Software event，内核的计数器，与硬件无关, 9个
	- cache：Hardware cache event，与CPU架构相关的，依赖于具体硬件，26个
	- tracepoint：Tracepoint event，是基于内核的ftrace，775个
 
2. 指定性能事件(以它的属性)
	- -e <event> : u // userspace
	- -e <event> : k // kernel
	- -e <event> : h // hypervisor
	- -e <event> : G // guest counting (in KVM guests)
	- -e <event> : H // host counting (not in KVM guests)
 
3. 使用例子
```
显示内核和模块中，消耗最多CPU周期的函数：
   # perf top -e cycles:k
显示分配高速缓存最多的函数：
   # perf top -e kmem:kmem_cache_alloc
```

## perf-top

    perf top主要用于实时分析各个函数在某个性能事件上的热度，能够快速的定位热点函数，包括应用程序函数、
模块函数与内核函数，甚至能够定位到热点指令。默认的性能事件为cpu cycles。

1. 输出格式

```
# perf top
Samples: 1M of event 'cycles', Event count (approx.): 73891391490  
     5.44%  perf              [.] 0x0000000000023256        
     4.86%  [kernel]          [k] _spin_lock                
     2.43%  [kernel]          [k] _spin_lock_bh             
     2.29%  [kernel]          [k] _spin_lock_irqsave        
     1.77%  [kernel]          [k] __d_lookup                
     1.55%  libc-2.12.so      [.] __strcmp_sse42            
     1.43%  nginx             [.] ngx_vslprintf             
     1.37%  [kernel]          [k] tcp_poll     
```	 
第一列：符号引发的性能事件的比例，默认指占用的cpu周期比例。
第二列：符号所在的DSO(Dynamic Shared Object)，可以是应用程序、内核、动态链接库、模块。
第三列：DSO的类型。[.]表示此符号属于用户态的ELF文件，包括可执行文件与动态链接库)。[k]表述此符号属于内核或模块。
第四列：符号名。有些符号不能解析为函数名，只能用地址表示。
 
2. 常用命令行参数
	- -e <event>：指明要分析的性能事件。
	- -p <pid>：Profile events on existing Process ID (comma sperated list). 仅分析目标进程及其创建的线程。
	- -d <n>：界面的刷新周期，默认为2s，因为perf top默认每2s从mmap的内存区域读取一次性能数据。
	- -G：得到函数的调用关系图。
	- -C: 指定CPU核。
 
3. 使用例子
```
# perf top // 默认配置
# perf top -G // 得到调用关系图
# perf top -e cycles // 指定性能事件
# perf top -p 23015,32476 // 查看这两个进程的cpu cycles使用情况
# perf top -s comm,pid,symbol // 显示调用symbol的进程名和进程号
# perf top --symbols kfree // 仅显示指定的符号
```

## perf-report and perf-record

perf-record收集采样信息，并将其记录在数据文件中，默认保存在当前目录的perf.data文件中。随后可以通过其它工具(perf-report)对数据文件进行分析，结果类似于perf-top的。
 
1. 常用参数
	- -e：指明要分析的性能事件。
	- -a：收集所有CPU核事件。
	- -p：仅记录目标进程及其创建的线程。
	- -o：指定输出文件名.
	- `-g：显示调用关系图.`
	- -C：指定某个CPU核的性能事件
 
2. 使用例子
```
记录nginx进程的性能数据：
# perf record -p `pgrep -d ',' nginx`
记录执行ls时的性能数据：
# perf record ls -g
记录执行ls时的系统调用，可以知道哪些系统调用最频繁：
# perf record -e syscalls:sys_enter ls
```

3.收集数据后，使用perf-report进行读取文件并分析结果，常用的参数为-i指定输入的文件，默认为当前目录下的perf.data文件。


引用自http://blog.csdn.net/zhangskd/article/details/37902159/

