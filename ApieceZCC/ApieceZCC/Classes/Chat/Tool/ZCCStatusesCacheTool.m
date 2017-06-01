//
//  ZCCStatusesCacheTool.m
//  ApieceZCC
//
//  Created by qx-005 on 2017/5/12.
//  Copyright © 2017年 zcc. All rights reserved.
//

#import "ZCCStatusesCacheTool.h"
#import "FMDB.h"
#import "ZCCTalksFrameModel.h"
@implementation ZCCStatusesCacheTool

static FMDatabaseQueue *dbQueue;

+ (void)initialize{
    
    NSString *sqlPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"zcc_talkStatusData.sqlite3"];
    
    NSLog(@"%@",sqlPath);
    
    dbQueue = [FMDatabaseQueue databaseQueueWithPath:sqlPath];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        if([db executeUpdate:@"create table if not exists zcc_talkStatuses(id integer primary key autoincrement, statuse blob not null, tid integer not null, username varchar(50) not null);"]){
            NSLog(@"话题表格创建成功");
        }
    }];
}

+ (void)addStatusWithStatusFrameModel:(ZCCTalksFrameModel *)status{
    
    ZCCTalkStatusModel *statusModel = status.statusModel;
    
    NSString *username = statusModel.username;
    
    NSString *tid = statusModel.tid;
    //将对象转化成二进制   存的类型是ZCCTalksModel
    NSData *statusData = [NSKeyedArchiver archivedDataWithRootObject:statusModel];
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        if([db executeUpdate:@"insert into zcc_talkStatuses(statuse, tid, username) values (?,?,?)",statusData, tid, username]){
            NSLog(@"插入数据成功");
        }
    }];
}

+ (void)addStatusWithArray:(NSArray<ZCCTalksFrameModel *> *)statuses{
    
    for (ZCCTalksFrameModel *model in statuses){
        [self addStatusWithStatusFrameModel:model];
    }
}

+ (NSArray<ZCCTalkStatusModel *> *)getStatusesWithStatusesNumber:(NSNumber *)statusNumber{
    
    __block NSMutableArray *statusesM = [NSMutableArray array];
    
        [dbQueue inDatabase:^(FMDatabase *db) {
            
            FMResultSet *result = nil;
            //max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。所以 这里的maxId就是设定最大id的意思
//            if(statusParam.newest_tid){
//                result = [db executeQuery:@"selected statuse from zcc_talkStatuses where tid > ? order by tid desc limit 0,?",statusParam.max_tid, statusParam.count];
//            }else if (statusParam.max_tid){
//                result = [db executeQuery:@"select statuse from zcc_talkStatuses where tid < ? order by tid desc limit 0, ?",statusParam.max_tid,statusParam.count];
//            }else{
//                result = [db executeQuery:@"select statuse from zcc_talkStatuses order by tid desc limit 0,?",statusParam.count];
//            }
            
//            result = [db executeQuery:@"select * from zcc_talkStatuses order by tid desc"];
            
            result = [db executeQuery:@"select statuse from zcc_talkStatuses order by tid desc limit 0,?",statusNumber];
        
            while ([result next]) {
                NSData *statusesData = [result dataForColumn:@"statuse"];
                
                ZCCTalkStatusModel *statuse = [NSKeyedUnarchiver unarchiveObjectWithData:statusesData];
                
                [statusesM addObject:statuse];
            }
        
        }];
        
    return statusesM;
    
}


@end
