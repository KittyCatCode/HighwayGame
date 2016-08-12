//
//  MainScene.m
//  HighwayGame
//
//  Created by Pulido, Irene on 6/12/16.
//  Copyright © 2016 Gabriel Pulido. All rights reserved.
//

#import "MainScene.h"
@interface MainScene ()
@property TextureLoader* tl;
@end
@implementation MainScene

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.backgroundColor = [UIColor whiteColor];
    if(!self.tl) {
        self.tl = [TextureLoader new];
    }
    //Load the spritenodes for the string The Highway Game
    double cx=0;
    double they=self.frame.size.height/2-45;
    double highwayy=self.frame.size.height/2-90;
    double gamey=self.frame.size.height/2-135;
    int theletters=3;
    int highwayletters=7;
    int gameletters=4;
    SKSpriteNode* temp = [SKSpriteNode spriteNodeWithTexture:self.tl.tLetter];
    [self setupSpriteNode:temp withLetter:0 of:theletters atCenterX:cx atY:they];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.hLetter];
    [self setupSpriteNode:temp withLetter:1 of:theletters atCenterX:cx atY:they];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.eLetter];
    [self setupSpriteNode:temp withLetter:2 of:theletters atCenterX:cx atY:they];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.hLetter];
    [self setupSpriteNode:temp withLetter:0 of:highwayletters atCenterX:cx atY:highwayy];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.iLetter];
    [self setupSpriteNode:temp withLetter:1 of:highwayletters atCenterX:cx atY:highwayy];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.gLetter];
    [self setupSpriteNode:temp withLetter:2 of:highwayletters atCenterX:cx atY:highwayy];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.hLetter];
    [self setupSpriteNode:temp withLetter:3 of:highwayletters atCenterX:cx atY:highwayy];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.wLetter];
    [self setupSpriteNode:temp withLetter:4 of:highwayletters atCenterX:cx atY:highwayy];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.aLetter];
    [self setupSpriteNode:temp withLetter:5 of:highwayletters atCenterX:cx atY:highwayy];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.yLetter];
    [self setupSpriteNode:temp withLetter:6 of:highwayletters atCenterX:cx atY:highwayy];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.gLetter];
    [self setupSpriteNode:temp withLetter:0 of:gameletters atCenterX:cx atY:gamey];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.aLetter];
    [self setupSpriteNode:temp withLetter:1 of:gameletters atCenterX:cx atY:gamey];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.mLetter];
    [self setupSpriteNode:temp withLetter:2 of:gameletters atCenterX:cx atY:gamey];
    [self addChild:temp];
    temp = [SKSpriteNode spriteNodeWithTexture:self.tl.eLetter];
    [self setupSpriteNode:temp withLetter:3 of:gameletters atCenterX:cx atY:gamey];
    [self addChild:temp];
    SKSpriteNode* startPrototypeGameButton = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(self.frame.size.width/2, 45)];
    startPrototypeGameButton.position=CGPointMake(0,self.frame.size.height/2-180);
    startPrototypeGameButton.name=@"protostart";
    [self addChild:startPrototypeGameButton];
    SKLabelNode* startPrototypeGameLabel = [SKLabelNode labelNodeWithText:@"Start Prototype"];
    startPrototypeGameLabel.fontName=@"AmericanTypewriter";
    startPrototypeGameLabel.position=CGPointMake(0,self.frame.size.height/2-180);
    startPrototypeGameLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    startPrototypeGameLabel.name=@"protostart";
    startPrototypeGameLabel.fontSize=28;
    [self addChild:startPrototypeGameLabel];
}
//because DRY
-(void)setupSpriteNode:(SKSpriteNode*)node withLetter:(int)l of:(int)n atCenterX:(CGFloat)x atY:(CGFloat)y {
    int totalTextWidth = 45*n;
    x-=(totalTextWidth/2)-(45/2);
    node.size = CGSizeMake(40, 40);
    node.position = CGPointMake(x+(45*l), y);
}
const int protoPressed=0;
const int timeTrialPressed=1;
const int speedDifferences=2;
const int obstacles=3;
const int mNothing=-1;
int mTouchesBeganIn=-1;
-(void)touchesBegan:(NSSet<UITouch*> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [[touches allObjects] firstObject];
    if([[self nodeAtPoint:[touch locationInNode:self]].name isEqualToString:@"protostart"]) {
        mTouchesBeganIn=protoPressed;
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [[touches allObjects] firstObject];
    if(([[self nodeAtPoint:[touch locationInNode:self]].name isEqualToString:@"protostart"])&&mTouchesBeganIn==protoPressed) {
        [self.c performSegueWithIdentifier:@"showSelector" sender:nil];
        //use later
        /*
        // Create and configure the scene.
        GameScene *scene = [GameScene sceneWithSize:CGSizeMake(self.frame.size.width/2,self.frame.size.height/2)];
        scene.tl=self.tl;
        scene.scaleMode = SKSceneScaleModeAspectFill;
        // Create a transition.
        SKTransition* transition = [SKTransition moveInWithDirection:SKTransitionDirectionRight duration:1];
        // Present the scene.
        [self.view presentScene:scene transition:transition];
         */
    }
}
-(void)update:(CFTimeInterval)currentTime {
    
}

@end
