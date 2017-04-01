//
//  SQLManager.m
//  SqliteDemo
//
//  Created by stokey on 2017/3/31.
//  Copyright © 2017年 stokey. All rights reserved.
//

#import "SQLManager.h"

@implementation SQLManager

#define kNameFile @"Student.sqlite"

static SQLManager *manager = nil;

+ (SQLManager *) shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        [manager createDataBaseTableIfNeeded];
    });

    return manager;
}

-(void) createDataBaseTableIfNeeded{
    NSString *writeTablePath = [self applicationDocumentsDirectoryFilePath];
    NSLog(@"数据库地址是：%@",writeTablePath);
    if (sqlite3_open([writeTablePath UTF8String], &db) != SQLITE_OK){
        NSLog(@"数据库打开失败！");
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败！");
    } else {
        char *err;
        NSString *createSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Student (idNum TEXT PRIMARYKEY,name TEXT,sex INTEGER,age INTEGER);"];
        if (sqlite3_exec(db, [createSQL UTF8String], NULL, NULL, &err) != SQLITE_OK){
            NSLog(@"数据库建表失败：%@",[[NSString alloc] initWithCString: err encoding:NSUTF8StringEncoding]);
            sqlite3_close(db);
            NSAssert(NO, @"数据库建表失败：%@",[[NSString alloc] initWithCString: err encoding:NSUTF8StringEncoding]);

        } else {
            NSLog(@"数据库建表成功");
        }
    }
    sqlite3_close(db);
}

-(NSString *) applicationDocumentsDirectoryFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths lastObject];
    if (![documentDirectory hasSuffix:@"/"]){
       documentDirectory = [documentDirectory stringByAppendingString:@"/"];
    }
    NSString *filePath = [documentDirectory stringByAppendingString:kNameFile];
    return filePath;
}

- (NSMutableArray *) getStudents{
    NSMutableArray *studentsArray = [[NSMutableArray alloc]init];
    NSString *path = [self applicationDocumentsDirectoryFilePath];
    
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK){
        NSLog(@"findStudentByIdNum 数据库打开失败！");
        sqlite3_close(db);
        NSAssert(NO, @"findStudentByIdNum 数据库打开失败！");
    } else {
        NSString *querySQL = @"SELECT * FROM Student;";
        sqlite3_stmt *sqlStmt;
        // 预处理
        if (sqlite3_prepare_v2(db, [querySQL UTF8String], -1, &sqlStmt, NULL) != SQLITE_OK){
            NSLog(@"findStudentByIdNum 数据库查询失败！");
            sqlite3_close(db);
            NSAssert(NO, @"findStudentByIdNum 数据库查询失败！");
        } else {
            // 绑定
            sqlite3_bind_null(sqlStmt, -1);
            // 遍历
            int execResult = sqlite3_step(sqlStmt);
            while(execResult ==SQLITE_ROW){
                NSLog(@"exec result:%d",execResult);
                // 提取数据
                char *idNum = (char *)sqlite3_column_text(sqlStmt, 0);
                NSString *idNumStr = [[NSString alloc]initWithUTF8String:idNum];
                
                char *name = (char *)sqlite3_column_text(sqlStmt, 1);
                NSString *nameStr = [[NSString alloc]initWithUTF8String:name];
                
                int sex = sqlite3_column_int(sqlStmt, 2);
                
                int age = sqlite3_column_int(sqlStmt, 3);
                
                Student *student = [[Student alloc] initWithId:idNumStr withName:nameStr whitSex:sex withAge:age];
                [studentsArray addObject:student];
                execResult = sqlite3_step(sqlStmt);
            }
            if(execResult == SQLITE_DONE){
                NSLog(@"exec result:%d",execResult);
                sqlite3_finalize(sqlStmt);
                sqlite3_close(db);
            }
        }
    }
    return studentsArray;
}

- (Student *) findStudentByIdNum:(NSString *) studentIdNum{
    Student *student = nil;
    if ([studentIdNum length] > 0){
        NSString *path = [self applicationDocumentsDirectoryFilePath];
        if (sqlite3_open([path UTF8String], &db) != SQLITE_OK){
            NSLog(@"findStudentByIdNum 数据库打开失败！");
            sqlite3_close(db);
            NSAssert(NO, @"findStudentByIdNum 数据库打开失败！");
        } else {
            NSString *querySQL = @"SELECT * FROM Student where idNum = ?";
            sqlite3_stmt *sqlStmt;
            // 预处理
            if (sqlite3_prepare_v2(db, [querySQL UTF8String], -1, &sqlStmt, NULL) != SQLITE_OK){
                NSLog(@"findStudentByIdNum 数据库查询失败！");
                sqlite3_close(db);
                NSAssert(NO, @"findStudentByIdNum 数据库查询失败！");
            } else {
                // 按主键查询
                // 绑定
                sqlite3_bind_text(sqlStmt,1, [studentIdNum UTF8String], -1, NULL);
                // 遍历
                if (sqlite3_step(sqlStmt) == SQLITE_ROW){
                    // 提取数据
                    char *idNum = (char *)sqlite3_column_text(sqlStmt, 0);
                    NSString *idNumStr = [[NSString alloc]initWithUTF8String:idNum];
                    
                    char *name = (char *)sqlite3_column_text(sqlStmt, 1);
                    NSString *nameStr = [[NSString alloc]initWithUTF8String:name];
                    
                    int sex = sqlite3_column_int(sqlStmt, 2);
                    
                    int age = sqlite3_column_int(sqlStmt, 3);
                    student = [[Student alloc] initWithId:idNumStr withName:nameStr whitSex:sex withAge:age];
                }
                sqlite3_finalize(sqlStmt);
                sqlite3_close(db);
            }
        }
    } else{
        sqlite3_close(db);
        NSAssert(NO, @"findStudentByIdNum 输入参数为空");
    }
    return student;
}

- (Boolean) addStudent:(Student *) student{
    if (student != nil){
        NSString *path = [self applicationDocumentsDirectoryFilePath];
        if (sqlite3_open([path UTF8String], &db) != SQLITE_OK){
            NSLog(@"addStudent 数据库打开失败！");
            sqlite3_close(db);
            // NSAssert(NO, @"addStudent 数据库打开失败！");
        } else {
            NSString *querySQL = @"INSERT OR REPLACE INTO Student (idNum,name,sex,age) values(?,?,?,?)";
            sqlite3_stmt *sqlStmt;
            // 预处理
            if (sqlite3_prepare_v2(db, [querySQL UTF8String], -1, &sqlStmt, NULL) != SQLITE_OK){
                NSLog(@"addStudent 数据库查询失败！");
                sqlite3_close(db);
                // NSAssert(NO, @"addStudent 数据库查询失败！");
            } else {
                // 绑定
                sqlite3_bind_text(sqlStmt,1, [student.idNum UTF8String], -1, NULL);
                sqlite3_bind_text(sqlStmt,2, [student.name UTF8String], -1, NULL);
                sqlite3_bind_int(sqlStmt, 3, student.sex);
                sqlite3_bind_int(sqlStmt,4, student.age);
                // 插入
                
                if (sqlite3_step(sqlStmt) != SQLITE_DONE){
                    NSLog(@"exec result:%d",sqlite3_step(sqlStmt));
                    sqlite3_finalize(sqlStmt);
                    sqlite3_close(db);
                    NSLog(@"addStudent 插入数据失败！");
                } else {
                    NSLog(@"addStudent 插入数据成功！");
                    sqlite3_finalize(sqlStmt);
                    sqlite3_close(db);
                    return true;
                }
            }
        }
    } else{
        NSAssert(NO, @"findStudentByIdNum 输入参数为空");
    }
    return false;
}
- (Boolean) deleteStudentByIdNum:(NSString *) studentIdNum{
    return false;
}
- (Boolean) updateStudentByIdNum:(NSString *) studentIdNum{
    return false;
}
@end
