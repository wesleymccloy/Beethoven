//
//  PlebSprite.m
//  Beethoven's Beats
//
//  Created by Wesley McCloy on 2015-06-27.
//  Copyright (c) 2015 Wesley McCloy. All rights reserved.
//

#import "PlebSprite.h"
#import "BeethovenSprite.h"

@implementation PlebSprite

+(instancetype)initWithStartIndex:(int)start
{
    NSArray *textures = [self plebTextures];
    PlebSprite *sprite = [[PlebSprite alloc] initWithTexture:textures[0]];
    if (start == 0) {
        [sprite setTexture:textures[2]];
        NSLog(@"created pleb at bottom");
    } else if (start == 1) {
        [sprite setTexture:textures[3]];
        NSLog(@"created pleb at right");
    } else if (start == 2) {
        [sprite setTexture:textures[1]];
        NSLog(@"created pleb at top");
    } else {
        [sprite setTexture:textures[3]];
        NSLog(@"created pleb at left");
        sprite.xScale = sprite.xScale * -1.0;
    }
    if (!sprite) return nil;
    sprite.startIndex = start;
    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    sprite.physicsBody.categoryBitMask = [PlebSprite category];
    sprite.physicsBody.contactTestBitMask = [BeethovenSprite category];
    sprite.physicsBody.collisionBitMask = 0;
    return sprite;
}

-(void)die
{
    CGFloat x;
    CGFloat y;
    switch (self.startIndex) {
        case 0:
            x = arc4random() % 5 * arc4random() % 2 ? 1.0 : -1.0;
            y = arc4random() % 5 * -1.0;
            break;
        case 1:
            x = arc4random() % 5;
            y = arc4random() % 5 * arc4random() % 2 ? 1.0 : -1.0;
            break;
        case 2:
            x = arc4random() % 5 * arc4random() % 2 ? 1.0 : -1.0;
            y = arc4random() % 5;
            break;
        default:
            x = arc4random() % 5 * -1.0;
            y = arc4random() % 5 * arc4random() % 2 ? 1.0 : -1.0;
            break;
    }
    [self removeAllActions];
    [self.physicsBody applyImpulse:CGVectorMake(x * 10.0, y * 10.0)];
    //TODO remove sprite from parent
}

+(uint32_t)category
{
    return 0x1 << 1;
}

+(NSArray*)plebTextures
{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"PlebAtlas"];
    SKTexture *f1 = [atlas textureNamed:@"PlebRest.png"];
    SKTexture *f2 = [atlas textureNamed:@"PlebFront.png"];
    SKTexture *f3 = [atlas textureNamed:@"PlebBack.png"];
    SKTexture *f4 = [atlas textureNamed:@"PlebSide.png"];
    return @[f1, f2, f3, f4];
}


@end
