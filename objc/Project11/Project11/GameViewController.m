//
//  GameViewController.m
//  Project11
//
//  Created by Jinwoo Kim on 2/20/21.
//

#import "GameViewController.h"
#import "Bacteria.h"

@interface GameViewController ()
@property (weak, nonatomic) IBOutlet UIView *greenTurnMarker;
@property (weak, nonatomic) IBOutlet UILabel *greenScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *redTurnMarker;
@property (weak, nonatomic) IBOutlet UILabel *redScoreLabel;
@property NSMutableArray<NSArray<Bacteria *> *> *grid;
@property UIView *moveHighlight;
@property NSMutableDictionary<UIColor *, Bacteria *> *lastSelected;
@property NSUInteger bacteriaBeingInfected;
@property (nonatomic) UIColor *currentPlayer;
@end

@implementation GameViewController

- (void)setCurrentPlayer:(UIColor *)currentPlayer {
    _currentPlayer = currentPlayer;
    
    if (currentPlayer == UIColor.greenColor) {
        self.greenScoreLabel.textColor = UIColor.yellowColor;
        self.greenTurnMarker.alpha = 1;
        self.redScoreLabel.textColor = UIColor.whiteColor;
        self.redTurnMarker.alpha = 0;
    } else {
        self.greenScoreLabel.textColor = UIColor.whiteColor;
        self.greenTurnMarker.alpha = 0;
        self.redScoreLabel.textColor = UIColor.yellowColor;
        self.redTurnMarker.alpha = 1;
    }
}

- (void)setup {
    self.grid = [@[] mutableCopy];
    self.moveHighlight = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.lastSelected = [@{} mutableCopy];
    self.bacteriaBeingInfected = 0;
    _currentPlayer = UIColor.greenColor;
}

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
    
    // 1: Set up our sizes
    CGFloat xOffset = 90;
    CGFloat yOffset = 140;
    CGFloat gridSize = 80;
    CGFloat buttonSize = 70;
    
    // 2: Loop from 0 to 10 and create a new array of Bacteria
    for (NSUInteger row = 0; row < 11; row++) {
        NSMutableArray<Bacteria *> *rowArray = [@[] mutableCopy];
        
        // 3: Loop from 0 to 21 and create new individual Bacteria
        for (NSUInteger col = 0; col < 22; col++) {
            Bacteria *btn = [Bacteria buttonWithType:UIButtonTypeCustom];
            [btn addConnection];
            
            // 4: Give the new bacteria some basic properties
            btn.frame = CGRectMake(xOffset + (col * gridSize),
                                   yOffset + (row * gridSize),
                                   buttonSize,
                                   buttonSize);
            //            [btn setImage:[UIImage imageNamed:@"arrowGray"] forState:UIControlStateNormal];
            btn.color = UIColor.grayColor;
            btn.row = row;
            btn.col = col;
            [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventPrimaryActionTriggered];
            
            // 5: Add it to our view and to its row array
            [self.view addSubview:btn];
            [rowArray addObject:btn];
            
            if (row <= 5) {
                // pick a semi-random direction {
                if ((btn.row == 0) && btn.col == 0) {
                    // make sure the player starts pointing away from anything
                    btn.direction = DirectionTypeNorth;
                } else if ((btn.row == 0) && (btn.col == 1)) {
                    // make sure nothing points to the player
                    btn.direction = DirectionTypeEast;
                } else if ((btn.row == 1) && (btn.col == 0)) {
                    // make sure nothing points to the player
                    btn.direction = DirectionTypeSouth;
                } else {
                    // all other pieces are random
                    switch (arc4random_uniform(4)) {
                        case 1:
                            btn.direction = DirectionTypeNorth;
                            break;
                        case 2:
                            btn.direction = DirectionTypeSouth;
                            break;
                        case 3:
                            btn.direction = DirectionTypeEast;
                            break;
                        default:
                            btn.direction = DirectionTypeWest;
                            break;
                    }
                }
            } else {
                // use the reverse direction of our opposite
                Bacteria *opposite = [self bacteriaAtRow:10 - btn.row atCol:21 - btn.col];
                if (opposite) {
                    switch (opposite.direction) {
                        case DirectionTypeNorth:
                            btn.direction = DirectionTypeSouth;
                            break;
                        case DirectionTypeSouth:
                            btn.direction = DirectionTypeNorth;
                            break;
                        case DirectionTypeEast:
                            btn.direction = DirectionTypeWest;
                            break;
                        case DirectionTypeWest:
                            btn.direction = DirectionTypeEast;
                            break;
                        default:
                            break;
                    }
                }
            }
        }
        
        [self.grid addObject:[rowArray copy]];
    }
    
    self.grid[0][0].color = UIColor.greenColor;
    self.grid[10][21].color = UIColor.redColor;
    
    self.currentPlayer = UIColor.greenColor;
    
    self.lastSelected[UIColor.greenColor] = self.grid[0][0];
    self.lastSelected[UIColor.redColor] = self.grid[10][21];
}

- (NSArray<id<UIFocusEnvironment>> *)preferredFocusEnvironments {
    Bacteria *bacteria = self.lastSelected[self.currentPlayer];
    if (bacteria) {
        return @[bacteria];
    } else {
        return [super preferredFocusEnvironments];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.moveHighlight.backgroundColor = UIColor.clearColor;
    self.moveHighlight.layer.borderWidth = 12;
    self.moveHighlight.layer.borderColor = [[UIColor alloc] initWithRed:1 green:0.9 blue:0 alpha:1].CGColor;
    self.moveHighlight.alpha = 0;
    [self.view addSubview:self.moveHighlight];
    
    [UIView animateWithDuration:5
                          delay:0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationCurveLinear
                     animations:^{
        self.moveHighlight.transform = CGAffineTransformMakeRotation(M_PI);
    }
                     completion:nil];
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    Bacteria *next = (Bacteria *)context.nextFocusedView;
    if (next) {
        self.moveHighlight.center = next.center;
        self.moveHighlight.alpha = 1;
    } else {
        self.moveHighlight.alpha = 0;
    }
}

- (void)buttonTapped:(Bacteria *)sender {
    if (sender.color == self.currentPlayer) {
        [sender rotate];
//        [self changePlayer];
        [self infectFrom:sender];
    }
}

- (void)changePlayer {
    if (self.currentPlayer == UIColor.greenColor) {
        self.currentPlayer = UIColor.redColor;
    } else {
        self.currentPlayer = UIColor.greenColor;
    }
    [self setNeedsFocusUpdate];
}

- (Bacteria * _Nullable)bacteriaAtRow:(NSUInteger)row atCol:(NSUInteger)col {
    if (row < 0) return nil;
    if (row >= self.grid.count) return nil;
    if (col < 0) return nil;
    if (col >= self.grid[0].count) return nil;
    return self.grid[row][col];
}

- (void)infectFrom:(Bacteria *)from {
    // create an array of bacteria that might need to be infected
    NSMutableArray *bacteriaToInfect = [@[] mutableCopy];
    
    // find bacteria we point to direct infection
    switch (from.direction) {
        case DirectionTypeNorth: {
            Bacteria *bacteria = [self bacteriaAtRow:from.row - 1 atCol:from.col];
            [bacteriaToInfect addObject:(bacteria) ? bacteria : [NSNull null]];
            break;
        }
        case DirectionTypeSouth: {
            Bacteria *bacteria = [self bacteriaAtRow:from.row + 1 atCol:from.col];
            [bacteriaToInfect addObject:(bacteria) ? bacteria : [NSNull null]];
            break;
        }
        case DirectionTypeEast: {
            Bacteria *bacteria = [self bacteriaAtRow:from.row atCol:from.col + 1];
            [bacteriaToInfect addObject:(bacteria) ? bacteria : [NSNull null]];
            break;
        }
        case DirectionTypeWest: {
            Bacteria *bacteria = [self bacteriaAtRow:from.row atCol:from.col - 1];
            [bacteriaToInfect addObject:(bacteria) ? bacteria : [NSNull null]];
            break;
        }
        default:
            break;
    }
    
    // find bacteria that points to us
    // indirect infection from above
    Bacteria *aboveIndirect = [self bacteriaAtRow:from.row - 1 atCol:from.col];
    if (aboveIndirect) {
        if (aboveIndirect.direction == DirectionTypeSouth) {
            [bacteriaToInfect addObject:aboveIndirect];
        }
    }
    
    // indirect infection from below
    Bacteria *belowIndirect = [self bacteriaAtRow:from.row + 1 atCol:from.col];
    if (belowIndirect) {
        if (belowIndirect.direction == DirectionTypeNorth) {
            [bacteriaToInfect addObject:belowIndirect];
        }
    }
    
    // indirect infection from left
    Bacteria *leftIndirect = [self bacteriaAtRow:from.row atCol:from.col - 1];
    if (leftIndirect) {
        if (leftIndirect.direction == DirectionTypeEast) {
            [bacteriaToInfect addObject:leftIndirect];
        }
    }
    
    // indirect infection from right
    Bacteria *rightIndirect = [self bacteriaAtRow:from.row atCol:from.col + 1];
    if (rightIndirect) {
        if (rightIndirect.direction == DirectionTypeWest) {
            [bacteriaToInfect addObject:rightIndirect];
        }
    }
    
    //
    for (id bacteria in bacteriaToInfect) {
        if ([bacteria isKindOfClass:[Bacteria class]]) {
            Bacteria *_bacteria = (Bacteria *)bacteria;
            if (_bacteria.color != from.color) {
                self.bacteriaBeingInfected += 1;
                CGAffineTransform startTransform = _bacteria.transform;
                _bacteria.transform = CGAffineTransformScale(_bacteria.transform, 1.2, 1.2);
                
                [UIView animateWithDuration:0.1
                                 animations:^{
                    _bacteria.color = from.color;
                    _bacteria.transform = startTransform;
                }
                                 completion:^(BOOL finished) {
                    self.bacteriaBeingInfected -= 1;
                    [self infectFrom:_bacteria];
                }];
            }
        }
    }
    
    [self updateScores];
}

- (void)endGameMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game over"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Continue"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateScores {
    // 1: Create variables we can use to count player bacteria
    NSUInteger greenBacteria = 0;
    NSUInteger redBacteria = 0;
    
    // 2: Loop over every row and column, counting the player bacteria
    for (NSArray<Bacteria *> *row in self.grid) {
        for (Bacteria *col in row) {
            if (col.color == UIColor.greenColor) {
                greenBacteria += 1;
            } else if (col.color == UIColor.redColor) {
                redBacteria += 1;
            }
        }
    }
    
    // 3: Update the score labels
    self.greenScoreLabel.text = [NSString stringWithFormat:@"GREEN: %lu", greenBacteria];
    self.redScoreLabel.text = [NSString stringWithFormat:@"RED: %lu", redBacteria];
    
    // 4: Check if all infections have finished
    if (self.bacteriaBeingInfected == 0) {
        // 5: Either end the game or change player
        if (redBacteria == 0) {
            [self endGameMessage:@"Green wins!"];
        } else if (greenBacteria == 0) {
            [self endGameMessage:@"Red wins!"];
        } else {
            [self changePlayer];
        }
    }
}

@end
