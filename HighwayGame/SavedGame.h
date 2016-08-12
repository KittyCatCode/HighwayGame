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
@property NSString* subtitle;
@property NSArray<HighwayNode*>* nodes;
-(instancetype)initWithArrayOfNodes:(NSArray<HighwayNode*>*)nodes title:(NSString*)t subtitle:(NSString*)s;
@end
