//
//  GameScene.h
//  HighwayGame
//

//  Copyright (c) 2016 Gabriel Pulido. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TextureLoader.h"
@class SavedGame;
@interface GameScene : SKScene
@property bool isLineMode;
@property TextureLoader* tl;
@property SavedGame* game;
@end
