//
//  SQLiteManager.m
//  AdmobTest
//
//  Created by revskill on 4/5/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "SQLiteManager.h"

@implementation SQLiteManager
- (NSString *)dataFilePath {
    RCT_EXPORT();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"ety.db"];
}
- (void)fetchDefinition:(NSNumber *)id callback:(RCTResponseSenderBlock)callback{
    RCT_EXPORT();
    NSLog(@"%@", @"fetch definition");
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    NSString *query = [NSString stringWithFormat:@"SELECT definition FROM ety where Id=%@;", id];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
        //sqlite3_bind_int(statement, 1, [id intValue]);
        NSMutableArray *arr = [NSMutableArray array];
        while(sqlite3_step(statement) == SQLITE_ROW){
            char *definition = (char *)sqlite3_column_text(statement, 0);
            NSLog(@"%@", [NSString stringWithUTF8String:definition]);
            NSString *definitionValue = [[NSString alloc] initWithUTF8String:definition];
            [arr addObject:definitionValue];
        }
        callback(@[arr]);
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
- (void)filter:(NSString *)text callback:(RCTResponseSenderBlock)callback{
    RCT_EXPORT();
    NSLog(@"%@", @"fetch definition");
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    NSString *query = [NSString stringWithFormat:@"SELECT Id, origin FROM ety where origin like '%%%@%%' LIMIT 30;", text];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
        NSMutableArray *arr = [NSMutableArray array];
        
        while(sqlite3_step(statement) == SQLITE_ROW){
            int row = sqlite3_column_int(statement, 0);
            char *rowData = (char *)sqlite3_column_text(statement, 1);
            NSString *fieldValue = [[NSString alloc] initWithUTF8String:rowData];
            NSDictionary *dic = @{
                                  @"key": [NSNumber numberWithInt:row] ,
                                  @"value" : fieldValue
                                  };
            [arr addObject:dic];
            
            
        }
        
        
        callback(@[arr]);
        sqlite3_finalize(statement);
    }

    sqlite3_close(database);
}
- (void)initDatabase:(RCTResponseSenderBlock)callback{
    RCT_EXPORT();
    NSString *dbPath = [self dataFilePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ety.db"];
        NSError *error;
        if ([[NSFileManager defaultManager] fileExistsAtPath:sourcePath]){
            [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:dbPath error:&error];
            if (error != nil){
                callback(@[[error localizedDescription], [NSNull null]]);
            }
        }
    }
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    NSString *query = @"SELECT id, origin FROM ety ORDER BY Id LIMIT 30;";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK){
        NSMutableArray *arr = [NSMutableArray array];
        
        while(sqlite3_step(statement) == SQLITE_ROW){
            int row = sqlite3_column_int(statement, 0);
            char *rowData = (char *)sqlite3_column_text(statement, 1);
            NSString *fieldValue = [[NSString alloc] initWithUTF8String:rowData];
            NSDictionary *dic = @{
                                 @"key": [NSNumber numberWithInt:row] ,
                                 @"value" : fieldValue
                                  };
            [arr addObject:dic];
            
            
        }
        
       
        callback(@[arr]);
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
}
@end
