//
//  Student.h
//  SqliteDemo
//
//  Created by stokey on 2017/3/31.
//  Copyright © 2017年 stokey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject
@property(strong,nonatomic) NSString *idNum;//学号
@property(strong,nonatomic) NSString *name;//姓名
@property(atomic,readwrite) int sex;
@property(atomic,readwrite) int age;

-(instancetype) initWithId:(NSString *)idNum withName:(NSString *)name;

-(instancetype) initWithId:(NSString *)idNum withName:(NSString *)name withSex:(int) sex;

-(instancetype) initWithId:(NSString *)idNum withName:(NSString *)name withAge:(int) age;

-(instancetype) initWithId:(NSString *)idNum withName:(NSString *)name withSex:(int) sex withAge:(int) age;

@end
