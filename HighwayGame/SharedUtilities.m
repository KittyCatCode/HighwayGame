//
//  SharedUtilities.m
//  HighwayGame
//
//  Created by Pulido, Irene on 6/14/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import "SharedUtilities.h"
@implementation SharedUtilities
+(void)updateConnectionLine:(SKSpriteNode *)line withPoint:(CGPoint)n1 andAnotherPoint:(CGPoint)n2 {
    double angle = atan2(n1.y-n2.y, n1.x-n2.x);
    double ydist = n1.y-n2.y;
    double xdist = n1.x-n2.x;
    double dist = sqrt(ydist*ydist+xdist*xdist);
    line.size=CGSizeMake(dist, 2);
    line.position=CGPointMake(n2.x+((dist/2)*cos(angle)),n2.y+((dist/2)*sin(angle)));
    line.zRotation=angle;
}
+(NSMutableArray<HighwayNode*> *)getAllNodesDirectlyConnectedToNode:(HighwayNode *)n givenArrayOfNodes:(NSArray<HighwayNode*> *)nodes {
    NSMutableArray* ret = [NSMutableArray new];
    [n.connectedNodes enumerateObjectsUsingBlock:^(NodeConnection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ret addObject:obj.toNode];
    }];
    [nodes enumerateObjectsUsingBlock:^(HighwayNode*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj!=n) {
            __block bool objConnectsToNode = false;
            [obj.connectedNodes enumerateObjectsUsingBlock:^(NodeConnection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                objConnectsToNode|=obj.toNode==n;
                *stop=objConnectsToNode;
            }];
            if(objConnectsToNode){
                [ret addObject:obj];
            }
        }
    }];
    return ret;
}
+(SKSpriteNode*)getLineForConnectionBetween:(HighwayNode*)start and:(HighwayNode*)end {
    if([start halfIsDirectlyConnectedTo:end]) {
        __block SKSpriteNode* line;
        [start.connectedNodes enumerateObjectsUsingBlock:^(NodeConnection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.toNode==end) {
                line=obj.connectionRender;
            }
        }];
        return line;
    } else if([end halfIsDirectlyConnectedTo:start])  {
        return [self getLineForConnectionBetween:end and:start];
    }
    return nil;
}
+(void)properlyRemoveConnectionsToNode:(HighwayNode *)n fromArray:(NSArray<HighwayNode *> *)a {
    [n.connectedNodes enumerateObjectsUsingBlock:^(NodeConnection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.connectionRender removeFromParent];
    }];
    [n.connectedNodes removeAllObjects];
    NSArray<HighwayNode*>* dc = [self getAllNodesDirectlyConnectedToNode:n givenArrayOfNodes:a];
    [dc enumerateObjectsUsingBlock:^(HighwayNode*  _Nonnull objn, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray* toDelete = [NSMutableArray new];
        [objn.connectedNodes enumerateObjectsUsingBlock:^(NodeConnection * _Nonnull objc, NSUInteger idx, BOOL * _Nonnull stop) {
            if(objc.toNode==n) {
                [objc.connectionRender removeFromParent];
                [toDelete addObject:objc];
            }
        }];
        [objn.connectedNodes removeObjectsInArray:toDelete];
    }];
}
@end
