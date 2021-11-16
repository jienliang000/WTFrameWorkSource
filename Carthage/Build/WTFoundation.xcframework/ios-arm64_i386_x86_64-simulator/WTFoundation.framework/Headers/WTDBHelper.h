//
//  WTDBHelper.h
//  WTFoundation
//
//  Created by admin on 2021/4/11.
//  Copyright © 2021 计恩良. All rights reserved.
//

//基本用法
//[[WTDBHelper sharedInstance] initDB];
//NSString *createTB = @"create table if not exists test(name,score,image)";
//[[WTDBHelper sharedInstance] exeSqls:[NSArray arrayWithObject:createTB]];
//[[WTDBHelper sharedInstance] insertTest:@"aaaaa" num:@"111" headData:@"fadsfadsfdsaf"];
//NSArray *ar = [[WTDBHelper sharedInstance] selectAllInfo:@"select * from test"];

//NSString *sql = @"insert into test(name, age, height) values('wangwu', 15, 170);insert into T_human(name, age, height) values('zhaoliu', 13, 160);";

#import <Foundation/Foundation.h>

@interface WTDBHelper : NSObject
+ (instancetype)sharedInstance;
- (void)initDB;
- (BOOL)exeSqls:(NSArray *)sqlList;
- (NSMutableArray *)selectAllInfo:(NSString *)sql;




//- (BOOL)insertTest:(NSString *)name num:(NSString *)num headData:(NSString *)headData;
@end
