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
     NSLog(@"bundlePath:%@",[[NSBundle mainBundle]bundlePath]);
    
    [self.studentSexSegment addTarget:self action:@selector(segementChange:) forControlEvents:UIControlEventValueChanged];
}

-(void) segementChange:(UISegmentedControl *)sender{
    [self clearTextFieldResponder];
    
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"select sex is man");
    }else{
        NSLog(@"select sex is woman");
    }
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
    [self clearTextFieldResponder];
    
    if ([self.studentNameTextField.text length] <=0 || [self.studentIdNumTextField.text length]<=0){
        NSLog(@"参数输入为空");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"输入参数不完善，请检查参数" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        int sex = (int)[self.studentSexSegment selectedSegmentIndex];
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    NSString *restorationIdentifier = textField.restorationIdentifier;
    if ([restorationIdentifier isEqual:@"studentIdNum"]){
        [self.studentNameTextField becomeFirstResponder];
    }else {
        [self clearTextFieldResponder];
    }
    return YES;
}


-(void) clearTextFieldResponder{
    if ([self.studentIdNumTextField isFirstResponder]) {
        [self.studentIdNumTextField resignFirstResponder];
    }
    if ([self.studentNameTextField isFirstResponder]) {
        [self.studentNameTextField resignFirstResponder];
    }
    if ([self.studentAgeTexField isFirstResponder]) {
        [self.studentAgeTexField resignFirstResponder];
    }
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 点击空白隐藏键盘
    [self.view endEditing:YES];
}

@end
