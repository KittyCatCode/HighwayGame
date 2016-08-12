//
//  SelectGameViewController.m
//  HighwayGame
//
//  Created by Pulido, Irene on 6/15/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import "SelectGameViewController.h"
#import "SavedGame.h"
@interface SelectGameViewController ()
@property NSMutableArray<SavedGame*>* games;
@end
@implementation SelectGameViewController

-(void)viewDidLoad {
    NSString* appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    self.games=[NSKeyedUnarchiver unarchiveObjectWithFile:[appSupport stringByAppendingPathComponent:@"save.plist"]];
    if(!self.games) {self.games=[NSMutableArray new];}
    self.navigationItem.rightBarButtonItem=self.editButtonItem;
    self.navigationController.navigationBarHidden = NO;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.games count]+1;
}
- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.games objectAtIndex:indexPath.row].nodes!=nil) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.games removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=self.games.count) {
        //copy the data to the variables
        self.selectedGame=[self.games objectAtIndex:indexPath.row];
    } else {
        self.selectedGame=[[SavedGame alloc] initWithArrayOfNodes:nil title:nil subtitle:nil];
    }
    [self performSegueWithIdentifier:@"unwindToGame" sender:self];
    
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* ret = [tableView dequeueReusableCellWithIdentifier:@"savegamecell"];
    if(indexPath.row==self.games.count) {
        [ret textLabel].text=@"New Game";
        [ret detailTextLabel].text=@"A brand new game.";
    } else {
        [ret textLabel].text=[self.games objectAtIndex:indexPath.row].title;
        [ret detailTextLabel].text=[self.games objectAtIndex:indexPath.row].subtitle;
    }
    return ret;
}
@end
