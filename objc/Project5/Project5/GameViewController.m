//
//  GameViewController.m
//  Project5
//
//  Created by Jinwoo Kim on 2/11/21.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)setup {
    self.cells = [@{} mutableCopy];
    self.numCorrect = 0;
    self.first = nil;
    self.second = nil;
}

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
    
    NSURL *wordsPath = [NSBundle.mainBundle URLForResource:self.wordType withExtension:@"json"];
    if (wordsPath == nil) return;
    NSData *contents = [NSData dataWithContentsOfURL:wordsPath];
    if (contents == nil) return;
    self.words = [NSJSONSerialization JSONObjectWithData:contents options:0 error:nil];
    if (self.words == nil) return;
    
    // 1: Create an array the numbers 0 through 17
    NSMutableArray<NSNumber *> *cellNumbers = [@[] mutableCopy];
    for (NSUInteger i = 0; i < 18; i++) {
        [cellNumbers addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    
    // 2: Shuffle the array
    [cellNumbers shuffle];
    
    // 3: Loop from 0 through 8, which is the number of cells we have devided by 2
    for (NSUInteger i = 0; i < 9; i++) {
        // 4: Remove two numbers: one for the picture and one for the word
        NSUInteger pictureNumber = [(NSNumber *)[cellNumbers removeLast] unsignedIntegerValue];
        NSUInteger wordNumber = [(NSNumber *)[cellNumbers removeLast] unsignedIntegerValue];
        
        // 5: Create index paths from those numbers and cells from the index paths
        NSIndexPath *pictureIndexPath = [NSIndexPath indexPathForItem:pictureNumber inSection:0];
        NSIndexPath *wordIndexPath = [NSIndexPath indexPathForItem:wordNumber inSection:0];
        
        CardCell *wordCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:wordIndexPath];
        if (wordCell == nil) return;
        CardCell *pictureCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:pictureIndexPath];
        if (pictureCell == nil) return;
        
        // 6: Tell the first cell its work, and give it the correct foreign language word for its label
        wordCell.word = self.words[i][@"english"];
        wordCell.textLabel.text = self.words[i][self.targetLanguage];
        
        // 7: Tell the second cell the same word, but this time give it the correct image
        pictureCell.word = wordCell.word;
        pictureCell.contents.image = [UIImage imageNamed:pictureCell.word];
        
        // 8: Store both cells in our dictionary so we can use them later
        self.cells[[NSNumber numberWithUnsignedInteger:pictureNumber]] = pictureCell;
        self.cells[[NSNumber numberWithUnsignedInteger:wordNumber]] = wordCell;
    }
}

- (void)checkAnswer {
    // 1: Make sure both first and second are set
    CardCell *firstCard = self.first;
    CardCell *secondCard = self.second;
    if ((firstCard == nil) || (secondCard == nil)) return;
    
    // 2: Check the word property of both card matches
    if ([firstCard.word isEqualToString:secondCard.word]) {
        // 3: Clear the word property of both cards so the player can't them again
        firstCard.word = @"";
        secondCard.word = @"";
        
        // 4: Make both cards flash yellow
        firstCard.card.image = [UIImage imageNamed:@"cardFrontHighlighted"];
        secondCard.card.image = [UIImage imageNamed:@"cardFrontHighlighted"];
        
        // 5: Wait 0.1 seconds then make both cards animate to a green image
        dispatch_time_t triggerTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
        dispatch_after(triggerTime, dispatch_get_main_queue(), ^{
            [UIView transitionWithView:firstCard.card
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                firstCard.card.image = [UIImage imageNamed:@"cardFrontCorrect"];
            }
                            completion:nil];
            
            [UIView transitionWithView:secondCard.card
                              duration:0.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                secondCard.card.image = [UIImage imageNamed:@"cardFrontCorrect"];
            }
                            completion:nil];
            
            // 6: Add 1 to their score. and check if we need to. end the game
            self.numCorrect += 1;
            
            if (self.numCorrect == 9) [self gameOver];
        });
    } else {
        // 7: The two cards don't match - flip them back
        [firstCard flipTo:@"cardBack" hideContents:YES];
        [secondCard flipTo:@"cardBack" hideContents:YES];
    }
    
    // clear first and second
    self.first = nil;
    self.second = nil;
    [self.view setUserInteractionEnabled:YES];
}

- (void)gameOver {
    // create a new image view and add it, but make it hidden
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youWin"]];
    imageView.center = self.view.center;
    imageView.alpha = 0;
    imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    [self.view addSubview:imageView];
    
    // use a spring animation to show the image view
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:1
                        options:0
                     animations:^{
        imageView.alpha = 1;
        imageView.transform = CGAffineTransformIdentity;
    }
                     completion:nil];
    
    // go back to the menu after two seconds
    dispatch_time_t triggerTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(triggerTime, dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

//

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 18;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return self.cells[[NSNumber numberWithUnsignedInteger:indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCell *cell = (CardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil) return;
    
    if (self.first == nil) {
        // they flipped their first card
        self.first = cell;
    } else if ((self.second == nil) && (cell != self.first)) {
        // they flipped their second card
        self.second = cell;
        
        // stop them from flipping more cards
        [self.view setUserInteractionEnabled:NO];
        
        // wait a little, then check their answer
        dispatch_time_t triggerTime = dispatch_time(DISPATCH_TIME_NOW, 0.75 * NSEC_PER_SEC);
        dispatch_after(triggerTime, dispatch_get_main_queue(), ^{
            [self checkAnswer];
        });
    } else {
        // they are trying to flip a third card - exit!
        return;
    }
    
    // perform the frlip transition
    [cell flipTo:@"cardFrontNormal" hideContents:NO];
}

// Focus 됐을 때 커지는 효과를 System 기본 대신, 1.2배로 설정할 수 있다.
- (void)collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    [coordinator addCoordinatedAnimations:^{
        UIView *previous = context.previouslyFocusedView;
        if (previous) previous.transform = CGAffineTransformIdentity;
        
        UIView *next = context.nextFocusedView;
        if (next) next.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }
                               completion:nil];
}

// 이미 정답을 맞췄으면 선택 안 되게
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCell *cell = (CardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil) return NO;
    return ![cell.word isEqualToString:@""];
}

@end
