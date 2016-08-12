//
//  HighwayNode.m
//  HighwayGame
//
//  Created by Pulido, Irene on 6/10/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import "HighwayNode.h"
#import "GameScene.h"
#import "SharedUtilities.h"
@interface HighwayNode ()
@end
@implementation HighwayNode
-(bool)isConnectedToNodes:(NSArray<HighwayNode*>*)array withArrayOfAllNodes:(NSArray<HighwayNode *> *)allNodes {
    __block bool ret=true;
    [array enumerateObjectsUsingBlock:^(HighwayNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ret&=[self isConnectedToNode:obj withArray:allNodes];
        NSLog(@"%d",ret);
    }];
    return ret;
}
-(bool)isConnectedToNode:(HighwayNode *)node withArray:(NSArray<HighwayNode*>*)array {
    [self setAllConnectedFalseWithArray:array];
    return [self isConnectedToNodeRecursive:node withArray:array];
}
-(bool)isConnectedToNodeRecursive:(HighwayNode *)node withArray:(NSArray<HighwayNode*>*)array {
    __block bool ret = false;
    self.internalHasBeenChecked=YES;
    if(node==self){return YES;}
    [[SharedUtilities getAllNodesDirectlyConnectedToNode:self givenArrayOfNodes:array] enumerateObjectsUsingBlock:^(HighwayNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(!obj.internalHasBeenChecked) {
            ret|=[obj isConnectedToNodeRecursive:node withArray:array];
            *stop=ret;
        }
    }];
    return ret;
}

-(void)setAllConnectedFalseWithArray:(NSArray<HighwayNode*>*)array{
    self.internalHasBeenChecked=NO;
    [[SharedUtilities getAllNodesDirectlyConnectedToNode:self givenArrayOfNodes:array] enumerateObjectsUsingBlock:^(HighwayNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.internalHasBeenChecked) {
            [obj setAllConnectedFalseWithArray:array];
        }
    }];
    
}
//will not fully init highway node, needs texture
+(instancetype)getHighwayNodeWithRequired:(bool)required  {
    HighwayNode* hn = [HighwayNode spriteNodeWithTexture:nil];
    hn.isRequired=required;
    hn.size=CGSizeMake(20, 20);
    hn.connectedNodes = [NSMutableArray new];
    hn.name=@"hnode";
    hn.zPosition=1;
    return hn;
}
-(bool)isDirectlyConnectedTo:(HighwayNode*)node {
    return [self halfIsDirectlyConnectedTo:node]|[node halfIsDirectlyConnectedTo:self];
}
-(bool)halfIsDirectlyConnectedTo:(HighwayNode*)node {
    __block bool ret=false;
    [self.connectedNodes enumerateObjectsUsingBlock:^(NodeConnection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ret|=obj.toNode==node;
        if(ret){*stop=true;}
    }];
    return ret;
}
-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeBool:self.isRequired forKey:@"required"];
    [aCoder encodeInteger:self.nodeId forKey:@"id"];
    NSMutableArray<NSNumber*>* connections;
    [self.connectedNodes enumerateObjectsUsingBlock:^(NodeConnection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [connections addObject:[NSNumber numberWithInt:obj.toNode.nodeId]];
    }];
    [aCoder encodeObject:connections forKey:@"connected"];
}
//NOTE: This method will NOT fully initialize a HighwayNode. The texture and connections need to be set.
-(HighwayNode*)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    self.isRequired=[aDecoder decodeBoolForKey:@"required"];
    self.nodeId=(int)[aDecoder decodeIntegerForKey:@"id"];
    self.intConnectedForUnserialization=[aDecoder decodeObjectForKey:@"connected"];
    return self;
}
-(bool)removeDirectConnectionTo:(HighwayNode*)node {
    if([self isDirectlyConnectedTo:node]) {
        if([self halfIsDirectlyConnectedTo:node]) {
            __block NodeConnection* toRemove=nil;
            [self.connectedNodes enumerateObjectsUsingBlock:^(NodeConnection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(obj.toNode==node) {
                    [obj.connectionRender removeFromParent];
                    toRemove=obj;
                    *stop=true;
                }
            }];
            if(toRemove) {
                [self.connectedNodes removeObject:toRemove];
            }
            return toRemove;
        } else {
            return [node removeDirectConnectionTo:self];
        }
    }
    return false;
}
@end
