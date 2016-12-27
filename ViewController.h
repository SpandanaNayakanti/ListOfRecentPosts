//
//  ViewController.h
//  LoginApp
//
//  Created by Spandana Nayakanti on 12/17/16.
//  Copyright © 2016 Spandana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *userNameTxtField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxtField;
- (IBAction)loginBtnActn:(id)sender;

@end

