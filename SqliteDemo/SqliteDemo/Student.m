//
//  Student.m
//  SqliteDemo
//
//  Created by stokey on 2017/3/31.
//  Copyright © 2017年 stokey. All rights reserved.
//

#import "Student.h"

@implementation Student

-(instancetype) initWithId:(NSString *)idNum withName:(NSString *)name{
    if (self = [super init]){
        self.idNum = idNum;
        self.name = name;
        self.age=0;
        self.sex = 0;//男性为0，女性为1
    }
    return self;
}

-(instancetype) initWithId:(NSString *)idNum withName:(NSString *)name whitSex:(int) sex{
    if (self = [self initWithId:idNum withName:name]){
        self.sex = sex;//男性为0，女性为1
    }
    return self;
}

-(instancetype) initWithId:(NSString *)idNum withName:(NSString *)name withAge:(int) age{
    if (self = [self initWithId:idNum withName:name]){
        self.age = age;
    }
    return self;
}

-(instancetype) initWithId:(NSString *)idNum withName:(NSString *)name whitSex:(int) sex withAge:(int) age{
    if (self = [self initWithId:idNum withName:name whitSex:sex]){
        self.age = age;
    }
    return self;
}

@end
