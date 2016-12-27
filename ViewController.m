//
//  ViewController.m
//  LoginApp
//
//  Created by Spandana Nayakanti on 12/17/16.
//  Copyright © 2016 Spandana. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnActn:(id)sender {
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];

    BOOL lowerCaseLetter = false,upperCaseLetter = false,digit = false;
    if([_passwordTxtField.text length] >= 7)
    {
        for (int i = 0; i < [_passwordTxtField.text length]; i++)
        {
            unichar c = [_passwordTxtField.text characterAtIndex:i];
            if(!lowerCaseLetter)
            {
                lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!upperCaseLetter)
            {
                upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
            }
            if(!digit)
            {
                digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
            }
        }
        
        if( digit && lowerCaseLetter && upperCaseLetter && [emailTest evaluateWithObject:_userNameTxtField.text] == YES)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DetailViewController *detailVC = (DetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DetailView"];
            [self.navigationController pushViewController:detailVC animated:YES];

        }
        else if([emailTest evaluateWithObject:_userNameTxtField.text] == NO)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please Enter valid email id"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }
    if (!digit && !lowerCaseLetter && !upperCaseLetter) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please Ensure that you have at least one lower case letter, one upper case letter, one digit"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

    
}
@end
