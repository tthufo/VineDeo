//
//  M_RootViewController.m
//  Music
//
//  Created by thanhhaitran on 1/6/16.
//  Copyright © 2016 thanhhaitran. All rights reserved.
//

#import "M_RootViewController.h"

#import "M_First_ViewController.h"

#import "M_Second_ViewController.h"

#import "M_Third_ViewController.h"

#import "M_Fourth_ViewController.h"

@interface M_RootViewController ()

@end

@implementation M_RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTabBar];
}

- (void)initTabBar
{
    M_First_ViewController * first = [M_First_ViewController new];
    UINavigationController *nav1 = [[UINavigationController alloc]
                                             initWithRootViewController:first];
    nav1.tabBarItem.image = [UIImage imageNamed:@"channel"];

    M_Second_ViewController * second = [M_Second_ViewController new];
    second.title = @"Favourites";
    UINavigationController *nav2 = [[UINavigationController alloc]
                                             initWithRootViewController:second];
    nav2.tabBarItem.image = [UIImage imageNamed:@"favs"];

    M_Third_ViewController * third = [M_Third_ViewController new];
    third.title = @"Search";
    UINavigationController *nav3 = [[UINavigationController alloc]
                                    initWithRootViewController:third];
    nav3.tabBarItem.image = [UIImage imageNamed:@"search"];
    
    M_Fourth_ViewController * fourth = [M_Fourth_ViewController new];
    fourth.title = @"More";
    UINavigationController *nav4 = [[UINavigationController alloc]
                                    initWithRootViewController:fourth];
    nav4.tabBarItem.image = [UIImage imageNamed:@"more"];
    
    self.viewControllers = @[nav1, nav2, nav3, nav4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
