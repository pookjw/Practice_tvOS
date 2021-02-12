//
//  EnemyNode.m
//  Project8
//
//  Created by Jinwoo Kim on 2/13/21.
//

#import "EnemyNode.h"

@interface EnemyNode ()
@property NSString *weaponType;
@end

@implementation EnemyNode

- (EnemyNode *)initWithType:(NSString *)type startPosition:(CGPoint)startPosition xOffset:(CGFloat)xOffset moveStraight:(BOOL)moveStraight {
    self.lastFireTime = 0;
    self.weaponType = [NSString stringWithFormat:@"%@Weapon", type];
    SKTexture *texture = [SKTexture textureWithImageNamed:type];
    self = [super initWithTexture:texture color:UIColor.whiteColor size:[texture size]];
    
    if (self) {
        self.physicsBody = [SKPhysicsBody bodyWithTexture:texture size:[texture size]];
        self.physicsBody.categoryBitMask = CollisionEnemyType;
        self.physicsBody.collisionBitMask = CollisionPlayerWeaponType | CollisionPlayerType;
        self.physicsBody.contactTestBitMask = CollisionPlayerWeaponType | CollisionPlayerType;
        
        self.name = type;
        self.position = CGPointMake(startPosition.x + xOffset, startPosition.y);
        
        [self configureMovement:moveStraight];
    }

    return self;
}

- (void)configureMovement:(BOOL)moveStraight {
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointZero];
    
    if (moveStraight) {
        [path addLineToPoint:CGPointMake(-10000, 0)];
    } else {
        [path addCurveToPoint:CGPointMake(-3500, 0)
                controlPoint1:CGPointMake(0, -self.position.y * 4)
                controlPoint2:CGPointMake(-1000, self.position.y)];
    }
    
    SKAction *movement = [SKAction followPath:path.CGPath asOffset:YES orientToPath:YES speed:600];
    SKAction *sequence = [SKAction sequence:@[movement, [SKAction removeFromParent]]];
    [self runAction:sequence];
}

- (void)fire {
    SKSpriteNode *weapon = [SKSpriteNode spriteNodeWithImageNamed:self.weaponType];
    weapon.name = self.weaponType;
    weapon.position = self.position;
    weapon.zRotation = self.zRotation;
    [self.parent addChild:weapon];
    
    weapon.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:weapon.size];
    weapon.physicsBody.categoryBitMask = CollisionEnemyWeaponType;
    weapon.physicsBody.contactTestBitMask = CollisionPlayerType;
    weapon.physicsBody.collisionBitMask = CollisionPlayerType;
    
    CGFloat speed = 20;
    CGFloat adjustedRotation = self.zRotation + (M_PI / 2);
    CGFloat dx = speed * cos(adjustedRotation);
    CGFloat dy = speed * sin(adjustedRotation);
    
    [weapon.physicsBody applyImpulse:CGVectorMake(dx, dy)];
}

@end
