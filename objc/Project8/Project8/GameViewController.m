//
//  GameViewController.m
//  Project8
//
//  Created by Jinwoo Kim on 2/12/21.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "PlayScene.h"

@implementation GameViewController

- (SKScene * _Nullable)gameScene {
    return ((SKView *)self.view).scene;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load the SKScene from 'GameScene.sks'
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKView *skView = (SKView *)self.view;
    
    // Present the scene
    [skView presentScene:scene];
    
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movementMade:)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    UIPress *press = [[presses allObjects] firstObject];
    if (press == nil) return;
    
    if (press.type == UIPressTypeMenu) {
        if ([[self gameScene] isKindOfClass:[PlayScene class]] && ([self gameScene] != nil)) {
            [(PlayScene *)[self gameScene] quitGame];
        } else {
            [super pressesBegan:presses withEvent:event];
        }
    }
    
    [[self gameScene] pressesBegan:presses withEvent:event];
}

- (void)movementMade:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:recognizer.view];
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
    PlayScene *scene = (PlayScene *)[self gameScene];
    if (scene) [scene movePlayer:translation];
}

@end
