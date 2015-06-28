//
//  BeethovenSprite.h
//  Beethoven's Beats
//
//  Created by Wesley McCloy on 2015-06-27.
//  Copyright (c) 2015 Wesley McCloy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BeethovenSprite : SKSpriteNode
@property (nonatomic, getter=isAlive) BOOL alive;
@property (nonatomic) int facingDirection;
@property (nonatomic, strong) NSArray *beethovenTextures;

+(instancetype)initAtRest;
-(void)resetTexture;
-(void)die;
@end
