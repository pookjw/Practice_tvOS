//
//  ReaderViewController.m
//  Project4
//
//  Created by Jinwoo Kim on 2/9/21.
//

#import "ReaderViewController.h"

@implementation ReaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.article == nil) return;
    
    NSURL *url = [NSURL URLWithString:(NSString *)self.article[@"fields"][@"thumbnail"]];
    if (url == nil) return;
    
    [self.imageView loadURL:url];
    self.imageView.layer.borderColor = UIColor.darkGrayColor.CGColor;
    self.imageView.layer.borderWidth = 2;
    self.imageView.layer.cornerRadius = 20;
    
    self.headline.text = self.article[@"fields"][@"headline"];
    self.body.linkTextAttributes = @{NSForegroundColorAttributeName: UIColor.blackColor};
    NSString *articleBody = self.article[@"fields"][@"body"];
    NSString *formattedArticleBody = [self formatHTML:articleBody];
    NSData *articleBodyData = [formattedArticleBody dataUsingEncoding:NSUTF8StringEncoding];
    if (articleBodyData == nil) return;
    
    NSError * _Nullable error;
    NSAttributedString *bodyText = [[NSAttributedString alloc] initWithData:articleBodyData
                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                         documentAttributes:nil
                                                                      error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return;
    }
    
    if (bodyText == nil) return;
    self.body.attributedText = bodyText;
    
    //
    
    /*
     UITouchTypeIndirect : 트랙패드, 애플티비 리모컨
     UITouchTypeDirect : 직접 터치
     UITouchTypePencil : 애플펜슬 지원
     */
    self.body.panGestureRecognizer.allowedTouchTypes = @[[NSNumber numberWithUnsignedInteger:UITouchTypeIndirect]];
    [self.body setSelectable:YES];
}

- (NSString *)formatHTML:(NSString *)html {
    NSURL *wrapperURL = [NSBundle.mainBundle URLForResource:@"wrapper" withExtension:@"html"];
    if (wrapperURL == nil) return html;
    
    NSError * _Nullable error;
    NSString *wrapper = [NSString stringWithContentsOfURL:wrapperURL encoding:NSUTF8StringEncoding error:nil];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return html;
    }
    if (wrapper == nil) return html;
    
    return [wrapper stringByReplacingOccurrencesOfString:@"%@" withString:html];
}

@end
