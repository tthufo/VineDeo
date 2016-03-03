//
//  M_Fourth_ViewController.m
//  VineDeo
//
//  Created by thanhhaitran on 3/1/16.
//  Copyright © 2016 thanhhaitran. All rights reserved.
//

#import "M_Fourth_ViewController.h"

@interface M_Fourth_ViewController ()
{
    IBOutlet UITableView * tableView;
    
    NSMutableArray * dataList;
}

@end

@implementation M_Fourth_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataList = [@[@"Tell your friend!",@"Rate App",@"More Apps"] mutableCopy];
    
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
    [self didShowAdsBanner];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"detailCell"];

    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailCell"];
    }

    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(10, 43.5, screenWidth, 0.5)];
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    [cell addSubview:line];
    
    cell.textLabel.text = dataList[indexPath.row];
    
    cell.textLabel.textColor = [AVHexColor colorWithHexString:kColor];
    
    return cell;
}

- (void)didPressShare:(UIButton*)sender
{
    int indexing = [self inDexOf:sender andTable:tableView];

    NSString * url = [NSString stringWithFormat: @"https://www.youtube.com/watch?v=%@",dataList[indexing][@"snippet"][@"resourceId"][@"videoId"]];

    [[FB shareInstance] startShareWithInfo:@[@"Check out this ASMR videos",url] andBase:sender andRoot:self andCompletion:^(NSString *responseString, id object, int errorCode, NSString *description, NSError *error) {

    }];
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row)
    {
        case 0:
        {
            [[FB shareInstance] startShareWithInfo:@[@"Check out this cool app! Lots of free Vine and more.",[UIImage imageNamed:@"Icon-76"]] andBase:nil andRoot:self andCompletion:^(NSString *responseString, id object, int errorCode, NSString *description, NSError *error) {
                
            }];
        }
            break;
        case 1:
        {
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/vinedeo-for-youtube/id1089181113?ls=1&mt=8"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/vinedeo-for-youtube/id1089181113?ls=1&mt=8"]];
            }
        }
            break;
        case 2:
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"https://itunes.apple.com/us/developer/thanh-hai-tran/id1073174100"]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/developer/thanh-hai-tran/id1073174100"]];
            }
            break;

        default:
            break;
    }
}

- (void)didShowAdsBanner
{
    if([[self infoPlist][@"showAds"] boolValue])
    {
        if([[self getObject:@"adsInfo"][@"adsMob"] boolValue] && [self getObject:@"adsInfo"][@"banner"])
        {
            [[Ads sharedInstance] G_didShowBannerAdsWithInfor:@{@"host":self,@"X":@(screenWidth),@"Y":@(screenHeight - (SYSTEM_VERSION_LESS_THAN(@"7") ? 164 : 164)),@"adsId":[self getObject:@"adsInfo"][@"banner"]/*,@"device":@""*/} andCompletion:^(BannerEvent event, NSError *error, id banner) {
                
                switch (event)
                {
                    case AdsDone:
                        break;
                    case AdsFailed:
                        break;
                    default:
                        break;
                }
            }];
        }
    }
    if([[self infoPlist][@"showAds"] boolValue])
    {
        if(![[self getObject:@"adsInfo"][@"adsMob"] boolValue])
        {
            [[Ads sharedInstance] S_didShowBannerAdsWithInfor:@{@"host":self,@"Y":@(screenHeight - (SYSTEM_VERSION_LESS_THAN(@"7") ? 164 : 100))} andCompletion:^(BannerEvent event, NSError *error, id bannerAd) {
                switch (event)
                {
                    case AdsDone:
                    {
                        
                    }
                        break;
                    case AdsFailed:
                    {
                        NSLog(@"%@",error);
                    }
                        break;
                    case AdsWillPresent:
                    {
                        
                    }
                        break;
                    case AdsWillLeave:
                    {
                        
                    }
                        break;
                    default:
                        break;
                }
            }];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
