//
//  GameScene.m
//  HighwayGame
//
//  Created by Pulido, Irene on 6/10/16.
//  Copyright (c) 2016 Gabriel Pulido. All rights reserved.
//

#import "GameScene.h"
#import "HighwayNode.h"
#import "NodeConnection.h"
#import "SharedUtilities.h"
#import "SavedGame.h"
#import "GameViewController.h"
#import "MainScene.h"
@interface GameScene ()
@property SKSpriteNode* connectMode;
@property SKSpriteNode* moveMode;
@property SKSpriteNode* inProgressConnection;
@property CGPoint beginningLocation;
@property NSMutableArray<HighwayNode*>* nodes;
@property SKNode* startingNode;
@property SKLabelNode* counter;
@property SKLabelNode* highscorecounter;
@property CGFloat highscore;
@property NSMutableArray<HighwayNode*>* requiredNodes;
@property int useId;
@end
@implementation GameScene
//saving done and delegate
-(void)didMoveToView:(SKView *)view {
    self.highscore=-1;
    // Setup your scene here
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.backgroundColor = [UIColor whiteColor];
    if(!self.tl) {
        self.tl = [TextureLoader new];
    }
    if(self.game.nodes==nil) {
        self.requiredNodes = [NSMutableArray new];
        self.nodes = [NSMutableArray new];
        for(int i=0;i<(self.frame.size.width*self.frame.size.height)/5078;i++) {
            HighwayNode* randomNode = [HighwayNode getHighwayNodeWithRequired:true];
            randomNode.texture=self.tl.nodeRequired;
            randomNode.position = CGPointMake([self randomFloat:-self.frame.size.width/2+20 max:self.frame.size.width/2-20], [self randomFloat:-self.frame.size.height/2+40 max:self.frame.size.height/2-20]);
            __block bool c=false;
            [self.nodes enumerateObjectsUsingBlock:^(HighwayNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if(40>sqrt(pow(obj.position.x-randomNode.position.x,2)+pow(obj.position.y-randomNode.position.y,2))){
                    c=true;
                }
            }];
            if(c){i--;continue;}
            randomNode.nodeId=i;
            [self addChild:randomNode];
            [self.nodes addObject:randomNode];
            [self.requiredNodes addObject:randomNode];
        }
        self.game.nodes=self.nodes;
        self.useId=(int)self.nodes.count;
    } else {
        self.nodes=[NSMutableArray arrayWithArray:self.game.nodes];
        self.requiredNodes=[NSMutableArray new];
        self.game.nodes=self.nodes;
        [self.nodes enumerateObjectsUsingBlock:^(HighwayNode * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
            if(node.nodeId+1>self.useId) {
                self.useId=node.nodeId+1;
            }
            [self addChild:node];
            [node.connectedNodes enumerateObjectsUsingBlock:^(NodeConnection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self addChild:obj.connectionRender];
            }];
            if(node.isRequired) {
                [self.requiredNodes addObject:node];
            }
        }];
    }
    //Show the amazing slider.
    self.moveMode = [SKSpriteNode spriteNodeWithTexture:self.tl.moveMode];
    self.moveMode.size=CGSizeMake(40, 20);
    self.moveMode.position = CGPointMake(-self.frame.size.width/2+self.moveMode.size.width/2, -self.frame.size.height/2+self.moveMode.size.height/2);
    self.moveMode.zPosition=-2;
    self.moveMode.name=@"slider";
    [self addChild:self.moveMode];
    self.connectMode = [SKSpriteNode spriteNodeWithTexture:self.tl.connnectMode];
    self.connectMode.size=CGSizeMake(40, 20);
    self.connectMode.position = CGPointMake(-self.frame.size.width/2+self.connectMode.size.width/2+self.moveMode.size.width, -self.frame.size.height/2+self.connectMode.size.height/2);
    self.connectMode.zPosition=-2;
    self.connectMode.name=@"slider";
    [self addChild:self.connectMode];
    SKSpriteNode* coverup = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:self.connectMode.size];
    coverup.position=self.connectMode.position;
    coverup.zPosition=-1;
    [self addChild:coverup];
    SKSpriteNode* addHelperNode = [SKSpriteNode spriteNodeWithTexture:self.tl.createNode];
    addHelperNode.name=@"addHelper";
    addHelperNode.size=CGSizeMake(20, 20);
    addHelperNode.position=CGPointMake(-self.frame.size.width/2+40+addHelperNode.size.width/2, -self.frame.size.height/2+addHelperNode.size.height/2);
    addHelperNode.zPosition=-0.5;
    [self addChild:addHelperNode];
    SKSpriteNode* removeHelperNode = [SKSpriteNode spriteNodeWithTexture:self.tl.removeNode];
    removeHelperNode.name=@"removeHelper";
    removeHelperNode.size=CGSizeMake(20, 20);
    removeHelperNode.position=CGPointMake(addHelperNode.position.x+20, addHelperNode.position.y);
    removeHelperNode.zPosition=-0.5;
    [self addChild:removeHelperNode];
    SKNode* save = [self buttonWithText:@"Save" withName:@"save" withFontSize:10];
    save.position=CGPointMake(self.size.width/2-save.frame.size.width/2, -self.size.height/2+10);
    [self addChild: save];
    SKNode* done = [self buttonWithText:@"Done" withName:@"done" withFontSize:10];
    done.position=CGPointMake(self.size.width/2-save.frame.size.width-done.frame.size.width/2-10, -self.size.height/2+10);
    [self addChild: done];
    self.counter = [SKLabelNode labelNodeWithText:@"Length: 0.00 m"];
    self.counter.fontName=@"AmericanTypewriter";
    self.counter.fontSize=5;
    self.counter.fontColor=[UIColor blackColor];
    self.counter.position=CGPointMake(self.size.width/2-self.counter.frame.size.width/2-save.frame.size.width-done.frame.size.width-20, -self.size.height/2+15);
    self.counter.verticalAlignmentMode=SKLabelVerticalAlignmentModeCenter;
    [self addChild:self.counter];
    self.highscorecounter = [SKLabelNode labelNodeWithText:@"Lowscore: 0.00 m"];
    self.highscorecounter.fontName=@"AmericanTypewriter";
    self.highscorecounter.fontSize=5;
    self.highscorecounter.fontColor=[UIColor blackColor];
    self.highscorecounter.position=CGPointMake(self.size.width/2-self.highscorecounter.frame.size.width/2-save.frame.size.width-done.frame.size.width-20, -self.size.height/2+5);
    self.highscorecounter.verticalAlignmentMode=SKLabelVerticalAlignmentModeCenter;
    [self addChild:self.highscorecounter];
    [self updateCounter];
}
-(SKNode*)buttonWithText:(NSString*)text withName:(NSString*)name withFontSize:(int)f {
    SKLabelNode* txt = [SKLabelNode labelNodeWithText:text];
    txt.fontColor=[UIColor blackColor];
    txt.fontName=@"AmericanTypewriter";
    txt.zPosition=1;
    txt.fontSize=f;
    txt.verticalAlignmentMode=SKLabelVerticalAlignmentModeCenter;
    txt.position=CGPointMake(0, 0);
    txt.name=[name stringByAppendingString:@"Text"];
    CGFloat width =[text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:txt.fontName size:txt.fontSize]}].width;
    SKSpriteNode* bg = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(width+5,(txt.fontSize*2)+5)];
    bg.position=CGPointMake(0, 0);
    bg.zPosition=0;
    bg.name=name;
    [bg addChild:txt];
    return bg;
}
const int sliderPressed=0;
const int nodePressed=1;
const int createHelperNode=2;
const int savePressed=3;
const int donePressed=4;
const int gNothing=-1;
int gTouchesBeganIn=gNothing;
-(void)touchesBegan:(NSSet<UITouch*> *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if([[touches allObjects] count]<1){return;}
    UITouch* touch = [[touches allObjects] firstObject];
    self.beginningLocation=[touch locationInNode:self];
    self.startingNode = [self nodeAtPoint:[touch locationInNode:self]];
    bool hasFoundStart=false;
    if([self.startingNode.name isEqualToString:@"slider"]) {
        gTouchesBeganIn=sliderPressed;
        hasFoundStart=true;
    }
    if([self.startingNode.name isEqualToString:@"hnode"]) {
        gTouchesBeganIn=nodePressed;
        [((HighwayNode*)self.startingNode) setTexture:(((HighwayNode*)self.startingNode).isRequired?self.tl.nodeRequiredSelected:self.tl.nodeHelperSelected)];
        if(((HighwayNode*)self.startingNode).isRequired&&!self.isLineMode) {
            [self.moveMode runAction:[SKAction moveBy:CGVectorMake(-40, 0) duration:0.2]];
            [self.connectMode runAction:[SKAction moveBy:CGVectorMake(-40, 0) duration:0.2]];
            self.isLineMode=true;
        }
        if(self.isLineMode) {
            //gTouchesBeganIn is already set by the if statement above.
            self.inProgressConnection=[SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(0, 2)];
            [self addChild:self.inProgressConnection];
        }
        hasFoundStart=true;
    }
    if([self.startingNode.name isEqualToString:@"addHelper"]) {
        if(self.isLineMode){
            [self.moveMode runAction:[SKAction moveBy:CGVectorMake(40, 0) duration:0.2]];
            [self.connectMode runAction:[SKAction moveBy:CGVectorMake(40, 0) duration:0.2]];
        }
        self.isLineMode=false;
        self.startingNode=[HighwayNode getHighwayNodeWithRequired:false];
        self.startingNode.position=[touch locationInNode:self];
        [self addChild:self.startingNode];
        [self.nodes addObject:(HighwayNode*)self.startingNode];
        gTouchesBeganIn=nodePressed;
        [((HighwayNode*)self.startingNode) setTexture:(((HighwayNode*)self.startingNode).isRequired?self.tl.nodeRequiredSelected:self.tl.nodeHelperSelected)];
        ((HighwayNode*)self.startingNode).nodeId=self.useId;
        self.useId++;
        hasFoundStart=true;
    }
    if([self.startingNode.name hasPrefix:@"save"]) {
        //mejirushi, ..., miagete hoshii
        gTouchesBeganIn=savePressed;
        if([self.startingNode.name isEqualToString:@"saveText"]) {
            ((SKLabelNode*)self.startingNode).fontColor=[UIColor whiteColor];
            ((SKSpriteNode*)self.startingNode.parent).color=[UIColor blackColor];
        } else {
            ((SKLabelNode*)self.startingNode.children[0]).fontColor=[UIColor whiteColor];
            ((SKSpriteNode*)self.startingNode).color=[UIColor blackColor];
        }
        hasFoundStart=true;
    }
    if([self.startingNode.name hasPrefix:@"done"]) {
        gTouchesBeganIn=donePressed;
        if([self.startingNode.name isEqualToString:@"doneText"]) {
            ((SKLabelNode*)self.startingNode).fontColor=[UIColor whiteColor];
            ((SKSpriteNode*)self.startingNode.parent).color=[UIColor blackColor];
        } else {
            ((SKLabelNode*)self.startingNode.children[0]).fontColor=[UIColor whiteColor];
            ((SKSpriteNode*)self.startingNode).color=[UIColor blackColor];
        }
        hasFoundStart=true;
    }
    if([self.startingNode.name hasPrefix:@"save"]) {
        gTouchesBeganIn=savePressed;
        if([self.startingNode.name isEqualToString:@"saveText"]) {
            ((SKLabelNode*)self.startingNode).fontColor=[UIColor whiteColor];
            ((SKSpriteNode*)self.startingNode.parent).color=[UIColor blackColor];
        } else {
            ((SKLabelNode*)self.startingNode.children[0]).fontColor=[UIColor whiteColor];
            ((SKSpriteNode*)self.startingNode).color=[UIColor blackColor];
        }
        hasFoundStart=true;
    }
    if(!hasFoundStart) {
        gTouchesBeganIn=gNothing;
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if([[touches allObjects] count]<1){return;}
    UITouch* touch = [[touches allObjects] firstObject];
    if(gTouchesBeganIn==nodePressed) {
        if(self.isLineMode) {
            [SharedUtilities updateConnectionLine:self.inProgressConnection withPoint:[touch locationInNode:self] andAnotherPoint:self.startingNode.position];
        } else {
            if(!((HighwayNode*)self.startingNode).isRequired) {
                ((HighwayNode*)self.startingNode).position = [touch locationInNode:self];
                NSMutableArray<HighwayNode*>* connectedNodes = [SharedUtilities getAllNodesDirectlyConnectedToNode:(HighwayNode*)self.startingNode givenArrayOfNodes:self.nodes];
                [connectedNodes enumerateObjectsUsingBlock:^(HighwayNode*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    SKSpriteNode* line = [SharedUtilities getLineForConnectionBetween:((HighwayNode*)self.startingNode) and:obj];
                    [SharedUtilities updateConnectionLine:line withPoint:self.startingNode.position andAnotherPoint:obj.position];
                }];
            }
        }
        [self updateCounter];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if([[touches allObjects] count]<1){return;}
    UITouch* touch = [[touches allObjects] firstObject];
    if(([[self nodeAtPoint:[touch locationInNode:self]].name isEqualToString:@"slider"])&&gTouchesBeganIn==sliderPressed) {
        // Flip the property.
        self.isLineMode=!self.isLineMode;
        // Now flip the visual part.
        if(!self.isLineMode) {
            [self.moveMode runAction:[SKAction moveBy:CGVectorMake(40, 0) duration:0.2]];
            [self.connectMode runAction:[SKAction moveBy:CGVectorMake(40, 0) duration:0.2]];
        } else {
            [self.moveMode runAction:[SKAction moveBy:CGVectorMake(-40, 0) duration:0.2]];
            [self.connectMode runAction:[SKAction moveBy:CGVectorMake(-40, 0) duration:0.2]];
        }
    }
    if(gTouchesBeganIn==savePressed) {
        if([self.startingNode.name isEqualToString:@"save"]) {
            ((SKSpriteNode*)self.startingNode).color=[UIColor whiteColor];
            ((SKLabelNode*)self.startingNode.children[0]).fontColor=[UIColor blackColor];
        } else {
            ((SKLabelNode*)self.startingNode).fontColor=[UIColor blackColor];
            ((SKSpriteNode*)self.startingNode.parent).color=[UIColor whiteColor];
        }
        if(([[self nodeAtPoint:[touch locationInNode:self]].name hasPrefix:@"save"])) {
            [self saveGame];
        }
    }
    if(gTouchesBeganIn==donePressed) {
        if([self.startingNode.name isEqualToString:@"done"]) {
            ((SKSpriteNode*)self.startingNode).color=[UIColor whiteColor];
            ((SKLabelNode*)self.startingNode.children[0]).fontColor=[UIColor blackColor];
        } else {
            ((SKLabelNode*)self.startingNode).fontColor=[UIColor blackColor];
            ((SKSpriteNode*)self.startingNode.parent).color=[UIColor whiteColor];
        }
        if([[self nodeAtPoint:[touch locationInNode:self]].name hasPrefix:@"done"]) {
            if(self.game.title) {
                [self saveGame];
                self.c.isInGame=false;
                MainScene* scene = [MainScene sceneWithSize:CGSizeMake(self.size.width*2, self.size.height*2)];
                scene.tl=self.tl;
                scene.c=self.c;
                [self.view presentScene:scene transition:[SKTransition revealWithDirection:SKTransitionDirectionRight duration:0.1]];
            } else {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Save?" message:@"Do you want to leave without saving?" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self.c.isInGame=false;
                    MainScene* scene = [MainScene sceneWithSize:CGSizeMake(self.size.width*2, self.size.height*2)];
                    scene.tl=self.tl;
                    scene.c=self.c;
                    [self.view presentScene:scene transition:[SKTransition revealWithDirection:SKTransitionDirectionRight duration:0.1]];
                }]];
                [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                [self.c presentViewController:alert animated:YES completion:^{
                    
                }];
            }
        }
    }
    if(gTouchesBeganIn==nodePressed) {
        if(self.isLineMode&&[[self nodeAtPoint:[touch locationInNode:self]].name isEqualToString:@"hnode"]) {
            if(([self nodeAtPoint:[touch locationInNode:self]]!=self.startingNode)) {
                //Detect if there isn't already a connection present.
                if(![(HighwayNode*)self.startingNode isDirectlyConnectedTo:((HighwayNode*)[self nodeAtPoint:[touch locationInNode:self]])]) {
                    [SharedUtilities updateConnectionLine:self.inProgressConnection withPoint:self.startingNode.position andAnotherPoint:[self nodeAtPoint:[touch locationInNode:self]].position];
                    NodeConnection* con = [[NodeConnection alloc] init];
                    con.connectionRender=self.inProgressConnection;
                    con.toNode=(HighwayNode*)[self nodeAtPoint:[touch locationInNode:self]];
                    [((HighwayNode*)self.startingNode).connectedNodes addObject:con];
                    self.inProgressConnection=nil;
                    [self updateCounter];
                } else {
                    //If there is, remove it.
                    [(HighwayNode*)self.startingNode removeDirectConnectionTo:((HighwayNode*)[self nodeAtPoint:[touch locationInNode:self]])];
                    //Remove the IPC that caused this as well.
                    [self.inProgressConnection removeFromParent];
                    self.inProgressConnection=nil;
                    [self updateCounter];
                }
            } else {
                [self.inProgressConnection removeFromParent];
            }
        } else if(self.isLineMode) {
            [self.inProgressConnection removeFromParent];
            self.inProgressConnection=nil;
            [self updateCounter];
        } else {
            CGRect toolbar = CGRectMake(-self.frame.size.width/2, -self.frame.size.height/2, self.frame.size.width, 20);
            if(CGRectContainsPoint(toolbar, [touch locationInNode:self])) {
                [SharedUtilities properlyRemoveConnectionsToNode:((HighwayNode*)self.startingNode) fromArray:self.nodes];
                [self updateCounter];
                //In case somebody clicks during the anim.
                HighwayNode* sn = (HighwayNode*)self.startingNode;
                [sn runAction:[SKAction moveTo:[self childNodeWithName:@"removeHelper"].position duration:0.4] completion:^{
                    [sn removeFromParent];
                }];
            }
        }
        [((HighwayNode*)self.startingNode) setTexture:(((HighwayNode*)self.startingNode).isRequired?self.tl.nodeRequired:self.tl.nodeHelper)];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
}
-(void)updateCounter {
    __block double length=0;
    [self.nodes enumerateObjectsUsingBlock:^(HighwayNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.connectedNodes enumerateObjectsUsingBlock:^(NodeConnection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            length+=obj.connectionRender.size.width;
        }];
    }];
    length+=self.inProgressConnection.size.width;
    CGFloat oldRight=self.counter.position.x+self.counter.frame.size.width/2;
    self.counter.text=[NSString stringWithFormat:@"Length: %.2f m",length];
    self.counter.position=CGPointMake(oldRight-self.counter.frame.size.width/2, self.counter.position.y);
    oldRight=self.highscorecounter.position.x+self.highscorecounter.frame.size.width/2;
    if(((length<self.highscore)||(self.highscore==-1))&&([[self.requiredNodes firstObject] isConnectedToNodes:self.requiredNodes withArrayOfAllNodes:self.nodes])) {
        self.highscore=length;
        self.highscorecounter.text=[NSString stringWithFormat:@"Lowscore: %.2f m",length];
    }
    self.highscorecounter.position=CGPointMake(oldRight-self.highscorecounter.frame.size.width/2, self.highscorecounter.position.y);
}
-(CGFloat) randomFloat:(CGFloat)min max:(CGFloat) max {
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(max-min)+min;
}
-(void) saveGame {
    if(self.game.title) {
        NSString* appSupport = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
        NSMutableArray<SavedGame*>* games = [NSKeyedUnarchiver unarchiveObjectWithFile:[appSupport stringByAppendingPathComponent:@"save.plist"]];
        [games enumerateObjectsUsingBlock:^(SavedGame* game, NSUInteger idx, BOOL * _Nonnull stop) {
            if(game.rid==self.game.rid) {
                game.nodes=self.nodes;
            }
        }];
        [NSKeyedArchiver archiveRootObject:games toFile:[appSupport stringByAppendingPathComponent:@"save.plist"]];
    } else {
        [self.c performSegueWithIdentifier:@"showNamer" sender:self.game];
    }
}
@end
