//
//  ViewController.h
//  Project3
//
//  Created by Jinwoo Kim on 2/8/21.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *textFieldTip;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property UIFocusGuide *focusGuide;
@end
