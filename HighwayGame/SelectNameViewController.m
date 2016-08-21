//
//  SelectNameViewController.m
//  HighwayGame
//
//  Created by Gabriel Pulido on 8/7/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//
#import "SavedGame.h"
#import "SelectNameViewController.h"

@interface SelectNameViewController ()
@property SavedGame* game;
@end

@implementation SelectNameViewController
- (IBAction)nameChanged:(id)sender {
    if(![self.textbox.text isEqualToString:@""]) {
        self.navigationItem.rightBarButtonItem.enabled=YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled=NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem.enabled=NO;
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
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden=NO;
}

- (IBAction)save:(id)sender {
    NSString* appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSMutableArray<SavedGame*>* games = [NSKeyedUnarchiver unarchiveObjectWithFile:[appSupport stringByAppendingPathComponent: @"save.plist"]];
    if(!games){games=[NSMutableArray new];}
    self.game.title=self.textbox.text;
    [games addObject:self.game];
    NSLog(@"Game saved to %@",[appSupport stringByAppendingPathComponent: @"save.plist"]);
    [NSKeyedArchiver archiveRootObject:games toFile:[appSupport stringByAppendingPathComponent: @"save.plist"]];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setSavedGame:(SavedGame*)game{
    self.game=(SavedGame*)game;
}
- (IBAction)saveUsingDate:(id)sender {
    NSString* appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    NSMutableArray<SavedGame*>* games = [NSKeyedUnarchiver unarchiveObjectWithFile:[appSupport stringByAppendingPathComponent: @"save.plist"]];
    if(!games){games=[NSMutableArray new];}
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    NSString *dateString=[dateFormatter stringFromDate:[NSDate date]];
    self.game.title=[@"Game played on " stringByAppendingString:dateString];
    [games addObject:self.game];
    NSLog(@"Game saved to %@",[appSupport stringByAppendingPathComponent: @"save.plist"]);
    [NSKeyedArchiver archiveRootObject:games toFile:[appSupport stringByAppendingPathComponent: @"save.plist"]];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
