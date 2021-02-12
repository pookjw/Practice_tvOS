//
//  ButtonNode.m
//  Project8
//
//  Created by Jinwoo Kim on 2/13/21.
//

#import "ButtonNode.h"

@interface ButtonNode ()
@property SKTexture *focusedImage;
@property SKTexture *unfocusedImage;
@end

@implementation ButtonNode

- (BOOL)canBecomeFocused {
    return YES;
}

- (void)setFocusedImageNamed:(NSString *)name {
    self.focusedImage = [SKTexture textureWithImageNamed:name];
    self.unfocusedImage = self.texture;
    [self setUserInteractionEnabled:YES];
}

- (void)didGainFocus {
    self.texture = self.focusedImage;
}

- (void)didLoseFocus {
    self.texture = self.unfocusedImage;
}

@end
