//
//  ImageViewController.m
//  Project1
//
//  Created by Jinwoo Kim on 2/6/21.
//

#import "ImageViewController.h"

@implementation ImageViewController

- (void)setup {
    self.imageCounter = 0;
}

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
    
    NSMutableArray<UIImageView *> *imageViews = [@[] mutableCopy];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [imageViews addObject:obj];
        }
    }];
    self.imageViews = imageViews;
    
    [self.imageViews enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.alpha = 0;
    }];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.unsplash.com/search/photos?client_id=%@&query=%@&per_page=100", key, self.catetory]];
    if (url == nil) return;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        [self fetchURL:url];
    });
}

- (void)fetchURL:(NSURL *)url {
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data == nil) return;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    if (dic == nil) return;
    self.images = dic[@"results"];
    if (self.images == nil) return;
    [self downloadImage];
}

- (void)downloadImage {
    // figure out what image to display
    NSDictionary *currentImage = self.images[self.imageCounter % self.images.count];
    if (currentImage == nil) return;
    
    // find its image URL and user credit
    NSString *imageName = currentImage[@"urls"][@"full"];
    NSString *imageCredit = currentImage[@"user"][@"name"];
    if ((imageName == nil) || (imageCredit == nil)) return;
    
    // add 1 to imageCounter so next time we load the following image
    self.imageCounter += 1;
    
    // convert it to a NSURL and download it
    NSURL *imageURL = [NSURL URLWithString:imageName];
    if (imageURL == nil) return;
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    if (imageData == nil) return;
    
    // convert the Data to a UIImage
    UIImage *image = [UIImage imageWithData:imageData];
    if (image == nil) return;
    
    // push our work to the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showImage:image credit:imageCredit];
    });
}

- (void)showImage:(UIImage *)image credit:(NSString *)credit {
    // stop the activity indicator animation
    [self.spinner stopAnimating];
    
    // figure out which image view to activate and deactivate
    UIImageView *imageViewToUse = self.imageViews[self.imageCounter % self.imageViews.count];
    UIImageView *otherImageView = self.imageViews[(self.imageCounter + 1) % self.imageViews.count];
    
    // start an animation over two seconds
    [UIView animateWithDuration:2.0 animations:^{
        // make the image view use our image, and alpha it up to 1
        imageViewToUse.image = image;
        imageViewToUse.alpha = 1;
        
        // fade out the credit label to avoid it looking wrong
        self.creditLabel.alpha = 0;
        
        // move the deactivated image view to the back, behind the activated one
        [self.view sendSubviewToBack:otherImageView];
    } completion:^(BOOL finished) {
        // crossfade finished
        self.creditLabel.text = [NSString stringWithFormat:@" %@", [credit uppercaseString]];
        self.creditLabel.alpha = 1;
        otherImageView.alpha = 0;
        otherImageView.transform = CGAffineTransformIdentity;
        
        [UIView animateWithDuration:10.0 animations:^{
            imageViewToUse.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self downloadImage];
            });
        }];
    }];
}

@end
