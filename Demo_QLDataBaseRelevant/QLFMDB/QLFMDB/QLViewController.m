//
//  QLViewController.m
//  QLSqlite3
//
//  Created by 闫庆龙 on 15/4/14.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import "QLViewController.h"
#import "FMDB.h"

@interface QLViewController ()
{
    FMDatabase *_datebase;
}

@end

@implementation QLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.打开数据库(没有这个数据库的时候穿件一个), 打开表(没有这张表的时候创建一张表)
    [self dbOpen];
    // 2.插入数据
//    [self tableInsert];
    // 3.操作数据
    // 3.1.修改数据
//    [self tableUpdate];
    // 3.2.删除数据
//    [self tableDelete];
    // 3.3.查询数据
    [self tableQuery];
}

- (void)dbOpen {
    NSString *strPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"FMDB.db"];
    FMDatabase *db = [FMDatabase databaseWithPath:strPath];
    if ([db open]) {
        NSLog(@"打开数据库成功");
        _datebase = db;
        [self tableCreate];
    } else {
        NSLog(@"打开数据库失败");
    }
}
- (void)tableCreate {
    NSString *strSQL = @"create table if not exists t_person (p_id integer primary key autoincrement, p_name text, p_age integer)";
    BOOL result = [_datebase executeUpdate:strSQL];
    if (result) {
        NSLog(@"创建数据表成功");
    } else {
        NSLog(@"创建数据表失败");
    }
}
- (void)tableInsert {
    for (NSUInteger index = 0; index < 100; index ++) {
        NSString *strSQL = [NSString stringWithFormat:@"insert into t_person(p_name, p_age) values ('战三-%li', %li)", index, index];
        BOOL result = [_datebase executeUpdate:strSQL];
        if (result) {
            NSLog(@"插入数据成功");
        } else {
            NSLog(@"插入数据失败");
            break;
        }
    }
}
- (void)tableUpdate {
    NSString *strSQL = @"update t_person set p_name = 'zhandu' where p_id = 1";
    BOOL result = [_datebase executeUpdate:strSQL];
    if (result) {
        NSLog(@"更新数据成功");
    } else {
        NSLog(@"更新数据失败");
    }
}
- (void)tableDelete {
    NSString *strSQL = @"delete from t_person where p_id = 1";
    BOOL result = [_datebase executeUpdate:strSQL];
    if (result) {
        NSLog(@"删除数据成功");
    } else {
        NSLog(@"删除数据失败");
    }
}
- (void)tableQuery {
    // 1.检查SQL语句语法
    NSString *strSQL = @"select * from t_person";
    FMResultSet *resultSet = [_datebase executeQuery:strSQL];
    while (resultSet.next) {
        int p_id = [resultSet intForColumn:@"p_id"];
        NSString *p_name = [resultSet stringForColumn:@"p_name"];
        int p_age = [resultSet intForColumn:@"p_age"];
        NSLog(@"%i === %@ === %i", p_id, p_name, p_age);
    }
}

@end
