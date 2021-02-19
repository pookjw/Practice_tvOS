//
//  Bacteria.m
//  Project11
//
//  Created by Jinwoo Kim on 2/20/21.
//

#import "Bacteria.h"

@interface Bacteria ()
@property UIView *connection;
@end

@implementation Bacteria
@synthesize color = _color;
@synthesize direction = _direction;

+(instancetype)buttonWithType:(UIButtonType)buttonType {
    Bacteria *result = [super buttonWithType:buttonType];
    
    if (result) {
        result.connection = [[UIView alloc] initWithFrame:CGRectMake(27, -11, 16, 12)];
        result.row = 0;
        result.col = 0;
    }
    
    return result;
}

//- (instancetype)init {
//    self = [self init];
//
//    if (self) {
//        self.connection = [[UIView alloc] initWithFrame:CGRectMake(27, -11, 16, 12)];
//        self.row = 0;
//        self.col = 0;
//        self.color = 0;
//        _color = UIColor.grayColor;
//        _direction = DirectionTypeNorth;
//    }
//
//    return self;
//}

- (UIColor *)color {
    // reading: just return the private value
    return _color;
}

- (void)setColor:(UIColor *)color {
    // writing: update the private value
    _color = color;
    
    // make the connection value change its color
    self.connection.backgroundColor = color;
    
    // figure out whice image to use and apply it immediately
    if (color == UIColor.greenColor) {
        [self setImage:[UIImage imageNamed:@"arrowGreen"] forState:UIControlStateNormal];
    } else if (color == UIColor.redColor) {
        [self setImage:[UIImage imageNamed:@"arrowRed"] forState:UIControlStateNormal];
    } else {
        [self setImage:[UIImage imageNamed:@"arrowGray"] forState:UIControlStateNormal];
    }
}

- (DirectionType)direction {
    // reading: just return the private value
    return _direction;
}

- (void)setDirection:(DirectionType)direction {
    // writing: update the private value
    _direction = direction;
    
    // make ourselves point in the correct direction
    switch (direction) {
        case DirectionTypeNorth:
            self.transform = CGAffineTransformIdentity;
            break;
        case DirectionTypeEast:
            self.transform = CGAffineTransformMakeRotation(M_PI / 2);
            break;
        case DirectionTypeSouth:
            self.transform = CGAffineTransformMakeRotation(M_PI);
            break;
        case DirectionTypeWest:
            self.transform = CGAffineTransformMakeRotation(M_PI + M_PI / 2);
            break;
        default:
            break;
    }
}

- (void)addConnection {
    [self addSubview:self.connection];
}

- (void)rotate {
    switch (self.direction) {
        case DirectionTypeNorth:
            self.direction = DirectionTypeEast;
            break;
        case DirectionTypeEast:
            self.direction = DirectionTypeSouth;
            break;
        case DirectionTypeSouth:
            self.direction = DirectionTypeWest;
            break;
        case DirectionTypeWest:
            self.direction = DirectionTypeNorth;
            break;
        default:
            break;
    }
}

@end
