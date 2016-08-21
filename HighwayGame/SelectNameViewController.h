//
//  SelectNameViewController.h
//  HighwayGame
//
//  Created by Gabriel Pulido on 8/7/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectNameViewController : UIViewController
- (IBAction)save:(id)sender;
- (IBAction)saveUsingDate:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textbox;
- (void)setSavedGame:(SavedGame*)game;
@end
