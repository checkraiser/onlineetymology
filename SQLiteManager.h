//
//  SQLiteManager.h
//  AdmobTest
//
//  Created by revskill on 4/5/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import <sqlite3.h>

@interface SQLiteManager : NSObject<RCTBridgeModule>
{
    sqlite3 *database;
}
- (NSString *)dataFilePath;
- (void)initDatabase:(RCTResponseSenderBlock)callback;
- (void)fetchDefinition:(NSNumber *)id callback:(RCTResponseSenderBlock)callback;
- (void)filter:(NSString *)text callback:(RCTResponseSenderBlock)callback;
@end
