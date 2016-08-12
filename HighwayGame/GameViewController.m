//
//  GameViewController.m
//  HighwayGame
//
//  Created by Pulido, Irene on 6/10/16.
//  Copyright (c) 2016 Gabriel Pulido. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "MainScene.h"
#import <SpriteKit/SpriteKit.h>
#import "SelectGameViewController.h"
#import "SavedGame.h"
@interface GameViewController ()
@property SavedGame* g;
@end
@implementation GameViewController

- (void)viewDidLoad
{
    self.isInGame=false;
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)[self.view.subviews objectAtIndex:0];
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
}
- (IBAction)unwindToGame:(UIStoryboardSegue*)sender
{
    self.g = ((SelectGameViewController*)sender.sourceViewController).selectedGame;
    self.isInGame=true;
}
-(IBAction)unwindFromNameSelector:(id)sender {
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
-(void)viewDidLayoutSubviews {
    SKView * skView = (SKView *)[self.view.subviews objectAtIndex:0];
    if(skView.scene&&[skView.scene class]==(self.isInGame?[GameScene class]:[MainScene class])) {
        return;
    }
    // Create and configure the scene.
    SKScene *scene;
    if(!self.isInGame) {
        scene = [MainScene sceneWithSize:skView.frame.size];
        ((MainScene*)scene).c=self;
    } else {//todo: textureloaders are loading separately!!! fix!
        scene = [GameScene sceneWithSize:CGSizeMake(skView.frame.size.width/2,skView.frame.size.height/2)];
        ((GameScene*)scene).game=self.g;
        self.g=nil;
    }
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
