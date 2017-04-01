 //
//  AddStudentViewController.m
//  SqliteDemo
//
//  Created by stokey on 2017/3/31.
//  Copyright © 2017年 stokey. All rights reserved.
//

#import "AddStudentViewController.h"
#import "SQLManager.h"
#import "Student.h"

@interface AddStudentViewController ()

@end

@implementation AddStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addAction:(UIBarButtonItem *)sender {
    Student *student = nil;
    if ([self.studentNameTextField.text length] <=0 || [self.studentIdNumTextField.text length]<=0){
        NSLog(@"参数输入为空");
    }else{
        int sex = [self.studentSexTexField.text containsString:@"男"]? 0:1;
        int age = [self.studentAgeTexField.text intValue];
        student = [[Student alloc]initWithId:self.studentIdNumTextField.text withName:self.studentNameTextField.text withSex:sex withAge:age];
        
        if([[SQLManager shareManager] addStudent:student]){
            NSLog(@"dissMissViewController");
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            NSLog(@"插入数据失败！");
        }
    }
}
@end
