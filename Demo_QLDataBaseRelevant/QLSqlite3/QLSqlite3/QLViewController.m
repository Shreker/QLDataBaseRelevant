//
//  QLViewController.m
//  QLSqlite3
//
//  Created by 闫庆龙 on 15/4/14.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import "QLViewController.h"
#import <sqlite3.h>

@interface QLViewController ()
{
    sqlite3 *_db;
}

@end

@implementation QLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.打开数据库(没有这个数据库的时候穿件一个)
    [self dbOpen];
    // 2.打开表(没有这张表的时候创建一张表)
    [self tableCreate];
    // 3.插入数据
//    [self tableInsert];
    // 4.操作数据
    // 4.1.修改数据
    [self tableUpdate];
    // 4.2.删除数据
//    [self tableDelete];
    // 4.3.查询数据
    [self tableQuery];
}

- (void)dbOpen {
    NSString *strPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"QLSqlite3.sqlite"];
    NSLog(@"%@", strPath);
    sqlite3 *db = NULL;
    /**
     *  sqlite3_open(<#const char *filename#>, <#sqlite3 **ppDb#>);
     *  filename: 文件名
     *  ppDB:
     */
    int result = sqlite3_open(strPath.UTF8String, &db);
    if (result == SQLITE_OK) {
        NSLog(@"打开数据库成功");
        _db = db;
    } else {
        NSLog(@"打开数据库失败");
    }
}
- (void)tableCreate {
    NSString *strSQL = @"create table if not exists t_person (p_id integer primary key autoincrement, p_name text, p_age integer)";
    char *error = NULL;
    /**
     *  sqlite3_exec(<#sqlite3 *#>, <#const char *sql#>, <#int (*callback)(void *, int, char **, char **)#>, <#void *#>, <#char **errmsg#>)
     *
     *  @param <#sqlite3 *#> 数据库实例
     *  @param <#const char *sql#> SQL语句
     *  @param <#int (*callback)(void *, int, char **, char **)#> 语句执行完之后的回调函数
     *  @param <#void *#>
     *  @param <#char **errmsg#> 错误信息
     *
     *  执行SQL语句
     */
    int result = sqlite3_exec(_db, strSQL.UTF8String, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        NSLog(@"创建数据表成功");
    } else {
        NSLog(@"创建数据表失败-%s", error);
    }
}
- (void)tableInsert {
    for (NSUInteger index = 0; index < 100; index ++) {
        NSString *strSQL = [NSString stringWithFormat:@"insert into t_person(p_name, p_age) values ('战三-%li', %li)", index, index];
        char *error = NULL;
        int result = sqlite3_exec(_db, strSQL.UTF8String, NULL, NULL, &error);
        if (result == SQLITE_OK) {
            NSLog(@"插入数据成功");
        } else {
            NSLog(@"插入数据失败-%s", error);
        }
    }
}
- (void)tableUpdate {
    NSString *strSQL = @"update t_person set p_name = 'zhandu' where p_id = 1";
    char *error = NULL;
    int result = sqlite3_exec(_db, strSQL.UTF8String, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        NSLog(@"更新数据成功");
    } else {
        NSLog(@"更新数据失败-%s", error);
    }
}
- (void)tableDelete {
    NSString *strSQL = @"delete from t_person where p_id = 1";
    char *error = NULL;
    int result = sqlite3_exec(_db, strSQL.UTF8String, NULL, NULL, &error);
    if (result == SQLITE_OK) {
        NSLog(@"删除数据成功");
    } else {
        NSLog(@"删除数据失败-%s", error);
    }
}
- (void)tableQuery {
    // 1.检查SQL语句语法
    NSString *strSQL = @"select * from t_person";
    sqlite3_stmt *stmt = NULL;
    /**
     *  sqlite3_prepare_v2(<#sqlite3 *db#>, <#const char *zSql#>, <#int nByte#>, <#sqlite3_stmt **ppStmt#>, <#const char **pzTail#>)
     *
     *  @param <#sqlite3 *#> 数据库实例
     *  @param <#const char *zSql#> SQL语句
     *  @param <#int nByte#> SQL语句所占的字节数(-1代表自动计算)
     *  @param <#sqlite3_stmt **ppStmt#> 执行SQL语句的句柄
     *  @param <#const char **pzTail#>
     *
     *  检查SQL语法,当正确的时候返回执行句柄,利用sqlite3_step(<#sqlite3_stmt *#>)返回一条记录
     */
    int result = sqlite3_prepare_v2(_db, strSQL.UTF8String, -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSLog(@"语法正确,开始查询");
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            /**
             *  sqlite3_column_<#type#>(<#sqlite3_stmt *#>, <#int iCol#>)
             *
             *  @param <#sqlite3_stmt *#> 执行SQL语句的句柄
             *  @param <#int iCol#> 结果列表中当前字段的下标(第几个,从0开始)
             *
             *  @return <#return value description#>
             */
            int p_id = sqlite3_column_int(stmt, 0);
            const unsigned char *p_name = sqlite3_column_text(stmt, 1);
            int p_age = sqlite3_column_int(stmt, 2);
            NSLog(@"%i -- %@ -- %i", p_id, [NSString stringWithUTF8String:(const char *)p_name], p_age);
        }
    } else {
        NSLog(@"语法错误");
    }
}

@end
