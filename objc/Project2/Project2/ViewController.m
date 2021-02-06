//
//  ViewController.m
//  Project2
//
//  Created by Jinwoo Kim on 2/7/21.
//

#import "ViewController.h"

@implementation ViewController

- (void)setup {
    self.activeCells = [@[] mutableCopy];
    self.flashSequence = [@[] mutableCopy];
    self.levelCounter = 0;
    self.levels = @[
        @[@6, @7, @8], // 3 lights
        @[@1, @3, @11, @13], // 4
        @[@5, @6, @7, @8, @9], // 5
        @[@0, @4, @5, @9, @10, @14], // 6
        @[@1, @2, @3, @7, @11, @12, @13], // 7
        @[@0, @2, @4, @5, @9, @10, @12, @14], // 8
        @[@1, @2, @3, @6, @7, @8, @11, @12, @13], // 9
        @[@0, @1, @2, @3, @4, @10, @11, @12, @13, @14], // 10
        @[@1, @2, @3, @5, @6, @7, @8, @9, @11, @12, @13], // 11
        @[@0, @1, @3, @4, @5, @6, @8, @9, @10, @11, @13, @14], // 12
        @[@0, @1, @2, @3, @4, @6, @7, @8, @10, @11, @12, @13, @14], // 13
        @[@0, @1, @2, @3, @4, @5, @6, @8, @9, @10, @11, @12, @13, @14], // 14
        @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14], // 15
    ];
    self.flashSpeed = 0.25;
}

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createLevel {
    // 1
    if (self.levelCounter >= self.levels.count) return;
    self.result.alpha = 0;
    
    /*
     현재 선택된 cell(item = 0)이 hidden 처리가 될 경우 리모컨을 통한 이동이 불가능해진다. 따라서 아래와 같은 코드를 실행해주면 된다.
     [self setNeedsFocusUpdate];
     */
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setHidden:YES];
    }];
    [self.activeCells removeAllObjects];
    
    // 2
    for (NSNumber *item in self.levels[self.levelCounter]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[item unsignedIntegerValue] inSection:0];
        [self.activeCells addObject:indexPath];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        [cell setHidden:NO];
    }
    
    // 3
    [self.activeCells shuffle];
    self.flashSequence = [[self.activeCells subarrayWithRange:NSMakeRange(1, self.activeCells.count - 1)] mutableCopy];
    
    dispatch_time_t triggerTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(triggerTime, dispatch_get_main_queue(), ^{
        [self flashLight];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self createLevel];
}

- (void)flashLight {
    // try to remove an item from the flash sequence
    if (self.flashSequence.count > 0) {
        NSIndexPath *indexPath = self.flashSequence[0];
        [self.flashSequence removeObjectAtIndex:0];
        
        // pull out the light at that position
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell == nil) return;
        
        // find its image
        UIImageView *imageView = (UIImageView *)cell.contentView.subviews.firstObject;
        if (imageView == nil) return;
        
        // give it a green light
        imageView.image = [UIImage imageNamed:@"greenLight"];
        
        // make it slightly smaller
        cell.transform = CGAffineTransformMakeScale(0.95, 0.95);
        
        // start our animation
        [UIView animateWithDuration:self.flashSpeed
                         animations:^{
            // make it return to normal size
            cell.transform = CGAffineTransformIdentity;
        }
                         completion:^(BOOL finished) {
            // once the animation finishes make the light red again
            imageView.image = [UIImage imageNamed:@"redLight"];
            
            // wait a tiny amount of time
            dispatch_time_t triggerTime = dispatch_time(DISPATCH_TIME_NOW, self.flashSpeed * NSEC_PER_SEC);
            dispatch_after(triggerTime, dispatch_get_main_queue(), ^{
                // call ourselves again
                [self flashLight];
            });
        }];
    } else {
        // player need to guess
        dispatch_time_t triggerTime = dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC);
        dispatch_after(triggerTime, dispatch_get_main_queue(), ^{
            // call ourselves again
            [self.view setUserInteractionEnabled:YES];
            [self setNeedsFocusUpdate];
        });
    }
}

- (void)gameOver {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game over!"
                                                                   message:[NSString stringWithFormat:@"You made it to level %lu", self.levelCounter]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Start Again"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
        self.levelCounter += 1;
        [self createLevel];
    }];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 1: disable user interaction on our view
    [self.view setUserInteractionEnabled:NO];
    
    // 2: make the result image appear
    self.result.alpha = 1;
    
    // 3: if the user chose the correct answer
    if (indexPath == self.activeCells[0]) {
        // 4: make result show the "correct" image, add 1 to levelCounter, then call createLevel
        self.result.image = [UIImage imageNamed:@"correct"];
        self.levelCounter += 1;
        
        dispatch_time_t triggerTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(triggerTime, dispatch_get_main_queue(), ^{
            [self createLevel];
        });
    } else {
        // 5: otherwise the user chose wrongly, so show the "wrong" image then call gameOver
        self.result.image = [UIImage imageNamed:@"wrong"];
        
        dispatch_time_t triggerTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
        dispatch_after(triggerTime, dispatch_get_main_queue(), ^{
            [self gameOver];
        });
    }
}

@end
