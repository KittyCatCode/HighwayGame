
//
//  TextureLoader.m
//  HighwayGame
//
//  Created by Pulido, Irene on 6/11/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import "TextureLoader.h"

@implementation TextureLoader
-(instancetype)init {
    self = [super init];
    if(self) {
        self.nodeHelper =           [SKTexture textureWithImageNamed:@"nodehelper.png"];
        self.nodeHelperSelected =   [SKTexture textureWithImageNamed:@"nodehelperselected.png"];
        self.nodeRequired =         [SKTexture textureWithImageNamed:@"noderequired.png"];
        self.nodeRequiredSelected = [SKTexture textureWithImageNamed:@"noderequiredhighlight.png"];
        self.createNode =           [SKTexture textureWithImageNamed:@"createnode.png"];
        self.removeNode =           [SKTexture textureWithImageNamed:@"removenode.png"];
        self.moveMode =             [SKTexture textureWithImageNamed:@"movemode.png"];
        self.connnectMode =         [SKTexture textureWithImageNamed:@"connectmode.png"];
        self.hLetter =              [SKTexture textureWithImageNamed:@"h.png"];
        self.iLetter =              [SKTexture textureWithImageNamed:@"i.png"];
        self.gLetter =              [SKTexture textureWithImageNamed:@"g.png"];
        self.wLetter =              [SKTexture textureWithImageNamed:@"w.png"];
        self.aLetter =              [SKTexture textureWithImageNamed:@"a.png"];
        self.yLetter =              [SKTexture textureWithImageNamed:@"y.png"];
        self.mLetter =              [SKTexture textureWithImageNamed:@"m.png"];
        self.eLetter =              [SKTexture textureWithImageNamed:@"e.png"];
        self.tLetter =              [SKTexture textureWithImageNamed:@"t.png"];
    }
    return self;
}
@end
