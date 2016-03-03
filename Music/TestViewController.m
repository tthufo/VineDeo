//
//  TestViewController.m
//  Music
//
//  Created by thanhhaitran on 12/10/15.
//  Copyright © 2015 thanhhaitran. All rights reserved.
//

#import "TestViewController.h"

#import "YoutubeChildViewController.h"

#import "XCDYouTubeVideoPlayerViewController.h"


@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    XCDYouTubeVideoPlayerViewController * tube = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:self.identifiy] ;
        
    [tube.moviePlayer play];
    
    tube.view.frame = CGRectMake(0, 100, screenWidth, 500);
    
    [self.view addSubview:tube.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
