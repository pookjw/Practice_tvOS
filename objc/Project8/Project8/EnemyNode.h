//
//  EnemyNode.h
//  Project8
//
//  Created by Jinwoo Kim on 2/13/21.
//

#import <SpriteKit/SpriteKit.h>
#import "PlayScene.h"

typedef NS_ENUM(NSUInteger, EnemyWave) {
    EnemyWaveSmallSmall,
    EnemyWaveMediumSmall,
    EnemyWaveLargeSmall,
    EnemyWaveSmallMedium,
    EnemyWaveMediumMedium,
    EnemyWaveLargeMedium,
    EnemyWaveSmallLarge,
    EnemyWaveMediumLarge,
    EnemyWaveLargeLarge,
    EnemyWaveFlurrySmall,
    EnemyWaveFlurryMedium,
    EnemyWaveFlurryLarge
};

@interface EnemyNode : SKSpriteNode
@property double lastFireTime;
- (EnemyNode *)initWithType:(NSString *)type startPosition:(CGPoint)startPosition xOffset:(CGFloat)xOffset moveStraight:(BOOL)moveStraight;
- (void)fire;
@end
