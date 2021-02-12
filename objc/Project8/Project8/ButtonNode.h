//
//  ButtonNode.h
//  Project8
//
//  Created by Jinwoo Kim on 2/13/21.
//

#import <SpriteKit/SpriteKit.h>

@interface ButtonNode : SKSpriteNode
- (void)setFocusedImageNamed:(NSString *)name;
- (void)didGainFocus;
- (void)didLoseFocus;
@end
