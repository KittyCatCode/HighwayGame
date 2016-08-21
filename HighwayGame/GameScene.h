//
//  GameScene.h
//  HighwayGame
//

//  Copyright (c) 2016 Gabriel Pulido. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TextureLoader.h"
@class GameViewController;
@class SavedGame;
@interface GameScene : SKScene
@property bool isLineMode;
@property TextureLoader* tl;
@property SavedGame* game;
@property GameViewController* c;
@end
