//
//  QLDMDBDataQueueViewController.m
//  QLFMDB
//
//  Created by 闫庆龙 on 15/4/22.
//  Copyright (c) 2015年 Shrek. All rights reserved.
//

#import "QLDMDBDataQueueViewController.h"
#import "FMDB.h"

@interface QLDMDBDataQueueViewController()
{
    FMDatabaseQueue *_queue;
}

@end

@implementation QLDMDBDataQueueViewController

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
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:strPath];
    _queue = queue;
    [queue inDatabase:^(FMDatabase *db) {
        [self tableCreate];
    }];
}
- (void)tableCreate {
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *strSQL = @"create table if not exists t_person (p_id integer primary key autoincrement, p_name text, p_age integer)";
        BOOL result = [db executeUpdate:strSQL];
        if (result) {
            NSLog(@"创建数据表成功");
        } else {
            NSLog(@"创建数据表失败");
        }
    }];
}
- (void)tableInsert {
    [_queue inDatabase:^(FMDatabase *db) {
        for (NSUInteger index = 0; index < 100; index ++) {
            NSString *strSQL = [NSString stringWithFormat:@"insert into t_person(p_name, p_age) values ('战三-%li', %li)", index, index];
            BOOL result = [db executeUpdate:strSQL];
            if (result) {
                NSLog(@"插入数据成功");
            } else {
                NSLog(@"插入数据失败");
                break;
            }
        }
    }];
}
- (void)tableUpdate {
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *strSQL = @"update t_person set p_name = 'zhandu' where p_id = 1";
        BOOL result = [db executeUpdate:strSQL];
        if (result) {
            NSLog(@"更新数据成功");
        } else {
            NSLog(@"更新数据失败");
        }
    }];
}
- (void)tableDelete {
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *strSQL = @"delete from t_person where p_id = 1";
        BOOL result = [db executeUpdate:strSQL];
        if (result) {
            NSLog(@"删除数据成功");
        } else {
            NSLog(@"删除数据失败");
        }
    }];
}
- (void)tableQuery {
    [_queue inDatabase:^(FMDatabase *db) {
        // 1.检查SQL语句语法
        NSString *strSQL = @"select * from t_person";
        FMResultSet *resultSet = [db executeQuery:strSQL];
        while (resultSet.next) {
            int p_id = [resultSet intForColumn:@"p_id"];
            NSString *p_name = [resultSet stringForColumn:@"p_name"];
            int p_age = [resultSet intForColumn:@"p_age"];
            NSLog(@"%i === %@ === %i", p_id, p_name, p_age);
        }
    }];
}

- (void)transaction {
    
    // 方法一:
    [_queue inDatabase:^(FMDatabase *db) {
        // 如果事务中的某一条失败会默认回滚
        //[db executeUpdate:@"begin transaction;"]; // 开启事务
        [db beginTransaction];
        
        [db executeUpdate:@"update t_person set p_name = 'zhandu' where p_id = 1"];
        [db executeUpdate:@"update t_person set p_name = 'zhandu' where p_id = 5"];
        [db executeUpdate:@"update t_person set p_name = 'zhandu' where p_id = 3"];
        [db executeUpdate:@"update t_person set p_name = 'zhandu' where p_id = 9"];
        [db executeUpdate:@"update t_person set p_name = 'zhandu' where p_id = 28"];
        
        //[db executeUpdate:@"commit transaction;"]; // 提交事务
        [db commit];
        
        // 手动回滚代码
        //[db executeUpdate:@"rollback transaction;"];
        [db rollback];
    }];
    
    // 方法二:
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        // 属于同一个事务的操作
    }];
}

@end
