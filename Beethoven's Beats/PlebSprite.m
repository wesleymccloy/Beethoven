//
//  PlebSprite.m
//  Beethoven's Beats
//
//  Created by Wesley McCloy on 2015-06-27.
//  Copyright (c) 2015 Wesley McCloy. All rights reserved.
//

#import "PlebSprite.h"

@implementation PlebSprite

+(instancetype)initWithStartIndex:(int)start
{
    NSArray *textures = [self plebTextures];
    PlebSprite *sprite = [[PlebSprite alloc] initWithTexture:textures[0]];
    if (start == 0) {
        [sprite setTexture:textures[2]];
        NSLog(@"created pleb at top");
    } else if (start == 1) {
        [sprite setTexture:textures[3]];
        NSLog(@"created pleb at right");
    } else if (start == 2) {
        [sprite setTexture:textures[1]];
        NSLog(@"created pleb at bottom");
    } else {
        [sprite setTexture:textures[3]];
        NSLog(@"created pleb at left");
        sprite.xScale = sprite.xScale * -1.0;
    }
    if (!sprite) return nil;
    sprite.startIndex = start;
    return sprite;
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
