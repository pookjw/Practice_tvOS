//
//  GameScene.m
//  Project8
//
//  Created by Jinwoo Kim on 2/12/21.
//

#import "GameScene.h"
#import "ButtonNode.h"
#import "PlayScene.h"

@interface GameScene ()
@property ButtonNode *startNewGame;
@property ButtonNode *howToPlay;
@end

@implementation GameScene

- (void)setup {
    self.startNewGame = [ButtonNode spriteNodeWithImageNamed:@"startNewGameLo"];
    self.howToPlay = [ButtonNode spriteNodeWithImageNamed:@"howToPlayLo"];
}

- (void)didMoveToView:(SKView *)view {
    [self setup];
    [super didMoveToView:view];
    self.anchorPoint = CGPointMake(0.5, 0.5);
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    background.zPosition = -1;
    background.blendMode = SKBlendModeReplace;
    [self addChild:background];
    
    SKSpriteNode *title = [SKSpriteNode spriteNodeWithImageNamed:@"blastazapTitle"];
    title.position = CGPointMake(0, 200);
    [self addChild:title];
    
    SKSpriteNode *strap = [SKSpriteNode spriteNodeWithImageNamed:@"strap"];
    strap.position = CGPointMake(0, 50);
    [self addChild:strap];
    
    //
    
    [self.startNewGame setFocusedImageNamed:@"startNewGameHi"];
    self.startNewGame.position = CGPointMake(0, -100);
    [self addChild:self.startNewGame];
    
    [self.howToPlay setFocusedImageNamed:@"howToPlayHi"];
    self.howToPlay.position = CGPointMake(0, -250);
    [self addChild:self.howToPlay];
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    ButtonNode *previous = (ButtonNode *)context.previouslyFocusedItem;
    ButtonNode *next = (ButtonNode *)context.nextFocusedItem;
    
    if (previous) [previous didLoseFocus];
    if (next) [next didGainFocus];
}

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    id selected = UIScreen.mainScreen.focusedItem;
    UIPress *press = [[presses allObjects] firstObject];
    if ((selected == nil) || (press == nil)) return;
    
    if (press.type == UIPressTypeSelect) {
        if (selected == self.startNewGame) {
            PlayScene *game = [PlayScene sceneWithSize:self.size];
            SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:1];
            [self.view presentScene:game transition:transition];
        }
    }
}

@end
