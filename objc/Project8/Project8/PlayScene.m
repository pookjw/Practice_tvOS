//
//  PlayScene.m
//  Project8
//
//  Created by Jinwoo Kim on 2/13/21.
//

#import "PlayScene.h"
#import "GameScene.h"
#import "EnemyNode.h"
#import "NSArray+Shuffled.h"

@interface PlayScene ()
@property SKSpriteNode * player;
@property NSArray<NSNumber *> *levelWaves;
@property NSUInteger levelPosition;
@property NSArray<NSValue *> *positions;
@property BOOL playerIsAlive;
@property SKLabelNode *scoreLabel;
@property (nonatomic) NSInteger score;
@property SKAudioNode *music;
@end

@implementation PlayScene

CGFloat const enemyOffsetX = 100;
static CGFloat const enemyStartX = 1100;

- (void)setup {
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
    self.levelWaves = @[
        [NSNumber numberWithUnsignedInteger:EnemyWaveSmallSmall],
        [NSNumber numberWithUnsignedInteger:EnemyWaveMediumSmall],
        [NSNumber numberWithUnsignedInteger:EnemyWaveLargeSmall],
        [NSNumber numberWithUnsignedInteger:EnemyWaveSmallMedium],
        [NSNumber numberWithUnsignedInteger:EnemyWaveMediumMedium],
        [NSNumber numberWithUnsignedInteger:EnemyWaveLargeMedium],
        [NSNumber numberWithUnsignedInteger:EnemyWaveSmallLarge],
        [NSNumber numberWithUnsignedInteger:EnemyWaveMediumLarge],
        [NSNumber numberWithUnsignedInteger:EnemyWaveLargeLarge],
        [NSNumber numberWithUnsignedInteger:EnemyWaveFlurrySmall],
        [NSNumber numberWithUnsignedInteger:EnemyWaveFlurryMedium],
        [NSNumber numberWithUnsignedInteger:EnemyWaveFlurryLarge]
    ];
    self.levelPosition = 0;
    self.positions = @[
        [NSValue valueWithCGPoint:CGPointMake(enemyStartX, 400)],
        [NSValue valueWithCGPoint:CGPointMake(enemyStartX, 300)],
        [NSValue valueWithCGPoint:CGPointMake(enemyStartX, 200)],
        [NSValue valueWithCGPoint:CGPointMake(enemyStartX, 100)],
        [NSValue valueWithCGPoint:CGPointMake(enemyStartX, 0)],
        [NSValue valueWithCGPoint:CGPointMake(enemyStartX, -100)],
        [NSValue valueWithCGPoint:CGPointMake(enemyStartX, -200)],
        [NSValue valueWithCGPoint:CGPointMake(enemyStartX, -300)],
        [NSValue valueWithCGPoint:CGPointMake(enemyStartX, -400)]
    ];
    self.playerIsAlive = YES;
    self.scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
    self.score = 0;
    
    // [SKAudioNode nodeWithFileNamed:@"cyborgNinja.mp3"]; 가 아님!!!
    self.music = [[SKAudioNode alloc] initWithFileNamed:@"cyborgNinja.mp3"];
}

- (void)setScore:(NSInteger)score {
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", score];
}

- (void)didMoveToView:(SKView *)view {
    [self setup];
    [super didMoveToView:view];
    self.anchorPoint = CGPointMake(0.5, 0.5);
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    background.zPosition = -2;
    background.blendMode = SKBlendModeReplace;
    [self addChild:background];
    
    SKEmitterNode *particles = [SKEmitterNode nodeWithFileNamed:@"starfield"];
    if (particles) {
        particles.position = CGPointMake(1080, 0);
        // 60초가 된 시점의 프레임부터 보여준다.
        [particles advanceSimulationTime:60];
        [self addChild:particles];
    }
    
    self.player.name = @"player";
    self.player.position = CGPointMake(-700, self.player.position.y);
    self.player.zPosition = 1;
    [self addChild:self.player];
    
    //
    
    // create a physics body for the player using its texture at its current size
    self.player.physicsBody = [SKPhysicsBody bodyWithTexture:self.player.texture size:[self.player.texture size]];
    
    // make this as being the player
    self.player.physicsBody.categoryBitMask = CollisionPlayerType;
    
    // tell it to bounce off enemies and enemy weapon
    self.player.physicsBody.collisionBitMask = CollisionEnemyType | CollisionEnemyWeaponType;
    
    // ask SpriteKit to tell us when it collides with enemies and their weapons
    self.player.physicsBody.contactTestBitMask = CollisionEnemyType | CollisionEnemyWeaponType;
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    self.physicsWorld.contactDelegate = self;
    
    //
    
    self.scoreLabel.position = CGPointMake(0, 400);
    self.scoreLabel.zPosition = -1;
    self.scoreLabel.fontSize = 96;
    [self addChild:self.scoreLabel];
    self.score = 0;
    
    //
    
    [self addChild:self.music];
}

- (void)movePlayer:(CGPoint)delta {
    self.player.position = CGPointMake(self.player.position.x, self.player.position.y - (delta.y * 2));
    
    if (self.player.position.y < -500) {
        self.player.position = CGPointMake(self.player.position.x, -500);
    } else if (self.player.position.y > 500) {
        self.player.position = CGPointMake(self.player.position.x, 500);
    }
}

- (void)createWave {
    if (!self.playerIsAlive) return;
    if (self.levelPosition >= self.levelWaves.count) return;
    
    switch ([self.levelWaves[self.levelPosition] unsignedIntegerValue]) {
        case EnemyWaveSmallSmall: {
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[0] CGPointValue]
                                                   xOffset:enemyOffsetX * 2
                                              moveStraight:YES]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[4] CGPointValue]
                                                   xOffset:0
                                              moveStraight:YES]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[8] CGPointValue]
                                                   xOffset:enemyOffsetX * 2
                                              moveStraight:YES]];
            break;
        }
        case EnemyWaveMediumSmall: {
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[2] CGPointValue]
                                                   xOffset:0
                                              moveStraight:NO]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[1] CGPointValue]
                                                   xOffset:enemyOffsetX * 2
                                              moveStraight:NO]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[0] CGPointValue]
                                                   xOffset:enemyOffsetX * 4
                                              moveStraight:NO]];
            
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[6] CGPointValue]
                                                   xOffset:enemyOffsetX
                                              moveStraight:NO]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[7] CGPointValue]
                                                   xOffset:enemyOffsetX * 3
                                              moveStraight:NO]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[8] CGPointValue]
                                                   xOffset:enemyOffsetX * 5
                                              moveStraight:NO]];
            break;
        }
        case EnemyWaveLargeSmall: {
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[4] CGPointValue]
                                                   xOffset:0
                                              moveStraight:YES]];
            
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[3] CGPointValue]
                                                   xOffset:enemyOffsetX
                                              moveStraight:YES]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[2] CGPointValue]
                                                   xOffset:enemyOffsetX * 2
                                              moveStraight:YES]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[1] CGPointValue]
                                                   xOffset:enemyOffsetX * 3
                                              moveStraight:YES]];
            
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[5] CGPointValue]
                                                   xOffset:enemyOffsetX
                                              moveStraight:YES]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[6] CGPointValue]
                                                   xOffset:enemyOffsetX * 2
                                              moveStraight:YES]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[7] CGPointValue]
                                                   xOffset:enemyOffsetX * 3
                                              moveStraight:YES]];
            
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[2] CGPointValue]
                                                   xOffset:enemyOffsetX * 8
                                              moveStraight:NO]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[1] CGPointValue]
                                                   xOffset:enemyOffsetX * 8
                                              moveStraight:NO]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[0] CGPointValue]
                                                   xOffset:enemyOffsetX * 8
                                              moveStraight:NO]];
            
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[6] CGPointValue]
                                                   xOffset:enemyOffsetX * 9
                                              moveStraight:NO]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[7] CGPointValue]
                                                   xOffset:enemyOffsetX * 9
                                              moveStraight:NO]];
            [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                             startPosition:[self.positions[8] CGPointValue]
                                                   xOffset:enemyOffsetX * 9
                                              moveStraight:NO]];
            break;
        }
        default: {
            NSArray<NSValue *> *randomPositions = [self.positions shuffled];
            
            [randomPositions enumerateObjectsUsingBlock:^(NSValue * _Nonnull position, NSUInteger idx, BOOL * _Nonnull stop) {
                [self addChild:[[EnemyNode alloc] initWithType:@"enemy1"
                                                 startPosition:[position CGPointValue]
                                                       xOffset:enemyOffsetX * (CGFloat)(idx * 3)
                                                  moveStraight:YES]];
            }];
            
            break;
        }
    }
    
    self.levelPosition += 1;
}

- (void)update:(NSTimeInterval)currentTime {
    [super update:currentTime];
    
    for (SKNode *child in self.children) {
        if (CGRectGetMaxX(child.frame) < 0) {
            if (!CGRectIntersectsRect(self.frame, child.frame)) {
                [child removeFromParent];
            }
        }
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject isKindOfClass:[EnemyNode class]];
//        return ((EnemyNode *)evaluatedObject != nil);
    }];
    NSArray<EnemyNode *> *enemies = (NSArray<EnemyNode *> *)[self.children filteredArrayUsingPredicate:predicate];
    
    if (enemies.count == 0) [self createWave];
    
    //
    
    for (EnemyNode *enemy in enemies) {
        if ((enemy.lastFireTime + 1) < currentTime) {
            enemy.lastFireTime = currentTime;
            if (arc4random_uniform(2)) {
                [enemy fire];
            }
        }
    }
}

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    if (!self.playerIsAlive) return;
    UIPress *press = [[presses allObjects] firstObject];
    if (press == nil) return;
    
    // check that the player pressed the play button
    if (press.type == UIPressTypePlayPause) {
        // create a weapon
        SKSpriteNode *shot = [SKSpriteNode spriteNodeWithImageNamed:@"playerWeapon"];
        shot.name = @"playerWeapon";
        
        // make it start from the player's position
        shot.position = self.player.position;
        
        // give it rectangular physics
        shot.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:shot.size];
        shot.physicsBody.categoryBitMask = CollisionPlayerWeaponType;
        shot.physicsBody.contactTestBitMask = CollisionEnemyType;
        shot.physicsBody.collisionBitMask = CollisionEnemyType;
        [self addChild:shot];
        
        // tell it to move to the other side of the screen then destory itself
        SKAction *movement = [SKAction moveTo:CGPointMake(1900, shot.position.y) duration:1];
        SKAction *sequence = [SKAction sequence:@[movement, [SKAction removeFromParent]]];
        
        // run it immediately
        [shot runAction:sequence];
        
        self.score -= 1;
        
        //
        
        [self runAction:[SKAction playSoundFileNamed:@"playerWeapon.wav" waitForCompletion:NO]];
    }
}

- (void)gameOver {
    self.playerIsAlive = NO;
    
    SKEmitterNode *explosion = [SKEmitterNode nodeWithFileNamed:@"explosion"];
    if (explosion) {
        explosion.position = self.player.position;
        [self addChild:explosion];
    }
    
    SKSpriteNode *gameOver = [SKSpriteNode spriteNodeWithImageNamed:@"gameOver"];
    [self addChild:gameOver];
    
    [self.music runAction:[SKAction stop]];
}

- (void)quitGame {
    GameScene *menu = [GameScene sceneWithSize:self.size];
    menu.anchorPoint = CGPointMake(0.5, 0.5);
    SKTransition *transition = [SKTransition doorsCloseVerticalWithDuration:1];
    [self.view presentScene:menu transition:transition];
    
    // tell the root view controller to update its focus
    [menu runAction:[SKAction waitForDuration:0.1] completion:^{
        [menu.view.window.rootViewController setNeedsFocusUpdate];
    }];
}

#pragma SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    // make sure node colliding objects have SpriteKit nodes attached
    SKNode *nodeA = contact.bodyA.node;
    SKNode *nodeB = contact.bodyB.node;
    if ((nodeA == nil) || (nodeB == nil)) return;
    
    // if either node was the player, the game is over
    if ([nodeA.name isEqualToString:@"player"] || [nodeB.name isEqualToString:@"player"]) {
        if (!self.playerIsAlive) return;
        [self gameOver];
    } else {
        // create an explosion
        SKEmitterNode *explosion = [SKEmitterNode nodeWithFileNamed:@"explosion"];
        if (explosion) {
            // if the first object is the player weapon
            if ([nodeA.name isEqualToString:@"playerWeapon"]) {
                // position the explosion over the other object
                explosion.position = nodeB.position;
            } else {
                // otherwise position the object over the first object
                explosion.position = nodeA.position;
            }
            
            [self runAction:[SKAction playSoundFileNamed:@"explosion.wav" waitForCompletion:NO]];
            
            // add the explosion to the game
            [self addChild:explosion];
            
            self.score += 10;
        }
    }
    
    [nodeA removeFromParent];
    [nodeB removeFromParent];
}

@end
