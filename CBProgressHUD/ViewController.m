//
//  ViewController.m
//  CBProgressHUD
//
//  Created by 陈超邦 on 16/6/2.
//  Copyright © 2016年 陈超邦. All rights reserved.
//

#import "ViewController.h"
#import "CBProgressHUD.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView DataSourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExampleCell" forIndexPath:indexPath];
    NSArray *textArray = [NSArray arrayWithObjects:@"Text Mode",@"Indeterminate Mode",@"Indeterminate With Text Mode",@"AnnularDeterminate Mode",@"AnnularDeterminate With Text Mode", nil];
    cell.textLabel.text = [textArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = self.view.tintColor;
    cell.textLabel.textColor = [UIColor colorWithRed:0.232 green:0.367 blue:0.597 alpha:1.000];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBProgressHUD *progressHUD = [[CBProgressHUD alloc] init];;
    switch (indexPath.row) {
        case 0: {
            [[CBProgressHUD showHUDAddedTo:self.view
                                      mode:CBProgressHUDModeText
                                      text:@"这句话没有什么意思"
                                  animated:YES] hideAnimated:YES
             afterDelay:1.5f];
            
        }
            break;
        case 1: {
            [[CBProgressHUD showHUDAddedTo:self.view
                                      mode:CBProgressHUDModeIndeterminate
                                      text:nil
                                  animated:YES] hideAnimated:YES
             afterDelay:1.5f];
        }
            break;
        case 2: {
            [[CBProgressHUD showHUDAddedTo:self.view
                                      mode:CBProgressHUDModeIndeterminate
                                      text:@"ˊ_>ˋ呵呵哒"
                                  animated:YES] hideAnimated:YES
             afterDelay:1.5f];
        }
            break;
        case 3: {
            progressHUD =[CBProgressHUD showHUDAddedTo:self.view
                                      mode:CBProgressHUDModeAnnularDeterminate
                                      text:nil
                                  animated:YES];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self imitateProgress:progressHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [progressHUD hideAnimated:YES];
                });
            });
        }
            break;
        case 4: {
            progressHUD =[CBProgressHUD showHUDAddedTo:self.view
                                      mode:CBProgressHUDModeAnnularDeterminate
                                      text:@"正在下载中..."
                                  animated:YES];
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self imitateProgress:progressHUD];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [progressHUD hideAnimated:YES];
                });
            });
        }
            break;
        default:
            break;
    }

}

- (void)imitateProgress:(CBProgressHUD *)progressHUD {
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            progressHUD.progress = progress;
        });
        usleep(50000);
    }
}

@end
