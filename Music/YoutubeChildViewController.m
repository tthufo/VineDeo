//
//  YoutubeChildViewController.m
//  Music
//
//  Created by thanhhaitran on 11/29/15.
//  Copyright © 2015 thanhhaitran. All rights reserved.
//

#import "YoutubeChildViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface YoutubeChildViewController ()<UIGestureRecognizerDelegate>
{
    NSTimer * timer;
    UIButton * button;
}

@end

@implementation YoutubeChildViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
    [[AVAudioSession sharedInstance] setActive: YES error: &activationErr];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.delegate playerDidFinish:@{}];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl)
    {
        if (event.subtype == UIEventSubtypeRemoteControlPlay)
        {

        }
        else if (event.subtype == UIEventSubtypeRemoteControlPause)
        {

        }
        else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause)
        {

        }
        else if (event.subtype == UIEventSubtypeRemoteControlNextTrack)
        {

        }
        else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack)
        {

        }
    }
}

- (void)MPMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayer = notification.object;
//    MPMoviePlaybackState playbackState = moviePlayer.e;
    
    
    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
//        [self didStartTimer:YES];
//        [self hideSVHUD];
    }
    if (self.moviePlayer.playbackState == MPMoviePlaybackStateStopped)
    {
//        [self hideSVHUD];
    }
    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePaused)
    {
//        [self hideSVHUD];
    }
    if (self.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted)
    {
//        [self hideSVHUD];
    }
    if (self.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward)
    {
        
    }
    if (self.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward)
    {
        
    }
}

//- (void)didPressSelf:(UITapGestureRecognizer*)gesture
//{
//    BOOL isViewing = [self interfaceViewWithPlayer:(MPMoviePlayerController*)self];
//    [button fadeView:isViewing ? 0.6 : 0 andOr:isViewing];
//    if(isViewing)
//    {
//        [self didStartTimer:isViewing];
//    }
//}
//
//- (void)doDoubleTap:(UITapGestureRecognizer*)gesture
//{
////    BOOL isViewing = [self interfaceViewWithPlayer:(MPMoviePlayerController*)self];
////    [button fadeView:0.5 andOr:isViewing];
////    [self didStartTimer:!isViewing];
//}
//
//- (BOOL)interfaceViewWithPlayer:(MPMoviePlayerController *)player
//{
//    for (UIView *views in [player.view subviews])
//    {
//        for (UIView *subViews in [views subviews])
//        {
//            for (UIView *controlView in [subViews subviews])
//            {
//                if ([controlView isKindOfClass:NSClassFromString(@"MPVideoPlaybackOverlayView")])
//                {
//                    return controlView.isHidden;
//                }
//            }
//        }
//    }
//    return NO;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognize
//{
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
