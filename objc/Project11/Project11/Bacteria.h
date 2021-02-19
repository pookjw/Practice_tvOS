//
//  Bacteria.h
//  Project11
//
//  Created by Jinwoo Kim on 2/20/21.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DirectionType) {
    DirectionTypeNorth, DirectionTypeSouth, DirectionTypeEast, DirectionTypeWest
};

@interface Bacteria : UIButton
@property NSUInteger row;
@property NSUInteger col;
@property (nonatomic) UIColor *color;
@property (nonatomic) DirectionType direction;
- (void)addConnection;
- (void)rotate;
@end
