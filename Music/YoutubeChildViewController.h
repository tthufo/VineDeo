//
//  YoutubeChildViewController.h
//  Music
//
//  Created by thanhhaitran on 11/29/15.
//  Copyright © 2015 thanhhaitran. All rights reserved.
//

#import <XCDYouTubeKit/XCDYouTubeKit.h>

@protocol PlayerDelegate <NSObject>

- (void)playerDidFinish:(NSDictionary*)dict;

@end

@interface YoutubeChildViewController : XCDYouTubeVideoPlayerViewController

@property (nonatomic, assign) id <PlayerDelegate> delegate;

@end
