//
//  GameScene.m
//  Beethoven's Beats
//
//  Created by Wesley McCloy on 2015-06-19.
//  Copyright (c) 2015 Wesley McCloy. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#import "GameScene.h"
#import "PlebSprite.h"
#import "BeethovenSprite.h"

@interface GameScene ()
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSArray *audioMetadata;
@property (nonatomic) int count;
@end

@implementation GameScene


-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    self.alive = YES; //not sure if this is necessary yet
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt Wide"];
    
    myLabel.text = @"Pleb Fist!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   self.size.height - 50);
    
    [self addChild:myLabel];
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"NewBackground"];
    bgImage.size = self.frame.size;
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.zPosition = -1;
    [self addChild:bgImage];
    
    BeethovenSprite *sprite = [BeethovenSprite initAtRest];
    sprite.position = CGPointMake(self.size.width/2, self.size.height/2);
    sprite.xScale = sprite.xScale * 2;
    sprite.yScale = sprite.yScale * 2;
    [self addChild:sprite];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *array = [[NSArray alloc] initWithObjects:@2, @5, @10, nil];
    [prefs setObject:array forKey:@"songMetadata"];
    self.audioMetadata = [prefs arrayForKey:@"songMetadata"];
    [self startMusic];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        [self spawnPlebAtIndex:arc4random()%4];
    }
}

-(void)startMusic
{
    NSError *error;
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"song" ofType:@".mp3"]];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:file error:&error];
    if(error) {
        NSLog(@"can't play audio because: /n %@", [error localizedDescription]);
    } else {
        [self.player prepareToPlay];
    }
    [self.player play];
    self.count = 0;
}

-(void)spawnPlebAtIndex:(int)index
{
    PlebSprite *sprite = [PlebSprite initWithStartIndex:index];
    
    sprite.xScale = sprite.xScale * 2;
    sprite.yScale = sprite.yScale * 2;
    sprite.position = [self plebStartPosition:sprite.startIndex];
    
    SKAction *action = [SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame),
                                                    CGRectGetMidY(self.frame))
                               duration:1];
    void (^arrived)(void) = ^void(void) {
        SKAction *actionDone = [SKAction removeFromParent];
        self.alive = NO;
        NSLog(@"ded");
        [sprite runAction:actionDone];
    };
    
    [sprite runAction:action completion:arrived];
    
    [self addChild:sprite];
}

-(CGPoint)plebStartPosition:(int)a
{
    float x;
    float y;
    if (a == 0) { // starts at top
        x = self.size.width/2;
        y = 0;
    } else if (a == 1) { // starts at right
        x = self.size.width;
        y = self.size.height/2;
    } else if (a == 2) { // starts at bottom
        x = self.size.width/2;
        y = self.size.height;
    } else { // starts at left
        x = 0;
        y = self.size.height/2;
    }
    CGPoint start = {x,y};
    return start;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.count < [self.audioMetadata count]) {
        NSTimeInterval time = [self.audioMetadata[self.count] doubleValue];
        if (time < self.player.currentTime) {
            self.count++;
            [self spawnPlebAtIndex:arc4random()%4];
            NSLog(@"spawnPleb when time is %f", self.player.currentTime);
        }
    }
    
}

@end
