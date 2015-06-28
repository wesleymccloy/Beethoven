//
//  PlebSprite.h
//  Beethoven's Beats
//
//  Created by Wesley McCloy on 2015-06-27.
//  Copyright (c) 2015 Wesley McCloy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface PlebSprite : SKSpriteNode
@property (nonatomic, strong) NSArray *plebTextures;
@property (nonatomic) int startIndex;

+(instancetype)initWithStartIndex:(int)start;
@end
