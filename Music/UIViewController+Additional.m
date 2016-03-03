//
//  UIViewController+Additional.m
//  Music
//
//  Created by thanhhaitran on 1/5/16.
//  Copyright © 2016 thanhhaitran. All rights reserved.
//

#import "UIViewController+Additional.h"

@implementation UIViewController (Additional)

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    /*
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[AVHexColor colorWithHexString:@"#FFFFFF"]}];
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7)
    {
        {
            self.navigationController.navigationBar.barTintColor = [AVHexColor colorWithHexString:kColor];
            self.navigationController.navigationBar.translucent = NO;
        }
    }
    else
    {
        {
            self.navigationController.navigationBar.tintColor = [AVHexColor colorWithHexString:kColor];
        }
    }
     */
}

- (void)registerForKeyboardNotifications:(BOOL)isRegister andSelector:(NSArray*)selectors
{
    if(isRegister)
    {
        [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:NSSelectorFromString(selectors[0]) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addUniqueObserver:self selector:NSSelectorFromString(selectors[1]) name:UIKeyboardWillHideNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    }
}

@end
