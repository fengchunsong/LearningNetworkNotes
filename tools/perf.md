# perf���
    Perf��������Linux�ں�Դ�����е���������(profiling)���ߡ�
�������¼�����ԭ���������¼�Ϊ������֧����Դ������������ָ�������ϵͳ�������ָ�������������
����������ƿ���Ĳ������ȵ����Ķ�λ��
 
    CPU����(cpu-cycles)��Ĭ�ϵ������¼�����ν��CPU������ָCPU����ʶ�����Сʱ�䵥Ԫ��ͨ��Ϊ�ڷ�֮���룬
��CPUִ����򵥵�ָ��ʱ����Ҫ��ʱ�䣬�����ȡ�Ĵ����е����ݣ�Ҳ����clock tick��
 
Perf��һ������22���ӹ��ߵĹ��߼�����������õ�5�֣�
- perf-list
- perf-top
- perf-record
- perf-report

# �����÷�

## perf-list

    Perf-list�����鿴perf��֧�ֵ������¼����������Ҳ��Ӳ���ġ�
 
1. �����¼��ķֲ�
	- hw��Hardware event��9��
	- sw��Software event���ں˵ļ���������Ӳ���޹�, 9��
	- cache��Hardware cache event����CPU�ܹ���صģ������ھ���Ӳ����26��
	- tracepoint��Tracepoint event���ǻ����ں˵�ftrace��775��
 
2. ָ�������¼�(����������)
	- -e <event> : u // userspace
	- -e <event> : k // kernel
	- -e <event> : h // hypervisor
	- -e <event> : G // guest counting (in KVM guests)
	- -e <event> : H // host counting (not in KVM guests)
 
3. ʹ������
```
��ʾ�ں˺�ģ���У��������CPU���ڵĺ�����
   # perf top -e cycles:k
��ʾ������ٻ������ĺ�����
   # perf top -e kmem:kmem_cache_alloc
```

## perf-top

    perf top��Ҫ����ʵʱ��������������ĳ�������¼��ϵ��ȶȣ��ܹ����ٵĶ�λ�ȵ㺯��������Ӧ�ó�������
ģ�麯�����ں˺����������ܹ���λ���ȵ�ָ�Ĭ�ϵ������¼�Ϊcpu cycles��

1. �����ʽ

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
��һ�У����������������¼��ı�����Ĭ��ָռ�õ�cpu���ڱ�����
�ڶ��У��������ڵ�DSO(Dynamic Shared Object)��������Ӧ�ó����ںˡ���̬���ӿ⡢ģ�顣
�����У�DSO�����͡�[.]��ʾ�˷��������û�̬��ELF�ļ���������ִ���ļ��붯̬���ӿ�)��[k]�����˷��������ں˻�ģ�顣
�����У�����������Щ���Ų��ܽ���Ϊ��������ֻ���õ�ַ��ʾ��
 
2. ���������в���
	- -e <event>��ָ��Ҫ�����������¼���
	- -p <pid>��Profile events on existing Process ID (comma sperated list). ������Ŀ����̼��䴴�����̡߳�
	- -d <n>�������ˢ�����ڣ�Ĭ��Ϊ2s����Ϊperf topĬ��ÿ2s��mmap���ڴ������ȡһ���������ݡ�
	- -G���õ������ĵ��ù�ϵͼ��
	- -C: ָ��CPU�ˡ�
 
3. ʹ������
```
# perf top // Ĭ������
# perf top -G // �õ����ù�ϵͼ
# perf top -e cycles // ָ�������¼�
# perf top -p 23015,32476 // �鿴���������̵�cpu cyclesʹ�����
# perf top -s comm,pid,symbol // ��ʾ����symbol�Ľ������ͽ��̺�
# perf top --symbols kfree // ����ʾָ���ķ���
```

## perf-report and perf-record

perf-record�ռ�������Ϣ���������¼�������ļ��У�Ĭ�ϱ����ڵ�ǰĿ¼��perf.data�ļ��С�������ͨ����������(perf-report)�������ļ����з��������������perf-top�ġ�
 
1. ���ò���
	- -e��ָ��Ҫ�����������¼���
	- -a���ռ�����CPU���¼���
	- -p������¼Ŀ����̼��䴴�����̡߳�
	- -o��ָ������ļ���.
	- `-g����ʾ���ù�ϵͼ.`
	- -C��ָ��ĳ��CPU�˵������¼�
 
2. ʹ������
```
��¼nginx���̵��������ݣ�
# perf record -p `pgrep -d ',' nginx`
��¼ִ��lsʱ���������ݣ�
# perf record ls -g
��¼ִ��lsʱ��ϵͳ���ã�����֪����Щϵͳ������Ƶ����
# perf record -e syscalls:sys_enter ls
```

3.�ռ����ݺ�ʹ��perf-report���ж�ȡ�ļ���������������õĲ���Ϊ-iָ��������ļ���Ĭ��Ϊ��ǰĿ¼�µ�perf.data�ļ���


������http://blog.csdn.net/zhangskd/article/details/37902159/

