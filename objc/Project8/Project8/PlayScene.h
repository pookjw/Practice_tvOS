//
//  PlayScene.h
//  Project8
//
//  Created by Jinwoo Kim on 2/13/21.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(uint32_t, CollisionTypes) {
    CollisionPlayerType = 1,
    CollisionPlayerWeaponType = 2,
    CollisionEnemyType = 4,
    CollisionEnemyWeaponType = 8
};

@interface PlayScene : SKScene <SKPhysicsContactDelegate>
- (void)movePlayer:(CGPoint)delta;
- (void)quitGame;
@end

