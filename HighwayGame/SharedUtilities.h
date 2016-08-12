//
//  SharedUtilities.h
//  HighwayGame
//
//  Created by Pulido, Irene on 6/14/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "HighwayNode.h"

@interface SharedUtilities : NSObject
+(void)updateConnectionLine:(SKSpriteNode*)line withPoint:(CGPoint)n1 andAnotherPoint:(CGPoint)n2;
+(NSMutableArray<HighwayNode*>*)getAllNodesDirectlyConnectedToNode:(HighwayNode*)n givenArrayOfNodes:(NSArray<HighwayNode*>*)nodes;
+(SKSpriteNode*)getLineForConnectionBetween:(HighwayNode*)start and:(HighwayNode*)end;
+(void)properlyRemoveConnectionsToNode:(HighwayNode*)n fromArray:(NSArray<HighwayNode*>*)a;
@end
