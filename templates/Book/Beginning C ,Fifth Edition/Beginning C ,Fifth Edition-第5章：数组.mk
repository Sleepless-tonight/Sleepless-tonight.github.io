# Beginning C ,Fifth Edition

## 第5章 数组

我们经常需要在程序中存储某种类型的大量数据值。例如,如果编写一个程序,追踪一支篮球队的成绩,就要存储一个赛季的各场分数和各个球员的得分,然后输出某个球员的整季得分,或在赛事进行过程中计算出赛季的平均得分。我们可以利用前面所学的知识编写一个程序,为每个分数使用不同的变量。然而,如果一个赛季里有非常多的赛事,这会非常繁琐,因为有球赛的每个球员都需要许多变量。所有篮球分数的类型都相同,不同的是分值,但它们都是篮球赛的分数。理想情况下,应将这些分值组织在一个名称下,例如球员的名字,这样就不需要为每个数据项定义变量了。

本章将介绍如何在C程序中使用数组,然后探讨程序使用数组时,如何通过一个名称来引用一组数值。

**本章的主要内容:**
- 什么是数组
- 如何在程序中使用数组
- 数组如何使用内存
- 什么是多维数组
- 如何编写程序,计算帽子的尺寸
- 如何编写井字游戏


### 5.1 数组简介
说明数组的概念及其作用的最好方法,是通过一个例子,来说明使用数组后程序会变得非常简单。这个例子将计算某班学生的平均分数。


#### 5.1.1 不用数组的程序
非常麻烦



#### 5.1.2 什么是数组
数组是一组数目固定、类型相同的数据项,数组中的数据项称为元素。数组中的元素都是int, long或其他类型。下面的数组声明非常类似于声明一个含有单一数值的正常变量,但要在名称后的方括号中放置一个数。
```
long numbers [10];
```
方括号中的数字定义了要存放在数组中的元素个数,称为数组维(array dimension)。数组有一个类型,它组合了元素的类型和数组中的元素个数。因此如果两个数组的元素个数相同、类型也相同,这两个数组的类型就相同。

存储在数组中的每个数据项都用相同的名称访问,在这个例子中,该名称就是numbers。要选择某个元素,可以在数组名称后的方括号内使用索引值。索引值是从0开始的连续整数。0是第一个元素的索引值,前面numbers数组的元素索引值是0-9,索引值0表示第一个元素,索引值9表示最后一个元素。因此数组元素可表示为numbers[0]numbers[1]、numbers[2] ......numbers[9]。如图5-1所示:
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/2021-01-25_165643.png)
注意,索引值是从0开始,不是1,第一次使用数组时,这是一个常犯的错误,有时这称为off-by-one错误。在一个十元素数组中,最后一个元素的索引值是9,要访问数组中的第4个值,应使用表达式numbers[3]。数组元素的索引值是与第1个元素的偏移量。第1个元素的偏移量是0,第2个元素与第一个元素的偏移量是1,第3个元素与第一个元素的偏移量是2,依此类推。

要访问numbers数组元素的值,也可以在数组名称后的方括号内放置表达式,该表达式的结果必须是一个整数,对应于一个可能的索引值。例如numbers[i-2]。如果i的值是3,就访问数组中的第2个元素numbers[1]。因此,有两种方法来指定索引值,以访问数组中的某个元素。其一,可以使用一个简单的整数,明确指定要访问的元素。其二,可以使用一个在执行程序期间计算的整数表达式。使用表达式的唯一限制是,它的结果必须是整数,该整数必须是对数组有效的索引值。

注意,如果在程序中使用的索引值超过了这个数组的合法范围,程序将不能正常运作。编译器检查不出这种错误,所以程序仍可以编译,但是执行是有问题的。在最好的情况下,是从某处提取了一个垃圾值,所以结果是错误的,且每次执行的结果都不会相同。在最糟的情况下,程序可能会覆盖重要的信息,且锁死计算机,需要重启计算机。有时,这对程序的影响比较微妙:程序有时能正常工作,有时不能,或者程序看起来工作正常,但结果是错误的,只是不明显。因此,一定要细心检查数组索引是否在合法范围内。

#### 5.1.3 使用数组
跟 Java 一样

### 5.2 寻址运算符
寻址运算符&输出其操作数的内存地址。前面使用了寻址运算符&,它广泛用于scanf()函数。它放在存储输入的变量名称之前, scanf()函数就可以利用这个变量的地址,允许将键盘输入的数据存入变量。只把这个变量名称用作函数的参数,函数就可以使用变量存储的值。而把寻址运算符放在变量名称之前,函数就可以利用这个变量的地址,修改在这个变量中存储的值,其原因参见第8章。下面是一些地址的例子:




























