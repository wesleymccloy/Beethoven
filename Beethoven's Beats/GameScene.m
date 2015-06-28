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
@property (nonatomic) int score;
@property (nonatomic, strong) BeethovenSprite *beethoven;
@property (nonatomic, strong) NSMutableArray *plebsUp;
@property (nonatomic, strong) NSMutableArray *plebsDown;
@property (nonatomic, strong) NSMutableArray *plebsLeft;
@property (nonatomic, strong) NSMutableArray *plebsRight;
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    //physics delegate stuff
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    
    //label
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Marker Felt Wide"];
    myLabel.text = @"Pleb Fist!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   self.size.height - 50);
    [self addChild:myLabel];
    
    //background image
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithImageNamed:@"NewBackground"];
    bgImage.size = self.frame.size;
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    bgImage.zPosition = -1;
    [self addChild:bgImage];
    
    
    //beethoven
    self.beethoven = [BeethovenSprite initAtRest];
    self.beethoven.position = CGPointMake(self.size.width/2, self.size.height/2);
    self.beethoven.xScale = self.beethoven.xScale * 2;
    self.beethoven.yScale = self.beethoven.yScale * 2;

    [self addChild:self.beethoven];
    
    //swipe gesture recognizers
    UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [[self view] addGestureRecognizer:recognizerRight];
    UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[self view] addGestureRecognizer:recognizerLeft];
    UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[self view] addGestureRecognizer:recognizerUp];
    UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
    [[self view] addGestureRecognizer:recognizerDown];
    
    //music
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *array = [[NSArray alloc] initWithObjects:@2, @5, @10, nil];
    [prefs setObject:array forKey:@"songMetadata"];
    self.audioMetadata = [prefs arrayForKey:@"songMetadata"];
    [self startMusic];
}


-(void)handleSwipe:(UISwipeGestureRecognizer *)sender
{
    
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionDown:
            NSLog(@"swipe gesture down");
            for (PlebSprite *pleb in self.plebsDown){
                [pleb die];
                NSLog(@"killed Pleb");
            }
            [self.plebsDown removeAllObjects];
            break;
        case UISwipeGestureRecognizerDirectionUp:
            NSLog(@"swipe gesture up");
            for (PlebSprite *pleb in self.plebsUp){
                [pleb die];
                 NSLog(@"killed Pleb");
            }
            [self.plebsUp removeAllObjects];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            NSLog(@"swipe gesture left");
            for (PlebSprite *pleb in self.plebsLeft){
                [pleb die];
                 NSLog(@"killed Pleb");
            }
            [self.plebsLeft removeAllObjects];
            break;
        default:
            NSLog(@"swipe gesture right");
            for (PlebSprite *pleb in self.plebsRight){
                [pleb die];
                 NSLog(@"killed Pleb");
            }
            [self.plebsRight removeAllObjects];
            break;
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"contact detected");
    uint32_t overlap = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
    if (overlap == ([PlebSprite category] | [BeethovenSprite category])) {
        PlebSprite *sprite;
        if (contact.bodyA.categoryBitMask == [PlebSprite category]) {
            sprite = (PlebSprite *)contact.bodyA.node;
        } else {
            sprite = (PlebSprite *)contact.bodyB.node;
        }
        switch (sprite.startIndex) {
            case 0:
                NSLog(@"added pleb to Down");
                [self.plebsDown addObject:sprite];
                break;
            case 1:
                 NSLog(@"added pleb to right");
                [self.plebsRight addObject:sprite];
                break;
            case 2:
                 NSLog(@"added pleb to up");
                [self.plebsUp addObject:sprite];
                break;
            default:
                 NSLog(@"added pleb to left");
                [self.plebsLeft addObject:sprite];
                break;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
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
                               duration:2];
    void (^arrived)(void) = ^void(void) {
        SKAction *actionDone = [SKAction removeFromParent];
        [self.beethoven die];
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

-(NSMutableArray *)plebsRight
{
    if (!_plebsRight) {
        _plebsRight = [[NSMutableArray alloc] init];
    }
    return _plebsRight;
}
-(NSMutableArray *)plebsLeft
{
    if (!_plebsLeft) {
        _plebsLeft = [[NSMutableArray alloc] init];
    }
    return _plebsLeft;
}
-(NSMutableArray *)plebsUp
{
    if (!_plebsUp) {
        _plebsUp = [[NSMutableArray alloc] init];
    }
    return _plebsUp;
}
-(NSMutableArray *)plebsDown
{
    if (!_plebsDown) {
        _plebsDown = [[NSMutableArray alloc] init];
    }
    return _plebsDown;
}

@end
