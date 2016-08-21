//
//  SavedGame.h
//  HighwayGame
//
//  Created by Pulido, Irene on 6/16/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
@class HighwayNode;
@interface SavedGame : NSObject <NSCoding>
@property NSString* title;
@property NSArray<HighwayNode*>* nodes;
@property int rid;
-(instancetype)initWithArrayOfNodes:(NSArray<HighwayNode*>*)nodes withTitle:(NSString*)t withRid:(int)rid;
@end
