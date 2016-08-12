//
//  HighwayNode.h
//  HighwayGame
//
//  Created by Pulido, Irene on 6/10/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TextureLoader.h"
#import "NodeConnection.h"

@interface HighwayNode : SKSpriteNode <NSCoding>
@property NSMutableArray<NodeConnection*>* connectedNodes;
-(bool)isConnectedToNode:(HighwayNode*)node withArray:(NSArray<HighwayNode*>*)array;
+(instancetype)getHighwayNodeWithRequired:(bool)required;
-(bool)isDirectlyConnectedTo:(HighwayNode*)node;
-(bool)halfIsDirectlyConnectedTo:(HighwayNode*)node;
-(bool)removeDirectConnectionTo:(HighwayNode*)node;
@property bool internalHasBeenChecked;
@property bool isRequired;
@property int nodeId;
-(bool)isConnectedToNodes:(NSArray<HighwayNode*>*)array withArrayOfAllNodes:(NSArray<HighwayNode*>*)allNodes;
@property NSArray<NSNumber*>* intConnectedForUnserialization;
@end
