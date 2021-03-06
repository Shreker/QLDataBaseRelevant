1. 数据库中的指令不区分大小写；
2. 数据库命名时，不能与关键字冲突
* 在命名数据表时，一般使用“t_”作为前缀

在sqlite中是不区分字段类型的，不过为了保持编程规范，在创建数据表时，最好指定数据类型

3. SQL语言中，作为程序员一定要会SELECT，其他的命令，通常可以借助工具来帮助编写

4. SQL语句都是以;作为结尾的

5. 在数据库中，数据表的名字不能够重复！

*** 数据库操作步骤
1. 创建数据表
2. 插入数据
完成第二步之后，基本先告一段落

后续就是对现有数据库中的内容进行操作
1） 新增记录 insert
2） 修改记录 update
3） 删除记录 delete
4） 查询记录 select

*** 数据库相对plist的好处
** 分页查询指令
# limit 指令用于限制查询出来的结果数量
# 第一个数值表示从哪条记录开始（起始是0）
# 第二个数值表示一次取多少条记录，如果要分页显示，通常第二个数值固定不变，表示每页需要显示的记录条数
# 第一页 
select * from t_person limit 0, 3;
# 第二页
select * from t_person limit 3, 3;
# 第三页
select * from t_person limit 6, 3;

** 查询排序
* ASC 升序（默认的排序方法）
* DESC 降序
* 由左至右排序的优先级依次降低，也就是第一个排序列的优先级是最高的
SELECT * FROM t_person ORDER BY age ASC, id DESC;

** 能够定向地查到具体需要的内容
# 从数据库查出名字叫做wangwu的记录
select * from t_person where name = 'wangwu';
# 从数据库查出名字以wang开头的记录
select * from t_person where name like 'wangwu%';
# 从数据库查出名字中包含a的记录，通常用于模糊查询，建议不要搞太多字段组合模糊查询，那样性能会非常差！
select * from t_person where name like '%a%';

** 可以对数据进行统计
# 取出所有数据的总数目
select count(*) from t_person;
# 统计符合条件的记录条数
select count(*) from t_person where name like 'wang%';
# 选择指定列的最大值
select max(age) from t_person;
# 选择指定列的最小值
select min(age) from t_person;
# 计算指定列的平均值
select avg(age) from t_person;
# 计算指定列数值的总数
select sum(age) from t_person;

** 更新指令
# 更新一个字段
update t_person set name = 'xiaofang' where name = 'wangwu';
# 更新多个字段，每个字段之间使用,分隔
update t_person set age = 20, height = 2.0 where name = 'xiaofang';

# 需要注意的是：使用更新指令时，最好能够准确地知道唯一的一条要更新的记录，否则其他所有满足条件的记录都会被修改。

** 自动增长是由服务器来控制的


*** 关系

为什么要有关系
1. 数据“冗余”，所谓数据容易，就是存储了多余的数据
2. 在数据库中的关系有：
* 一对一
* 一对多
* 多对一

通常，一对多和多对一关系存储在时，就需要使用多个表表示。

关于left jion和jion的选择
**  left join
1)如果要查询左边表中的所有符合条件的数据，使用left jion
2) 通常查询出来的结果会多，因为右边表不存在的记录，同样可能会被查询出来，查询出来之后，右边表不存在的记录，全部为NULL
** join
1)如果要两个表中同时存在的符合条件的数据，使用jion
2) 通常查询出来的结果会比左连接少，因为右边表不存在的记录，不会显示出来

通常在使用时，左边的表是主要信息表，右边的表是辅助修饰的信息表，其内容可有可无，因此，在实际应用中，left jion使用的比较频繁！如果用join的话，有可能会“丢（有些存在的数据不显示）”数据

在使用连接查询多个表时，如果有重名的字段，可以使用as的方法，给字段起一个别名，示例代码如下：

select s.name, s.age, s.phone, b.name as bookname, b.price from t_student s join t_book b on b.id = s.book_id



