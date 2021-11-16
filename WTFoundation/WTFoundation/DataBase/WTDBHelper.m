//
//  WTDBHelper.m
//  WTFoundation
//
//  Created by admin on 2021/4/11.
//  Copyright © 2021 计恩良. All rights reserved.
//
#import "WTDBHelper.h"
#import "WTAppInfo.h"
#import "WTStringUtil.h"
#import <FMDataBase/FMDB.h>
@import FMDataBase;
@interface WTDBHelper()
@property (strong, nonatomic) FMDatabaseQueue *queue;
@property (strong, nonatomic) FMDatabase *dataBase;
@end

@implementation WTDBHelper
+ (instancetype)sharedInstance {
    static WTDBHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[WTDBHelper alloc] init];
    });
    
    return helper;
}

- (void)initDB {
    NSString *name = [WTStringUtil md5:WTAppInfo.bundleId];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectoryPath = [[paths objectAtIndex:0] stringByAppendingString:@"/Caches"];
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@.db",cachesDirectoryPath,name];
    [FMDatabase databaseWithPath:dbPath]; //创建数据库
    self.queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        if (db) {
            NSLog(@"创建数据库成功");
        } else {
            NSLog(@"创建数据库失败");
        }
    }];
}

- (BOOL)exeSqls:(NSArray *)sqlList
{
    __block BOOL ret = YES;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db beginDeferredTransaction];
        BOOL whoopsSomethingWrongHappened = NO;
        for (int i = 0; i < [sqlList count]; i++)
          {
            NSString *sql = [sqlList objectAtIndex:i];
            BOOL t = [db executeUpdate:sql];
            if (!t) {
                whoopsSomethingWrongHappened = YES;
                *rollback = YES;
                break;
            }
          }
        if(whoopsSomethingWrongHappened)
          {
            ret = NO;
            [db rollback];
          }
        else
          {
            [db commit];
          }
    }];
    return ret;
}

- (NSMutableArray *)selectAllInfo:(NSString *)sql
{
    __block NSMutableArray *users = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db)   {
        [db open];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next])
          {
            @autoreleasepool{
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            for (int i = 0; i<[rs columnCount]; i++)
              {
                NSString *colName = [rs columnNameForIndex:i];
                NSObject *obj = [rs objectForColumnName:colName];
                if (![obj isKindOfClass:[NSNull class]]) {
                    [dic setObject:obj forKey:colName];
                  }
              }
            [users addObject:dic];
            }
          }
        [db close];
    }];
    return users;
}



//- (BOOL)insertTest:(NSString *)name num:(NSString *)num headData:(NSString *)headData {
//    __block BOOL ret = YES;
//    [self.queue inDatabase:^(FMDatabase *db)   {
//        ret = [db executeUpdate:@"insert into test values (?,?,?)", name, num, headData];
//    }];
//    return ret;
//}
@end
