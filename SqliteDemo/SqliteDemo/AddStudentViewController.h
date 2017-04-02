//
//  AddStudentViewController.h
//  SqliteDemo
//
//  Created by stokey on 2017/3/31.
//  Copyright © 2017年 stokey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStudentViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *studentIdNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *studentNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *studentSexTexField;
@property (weak, nonatomic) IBOutlet UITextField *studentAgeTexField;
- (IBAction)addAction:(UIBarButtonItem *)sender;

@end
