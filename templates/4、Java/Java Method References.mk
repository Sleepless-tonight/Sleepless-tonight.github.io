## Java Method References Java 方法参考
使用 lambda表达式创建匿名方法。但是，有时lambda表达式除了调用现有方法外什么也不做。在这种情况下，通常更容易按名称引用现有方法。方法引用使您可以执行此操作；它们是紧凑，易于阅读的lambda表达式，用于已具有名称的方法。

再次考虑Lambda表达式Person部分中讨论的 类 ：

```
public class Person {

    public enum Sex {
        MALE, FEMALE
    }

    String name;
    LocalDate birthday;
    Sex gender;
    String emailAddress;

    public int getAge() {
        // ...
    }
    
    public Calendar getBirthday() {
        return birthday;
    }    

    public static int compareByAge(Person a, Person b) {
        return a.birthday.compareTo(b.birthday);
    }}
```
假设您的社交网络应用程序的成员包含在一个数组中，并且您想按年龄对数组进行排序。您可以使用以下代码（在示例中找到本节中描述的代码摘录 MethodReferencesTest）：
```
Person[] rosterAsArray = roster.toArray(new Person[roster.size()]);

class PersonAgeComparator implements Comparator<Person> {
    public int compare(Person a, Person b) {
        return a.getBirthday().compareTo(b.getBirthday());
    }
}
        
Arrays.sort(rosterAsArray, new PersonAgeComparator());
```
此调用的方法签名sort如下：
```
static <T> void sort(T[] a, Comparator<? super T> c)
```
请注意，该接口Comparator是功能接口。因此，您可以使用lambda表达式，而不是定义并创建一个实现Comparator以下内容的类的新实例：
```
Arrays.sort(rosterAsArray,
    (Person a, Person b) -> {
        return a.getBirthday().compareTo(b.getBirthday());
    }
);
```
但是，这种比较两个Person实例的出生日期的方法已经存在Person.compareByAge。您可以在lambda表达式的主体中调用此方法：
```
Arrays.sort(rosterAsArray,
    (a, b) -> Person.compareByAge(a, b)
);
```
由于此lambda表达式调用现有方法，因此可以使用方法引用代替lambda表达式：
```
Arrays.sort(rosterAsArray, Person::compareByAge);
```
方法引用Person::compareByAge在语义上与lambda表达式相同(a, b) -> Person.compareByAge(a, b)。每个都有以下特征：
- 它的形式参数列表是从复制Comparator<Person>.compare，这是(Person, Person)。
- 它的主体调用该方法Person.compareByAge。

---
有四种方法参考：

类 | 列
---|---
引用静态方法 | ContainingClass::staticMethodName
引用特定对象的实例方法 | containingObject::instanceMethodName
引用特定类型的任意对象的实例方法 | ContainingType::methodName
引用构造函数 | ClassName::new

#### 引用静态方法
方法参考Person::compareByAge是对静态方法的参考。

#### 引用特定对象的实例方法
以下是对特定对象的实例方法的引用示例：

```
class ComparisonProvider {
    public int compareByName(Person a, Person b) {
        return a.getName().compareTo(b.getName());
    }
        
    public int compareByAge(Person a, Person b) {
        return a.getBirthday().compareTo(b.getBirthday());
    }
}
ComparisonProvider myComparisonProvider = new ComparisonProvider();
Arrays.sort(rosterAsArray, myComparisonProvider::compareByName);
```
方法引用myComparisonProvider::compareByName调用compareByName作为对象一部分的方法myComparisonProvider。JRE推断方法类型参数，在这种情况下为(Person, Person)。


#### 引用特定类型的任意对象的实例方法
以下是对特定类型的任意对象的实例方法的引用示例：

```
String[] stringArray = { "Barbara", "James", "Mary", "John",
    "Patricia", "Robert", "Michael", "Linda" };
Arrays.sort(stringArray, String::compareToIgnoreCase);
```
方法参考的等效lambda表达式String::compareToIgnoreCase将具有形式参数列表(String a, String b)，其中a和b是用于更好地描述此示例的任意名称。方法引用将调用该方法a.compareToIgnoreCase(b)。



#### 引用构造函数
您可以使用name以与静态方法相同的方式引用构造函数new。以下方法将元素从一个集合复制到另一个：

```
public static <T, SOURCE extends Collection<T>, DEST extends Collection<T>>
    DEST transferElements(
        SOURCE sourceCollection,
        Supplier<DEST> collectionFactory) {
        
        DEST result = collectionFactory.get();
        for (T t : sourceCollection) {
            result.add(t);
        }
        return result;
}
```
功能接口Supplier包含一个get不带任何参数并返回一个对象的方法。因此，您可以transferElements使用lambda表达式来调用该方法，如下所示：
```
Set<Person> rosterSetLambda =
    transferElements(roster, () -> { return new HashSet<>(); });
}
```
您可以使用构造函数引用代替lambda表达式，如下所示：
```
Set<Person> rosterSet = transferElements(roster, HashSet::new);
```
Java编译器推断您要创建一个HashSet包含type元素的集合Person。另外，您可以指定如下：
```
Set<Person> rosterSet = transferElements(roster, HashSet<Person>::new);
```







---
