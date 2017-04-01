//
//  SQLManager.h
//  SqliteDemo
//
//  Created by stokey on 2017/3/31.
//  Copyright © 2017年 stokey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Student.h"

@interface SQLManager : NSObject{
    sqlite3 *db;
}

+ (SQLManager *) shareManager;

-(NSMutableArray *) getStudents;
- (Student *) findStudentByIdNum:(NSString *) studentIdNum;
- (Boolean) addStudent:(Student *) student;
- (Boolean) deleteStudentByIdNum:(NSString *) studentIdNum;
- (Boolean) updateStudentByIdNum:(NSString *) studentIdNum;
@end
