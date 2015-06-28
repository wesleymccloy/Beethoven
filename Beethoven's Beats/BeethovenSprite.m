//
//  BeethovenSprite.m
//  Beethoven's Beats
//
//  Created by Wesley McCloy on 2015-06-27.
//  Copyright (c) 2015 Wesley McCloy. All rights reserved.
//

#import "BeethovenSprite.h"

@implementation BeethovenSprite

+(instancetype)initAtRest
{
    NSArray *textures = [self beethovenTextures];
    return [[BeethovenSprite alloc] initWithTexture:textures[0]];
}

+(NSArray *)beethovenTextures
{
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"BeethovenAtlas"];
    SKTexture *f1 = [atlas textureNamed:@"BeethovenRest.png"];
    SKTexture *f2 = [atlas textureNamed:@"BeethovenFront.png"];
    SKTexture *f3 = [atlas textureNamed:@"BeethovenBack.png"];
    SKTexture *f4 = [atlas textureNamed:@"BeethovenSide.png"];
    SKTexture *f5 = [atlas textureNamed:@"BeethovenDead.png"];
    return @[f1, f2, f3, f4, f5];
}

-(void)resetTexture
{
    [self setTexture:[self beethovenTextures][0]];
}

-(void)die
{
    self.alive = NO;
    [self setTexture:[self beethovenTextures][4]];
}
@end
