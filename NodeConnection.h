//
//  Connection.h
//  HighwayGame
//
//  Created by Pulido, Irene on 6/14/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class HighwayNode;
@interface NodeConnection : NSObject
@property SKSpriteNode* connectionRender;
@property HighwayNode* toNode;
@end
