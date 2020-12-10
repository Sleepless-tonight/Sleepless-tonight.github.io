#####  1、test 属性的值可以转义为Java代码
###### 例如：可以.size、可以.toString()
传入参数是 list
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20181123181553.png)
在 mapper.xml 中
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20181123181706.png)

![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20181123181712.png)
#####  2、自定义排序
###### 通过 order by instr (a,b) 方法对 b 字段按 a 展示顺序排序
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20181123181730.png)
#####  3、复杂对象在 mapper.xml 文件中取值、
传入参数是 List<Map<String,String>>
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20181123181733.png)
在mapper.xml 文件中通过get方法取值、（另可以 item.sourecSysid 形式通过属性取值。）
![image](https://nostyling-1256016577.cos.ap-beijing.myqcloud.com/%E5%BE%AE%E4%BF%A1%E5%9B%BE%E7%89%87_20181123181740.png)

