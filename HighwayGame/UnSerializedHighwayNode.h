//
//  UnSerializedHighwayNode.h
//  HighwayGame
//
//  Created by Gabriel Pulido on 8/5/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HighwayNode.h"
@interface UnSerializedHighwayNode : HighwayNode
@property NSArray<NSNumber*>* connected;
@end
