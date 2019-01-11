## 程序功能

程序使用Java多线程编程实现，通过命令行参数可以执行该程序相对应的jar包，通过输入不同的参数可以得到**快速排序**、**归并排序**和**枚举排序**的串行和并行运行的结果，并且得到相应的运行时间。

### 并行算法伪代码

1. 快速排序的并行化算法伪代码

    ```cpp
        Input: 1. unordered data[1,n] 2. the number of processors: 2^m
        Output: 1. ordered data[1,n]

        Begin
            para_quicksort(data,1,n,m,0);
        End

        procedure para_quicksort(data,i,j,m,id)
        Begin
            if (j‐i)≤k or m=0 then
                (1.1)P_id call quicksort(data,i,j)
            else
                (1.2)P_id: r=partition(data,i,j)
                (1.3)P_id send data[r+1,j] to P_id+2^m‐1
                (1.4)para_quicksort(data,i,r‐1,m‐1,id)
                (1.5)para_quicksort(data,r+1,j,m‐1,id+2^m‐1)
                (1.6)P_id+2􏰀^m‐1 send data[r+1,j] back to P_id
            end if
        End
    ```
    
2. 归并排序的并行化算法伪代码

    ```cpp
        Input: 1. unordered data[1,n] 2. the number of processors: 2^m
        Output: 1. ordered data[1,n]

        Begin
            para_mergesort(data,1,n,m,0);
        End

        procedure para_mergesort(data,i,j,m,id)
        Begin
            if (j‐i)≤k or m=0 then
                (1.1)P_id call mergesort(data,i,j)
            else
                (1.2)mid = (i+j)/2
                (1.3)P_id send data[i,mid] to P_id+2^m‐1
                (1.4)P_id send data[i,mid] to P_id+2^m
                (1.5)para_mergesort(data,i,mid,m‐1,P_i+2^m)
                (1.6)para_mergesort(data,mid+1,j,m‐1,id+2^m‐1)
                (1.7)P_id+2^m􏰀‐1 send data[i,mid] back to P_id
                (1.8)P_id+2􏰀^m send data[mid+1,j] back to P_id
                (1.9)P_id: merge(data,i,j)
            end if
        End
    ```

3. 枚举排序的并行化算法伪代码

    ```cpp
        Input: 1. unordered data[1,n] 2. the number of processors: n
        Output: 1. ordered data[1,n]

        Begin
            (1)P0播送a[1]...a[n]给所有Pi 
            (2)for all Pi where 1≤i≤n para‐do 
                (2.1)k=1
                (2.2)forj= 1 to n do
                        if (a[i] > a[j]) or (a[i] =a[j] and i>j)
                            k = k+1
                        end if
                    end for
                end for
            (3)P0收集k并按序定位
        End
    ```

### 算法运行时间

| 时间\排序 | 快速排序 | 归并排序  | 枚举排序 |
| :---- | :------------ | :-------------- | :-----|
| 单核并行化 | 44s      | 56s | 2610s |
| 多核并行化 | 10s      | 12s | 2380s |
| 串行化 | 41s      | 36s        |   3919s |

### 并行化算法在单核或多核下时间与线程的关系图

1. 下图展示了快速排序和归并排序的并行化算法的运行耗时与线程之间的关系，不难发现每次程序运行一开始耗时都比串行的算法要更多，可能是由于单核运行所以线程切换消耗大量时间，但是随着程序反复运行，操作系统可能提升了该程序优先级，分配了多核，导致后续的耗时逐渐下降。可能进入多核运算。

    ![img](https://github.com/SinestroEdmonce/ParallelComputingProject/raw/master/src/Img/Threads-Times_Q_M.png)

2. 下图展示了枚举排序的并行化算法的运行耗时与线程之间的关系，可以发现随着线程数的增加，大体趋势是耗时不断下降然后趋于稳定（线程切换耗时基本抵消多线程并行带来的收益）。

    ![img](https://github.com/SinestroEdmonce/ParallelComputingProject/raw/master/src/Img/Threads-Times_E.png)

### 技术要点

- 在性能优化上，我在实验中使用的平台是``Intellij IDEA Community 2018.2``，在平台中直接运行此次程序我发现，快速排序和归并排序的并行化算法的运行时间反而略长于它们两者的串行算法，尤其是当使用的线程数增加的情况下，时间反而更长。究其原因，可能是因为在``IDEA``平台上是单核伪并行，主要采用了单核分时分片的调度原则，所以从时间角度上来说并未有减少，反而由于其切换线程导致额外的时间消耗。而枚举排序的并行化算法的耗时则明显的短于其串行化的算法。

- 为了尽可能的测试多核运行，我采用了直接在命令行运行``java -jar xxx.jar``的方法，试图让具有``jdk1.8``环境的操作系统本身直接运行该程序，让操作系统的调度程序来决定调度策略，由于本机的cpu是多核的，所以可能会进入多核调度。并且为了测试程序性能，在命令行参数中设置了``-t``选项，用于设定最大层数``t``（线程数则是``2^t-1``），并且设置了``-n``选项，用于设定每次重新运行程序时最大层数的递减值``n``，也就是说每次重新运行排序算法将会讲最大层数设置为``t-n*times``。在最终实验中发现，这样的方法有很大概率使用多核处理，快速排序和归并排序的并行化算法的耗时大大减少。

- 除了以上两点以外，在程序中为了避免线程溢出，采用了设定阈值的方法，一定线程数超过阈值，则有两种方式解决，一是不再创建新的线程，直接将剩下的任务在该线程上完成，二是创建新的线程，但是知道有线程结束以后再创建，也就是说当前线程将被堵塞，进入``Runnable``状态等待重新调度，或者直接进入``Sleeping``状态等待有线程空间后唤醒。

## 程序运行方法

- 首先要求具有``jdk1.8``环境，可以在命令行运行``java -jar xxx.jar``。

- 其次要求具有``mvn``命令，在程序根目录执行``mvn install``可以得到可执行的jar包。执行``mvn clean``清楚所有中间或生成的文件及jar包。

- 具体的运行方法及参数选项如下：

    ```cpp
        : -sq         enable the serial quick sorting
        : -se         enable the serial enumeration sorting
        : -sm         enable the serial merge sorting
        : -pq         enable the parallel quick sorting
        : -pe         enable the parallel enumeration sorting
        : -pm         enable the parallel merge sorting
        : -t          the maximum number of threads that can be created
        : -n          The number that be reduced on the amount of threads every time
        : -s          input the data source path
        : -r          input the result storage path
        : -h          see the simple user manual
    ```
    
    运行实例如下：  
    ``java -jar Parallel_Serial_Sorting.jar -pq -t 10 -n 2 -s ./random.txt -r ./parallel_quicksort_result.txt`` 该命令将会执行快速排序的并行化算法，并且最大层数设置为10层，一共执行5次，每次执行程序，其最大层数将比上一次减少2层。数据文件应放置于和jar包同一层的目录下，结果文件存储在相同目录的``parallel_quicksort_result.txt``文件中。  

    ``java -jar Parallel_Serial_Sorting.jar -sq -s ./random.txt -r ./serial_quicksort_result.txt`` 该命令将会执行快速排序的串行化算法，无其他参数。数据文件应放置于和jar包同一层的目录下，结果文件存储在相同目录的``serial_quicksort_result.txt``文件中。

- 结果文件存放在压缩包中：``order1.txt``是快速排序串行化算法结果，``order2.txt``是枚举序串行化算法结果，``order3.txt``是归并排序串行化算法结果，``order4.txt``是快速排序并行化算法结果，``order5.txt``是归并排序并行化算法结果，``order6.txt``是枚举排序并行化算法结果。