//
//  HomeViewController.m
//  SqliteDemo
//
//  Created by stokey on 2017/3/31.
//  Copyright © 2017年 stokey. All rights reserved.
//

#import "HomeViewController.h"
#import "Student.h"
#import "SQLManager.h"

#define HomeCellIdentifier @"StudentCell"

@interface HomeViewController ()
@property(nonatomic,strong) NSMutableArray *studentArray;
@property (strong, nonatomic) IBOutlet UITableView *studentListView;
@end
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshController = [[UIRefreshControl alloc]init];
    refreshController.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refreshController addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshController;
    [self checkUserSetting];
}

-(void) refreshData{
    if (self.refreshControl.isRefreshing){
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"加载中..."];
        self.refreshTime = [[NSDate alloc]init];
        NSMutableArray *temp = [[SQLManager shareManager] getStudents];
    
        [self.refreshControl endRefreshing];
        
        if (![self.studentArray isEqual:temp]){
            self.studentArray = temp;
            [self.studentListView reloadData];
        }
    } else {
        self.refreshTime = [[NSDate alloc]init];
        NSMutableArray *temp = [[SQLManager shareManager] getStudents];
        
        if (![self.studentArray isEqual:temp]){
            self.studentArray = temp;
            [self.studentListView reloadData];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshData];
    NSLog(@"studentArrayLength:%d",(int)[self.studentArray count]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) checkUserSetting{
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    BOOL isNotFirstIn = [defaults boolForKey:@"isNotFirstIn"];
    if (!isNotFirstIn){
        NSLog(@"this is app first in");
    }else{
        NSLog(@"this is not app first in");
    }
    if (!isNotFirstIn){
        [defaults setValue:@"tiangen" forKey:@"name_preference"];
        [defaults setInteger:12345678 forKey:@"psw_preference"];
        [defaults setBool:true forKey:@"isNotFirstIn"];
        [defaults setDouble:40.0 forKey:@"sliderCacheSize"];
        [defaults synchronize];
    } else {
        [self getUserLoginInfo:defaults];
    }
}


#pragma mark - Setting Bundle info
-(NSMutableDictionary *) getUserLoginInfo:(NSUserDefaults *)defaults {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (defaults != nil){
        NSString *userName = [defaults objectForKey:@"name_preference"];
        if (userName != nil){
            [result setObject:userName forKey:@"userName"];
        }
        NSLog(@"userName:%@",userName);
        
        NSString *userPsw = [defaults objectForKey:@"psw_preference"];
        if (userPsw != nil){
            [result setObject:userPsw forKey:@"userPsw"];
        }
        NSLog(@"userPsw:%@",userPsw);
        BOOL tooggle = [defaults boolForKey:@"toggleClearCache"];
        if (tooggle) {
            NSLog(@"clear cache is open");
        } else {
            NSLog(@"clear cache is close");
        }
        double slider = [defaults doubleForKey:@"sliderCacheSize"];
        NSLog(@"result:%lf",slider);
        
        NSString *serviceName = [defaults stringForKey:@"multiService"];
        NSLog(@"serviceName:%@",serviceName);
    }
    return result;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"studentArrayLength:%d",(int)[self.studentArray count]);
    return [self.studentArray count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Student *studentInfo = [self.studentArray objectAtIndex:indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Student Info" message:studentInfo.name delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeCellIdentifier forIndexPath:indexPath];

    if (self.studentArray.count > 0) {
        Student *student = [self.studentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = student.idNum;
        cell.detailTextLabel.text = student.name;
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Student *deleteStudent = [self.studentArray objectAtIndex:indexPath.row];
        if (deleteStudent!=nil){
            if([[SQLManager shareManager] deleteStudentByIdNum:deleteStudent.idNum]){
                NSLog(@"删除成功！");
                [self.studentArray removeObject:deleteStudent];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                NSLog(@"删除失败！");
                [tableView setEditing:NO animated:YES];
            }
        }
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}



@end
