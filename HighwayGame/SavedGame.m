//
//  SavedGame.m
//  HighwayGame
//
//  Created by Pulido, Irene on 6/16/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import "SavedGame.h"
#import "HighwayNode.h"
#import "NodeConnection.h"
#import "SharedUtilities.h"
@implementation SavedGame
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.nodes forKey:@"nodes"];//some extra data lost
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeInteger:self.rid forKey:@"rid"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.nodes=[aDecoder decodeObjectForKey:@"nodes"];
        //some extra data built.
        [self.nodes enumerateObjectsUsingBlock:^(HighwayNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.intConnectedForUnserialization enumerateObjectsUsingBlock:^(NSNumber * _Nonnull iobj, NSUInteger idx, BOOL * _Nonnull stop) {
                __block HighwayNode* asNode;
                [self.nodes enumerateObjectsUsingBlock:^(HighwayNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(obj.nodeId==iobj.intValue){asNode=obj;}
                }];
                NodeConnection* c = [NodeConnection new];
                c.toNode=asNode;
                c.connectionRender=[SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(0, 2)];
                [SharedUtilities updateConnectionLine:c.connectionRender withPoint:obj.position andAnotherPoint:asNode.position];
                [obj.connectedNodes addObject:c];
            }];
        }];
        self.title=[aDecoder decodeObjectForKey:@"title"];
        self.rid=(int)[aDecoder decodeIntegerForKey:@"rid"];
    }
    return self;
}
-(instancetype)initWithArrayOfNodes:(NSArray<HighwayNode*>*)nodes withTitle:(NSString*)t withRid:(int)rid{
    self = [super init];
    if(self) {
        self.nodes=nodes;
        self.title=t;
        self.rid=rid;
    }
    return self;
}
@end
