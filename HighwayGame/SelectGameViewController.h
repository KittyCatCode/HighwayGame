//
//  SelectGameViewController.h
//  HighwayGame
//
//  Created by Pulido, Irene on 6/15/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SavedGame;
@interface SelectGameViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property SavedGame* selectedGame;
@end
