//
//  M_Third_ViewController.m
//  ASMR
//
//  Created by thanhhaitran on 2/7/16.
//  Copyright © 2016 thanhhaitran. All rights reserved.
//

#import "M_Third_ViewController.h"

#import "YoutubeChildViewController.h"

@interface M_Third_ViewController ()<PlayerDelegate>
{
    IBOutlet UICollectionView * collectionView;
    
    NSMutableArray * dataList;
    
    NSString * nextPage;
    
    int totalResult;
    
    BOOL isLoadMore, isSearchMode;
    
    IBOutlet UISearchBar * searchBar;
}
@end

@implementation M_Third_ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    nextPage = @"";
    
    __block M_Third_ViewController * weakSelf  = self;
    
    [collectionView addFooterWithBlock:^{
        
        [weakSelf didLoadMore];
        
    } withIndicatorColor:[UIColor grayColor]];
    
    dataList = [NSMutableArray new];
    
    if(SYSTEM_VERSION_LESS_THAN(@"7"))
    {
        [searchBar setTintColor:[AVHexColor colorWithHexString:kColor]];
    }
    else
    {
        for (id object in [[[searchBar subviews] firstObject] subviews])
        {
            if (object && [object isKindOfClass:[UITextField class]])
            {
                UITextField *textFieldObject = (UITextField *)object;
                textFieldObject.borderStyle = UITextBorderStyleNone;
                textFieldObject.textColor = [UIColor whiteColor];
                [textFieldObject withBorder:@{@"Bcorner":@(3),@"Bground":[AVHexColor colorWithHexString:kColor]}];
                [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
                [textFieldObject setClearButtonMode:UITextFieldViewModeNever];
                UIImageView *leftImageView = (UIImageView *)textFieldObject.leftView;
                leftImageView.image = [leftImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [leftImageView setTintColor:[UIColor whiteColor]];
                break;
            }
        }
        [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    }
    
    [collectionView registerNib:[UINib nibWithNibName:@"EM_Cells" bundle:nil] forCellWithReuseIdentifier:@"imageCell"];
    
    if(SYSTEM_VERSION_GREATER_THAN(@"7"))
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        
        collectionView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    }
    
    //searchBar.frame = CGRectMake(0, SYSTEM_VERSION_LESS_THAN(@"7") ? 2 : 2, screenWidth - 34, 35);
    
    [self.view addSubview:searchBar];
    
    [self didShowAdsBanner];
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
                        collectionView.contentInset = UIEdgeInsetsMake(SYSTEM_VERSION_LESS_THAN(@"7") ? 0 : 64, 0, SYSTEM_VERSION_LESS_THAN(@"7") ? 50 : 100, 0);
                        break;
                    case AdsFailed:
//                        collectionView.contentInset = UIEdgeInsetsMake(SYSTEM_VERSION_LESS_THAN(@"7") ? 0 : 64, 0, SYSTEM_VERSION_LESS_THAN(@"7") ? 50 : 100, 0);
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
                        collectionView.contentInset = UIEdgeInsetsMake(SYSTEM_VERSION_LESS_THAN(@"7") ? 0 : 64, 0, SYSTEM_VERSION_LESS_THAN(@"7") ? 50 : 100, 0);
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


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didLoadMore
{
    isLoadMore = YES;
    
    [self didRequestData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
    isLoadMore = NO;
    
    nextPage = @"";
    
    [self didRequestData];
}

- (void)playerDidFinish:(NSDictionary*)dict
{
    if(![self getValue:@"search"])
    {
        [self addValue:@"1" andKey:@"search"];
    }
    else
    {
        int count = [[self getValue:@"search"] intValue] + 1 ;
        
        [self addValue:[NSString stringWithFormat:@"%i", count] andKey:@"search"];
    }
    
    if([[self getValue:@"search"] intValue] % 3 == 0)
    {
        [self performSelector:@selector(presentAds) withObject:nil afterDelay:2];
    }
}

- (void)presentAds
{
    if([[self infoPlist][@"showAds"] boolValue])
    {
        if(![[self getObject:@"adsInfo"][@"adsMob"] boolValue])
        {
            [[Ads sharedInstance] S_didShowFullAdsWithInfor:@{} andCompletion:^(BannerEvent event, NSError *error, id bannerAd) {
                switch (event)
                {
                    case AdsDone:
                    {
                        
                    }
                        break;
                    case AdsFailed:
                    {
                        
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
        else
        {
            if([self getObject:@"adsInfo"][@"fullBanner"])
            {
                [[Ads sharedInstance] G_didShowFullAdsWithInfor:@{@"host":self,@"adsId":[self getObject:@"adsInfo"][@"fullBanner"]/*,@"device":@""*/} andCompletion:^(BannerEvent event, NSError *error, id banner) {
                    
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
    }
}


- (void)didRequestData
{
    if(searchBar.text.length == 0)
    {
        [collectionView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:0.5];

        return;
    }
    NSString * url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@|vine -music&type=video&maxResults=25&key=AIzaSyB9IuIAwAJQhhSOQY3rn4bc9A2EjpdG_7c",searchBar.text];
    
    if(nextPage.length != 0)
    {
        url = [NSString stringWithFormat:@"%@&pageToken=%@",url,nextPage];
    }
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[url stringByAddingPercentEscapesUsingEncoding:
    NSUTF8StringEncoding],@"method":@"GET",@"host":self,@"overrideLoading":@(1),@"overrideError":@(1)} withCache:^(NSString *cacheString) {
    } andCompletion:^(NSString *responseString, NSError *error, BOOL isValidated) {
        
        [collectionView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:0.5];
        
        if(isValidated)
        {
            NSDictionary * dict = [responseString objectFromJSONString];
            
            nextPage = dict[@"nextPageToken"];
            
            if(dataList.count >= [dict[@"pageInfo"][@"totalResults"] intValue])
            {
                return ;
            }
            
            if(!isLoadMore)
            
                [dataList removeAllObjects];
            
            [dataList addObjectsFromArray:dict[@"items"]];
            
            NSMutableArray * arr = [NSMutableArray new];
            
            for(NSDictionary * dict in dataList)
            {
                if([dict[@"snippet"][@"title"] isEqualToString:@"Private video"])
                {
                    [arr addObject:dict];
                }
            }
            
            [dataList removeObjectsInArray:arr];
            
            [collectionView reloadData];
            
            if(!isLoadMore)
            
                [collectionView setContentOffset:CGPointMake(0, SYSTEM_VERSION_LESS_THAN(@"7") ? 0 : 0) animated:YES];
        }
        
    }];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 50;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return searchBar;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return dataList.count == 0 ? 1 : dataList.count ;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return dataList.count == 0 ? 44 : 134;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(dataList.count == 0)
//    {
//        return [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil][4];
//    }
//    
//    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"detailCell"];
//    
//    if(!cell)
//    {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil][2];
//    }
//    
//    NSDictionary * dict = dataList[indexPath.row];
//    
//    [((UIImageView*)[self withView:cell tag:11]) sd_setImageWithURL:[NSURL URLWithString:dict[@"snippet"][@"thumbnails"][@"default"][@"url"]] placeholderImage:kAvatar completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//    }];
//    
//    ((UILabel*)[self withView:cell tag:12]).text = dict[@"snippet"][@"title"];
//    
//    ((UILabel*)[self withView:cell tag:14]).text = dict[@"snippet"][@"description"];
//    
//    [((UIView*)[self withView:cell tag:8899]) withShadow:[AVHexColor colorWithHexString:@"#F7F7F7"]];
//    
//    [((UIButton*)[self withView:cell tag:696]) addTapTarget:self action:@selector(didPressShare:)];
//    
//    [((UIButton*)[self withView:cell tag:696]) setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
//    
//    [((UIButton*)[self withView:cell tag:697]) addTapTarget:self action:@selector(didPressFavorite:)];
//    
//    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dataList[indexPath.row][@"snippet"][@"title"],dataList[indexPath.row][@"id"][@"videoId"]];
//    
//    NSArray * data = [System getFormat:@"key=%@" argument:@[videoId]];
//    
//    [((UIButton*)[self withView:cell tag:697]) setImage:[UIImage imageNamed:data.count == 0 ? @"add" : @"remove"] forState:UIControlStateNormal];
//    
//    ((UIButton*)[self withView:cell tag:697]).alpha = data.count == 0 ? 1 : 0.3;
//    
//    return cell;
//}
//
//- (void)didPressShare:(UIButton*)sender
//{
//    int indexing = [self inDexOf:sender andTable:tableView];
//    
//    NSString * url = [NSString stringWithFormat: @"https://www.youtube.com/watch?v=%@",dataList[indexing][@"id"][@"videoId"]];
//    
//    [[FB shareInstance] startShareWithInfo:@[@"Check out this ASMR video",url] andBase:sender andRoot:self andCompletion:^(NSString *responseString, id object, int errorCode, NSString *description, NSError *error) {
//                
//    }];
//}

- (void)didPressFavorite:(UIButton*)sender
{
    int indexing = [self inDexOf:sender andCollection:collectionView];
    
    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dataList[indexing][@"snippet"][@"title"],dataList[indexing][@"id"][@"videoId"]];
    
    NSArray * data = [System getFormat:@"key=%@" argument:@[videoId]];
    
    if(data.count > 0)
    {
        [System removeValue:videoId];
    }
    else
    {
        [System addValue:dataList[indexing] andKey:videoId];
    }
    
    [collectionView reloadData];
}

//- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    [self.view endEditing:YES];
//        
//    YoutubeChildViewController *videoPlayerViewController = [[YoutubeChildViewController alloc] initWithVideoIdentifier:dataList[indexPath.row][@"id"][@"videoId"]];
//    
//    videoPlayerViewController.delegate = self;
//    
//    [self presentViewController:videoPlayerViewController animated:YES completion:nil];
//}

#pragma CollectionView

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return dataList.count ;//== 0 ? 1 : dataList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
//    if(dataList.count == 0)
//    {
//        ((UIImageView*)[self withView:cell tag:11]).hidden = YES;
//        
//        ((UILabel*)[self withView:cell tag:12]).hidden = YES;
//        
//        ((UIButton*)[self withView:cell tag:14]).hidden = YES;
//        
//        ((UIImageView*)[self withView:cell tag:16]).hidden = YES;
//        
//        ((UILabel*)[self withView:cell tag:18]).text = @"Search result empty";
//        
//        return cell;
//    }
//    else
    {
        NSDictionary * dict = dataList[indexPath.row];
        
        [((UIImageView*)[self withView:cell tag:11]) sd_setImageWithURL:[NSURL URLWithString:dict[@"snippet"][@"thumbnails"][@"default"][@"url"]] placeholderImage:kAvatar completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error) return;
            if (image && cacheType == SDImageCacheTypeNone)
            {
                [UIView transitionWithView:((UIImageView*)[self withView:cell tag:11])
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    [((UIImageView*)[self withView:cell tag:11]) setImage:image];
                                } completion:NULL];
            }
        }];
        
        ((UILabel*)[self withView:cell tag:12]).text = [[dict[@"snippet"][@"publishedAt"] dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"] dateTimeAgo];
        
        [(UIImageView*)[self withView:cell tag:11] withBorder:@{@"Bwidth":@(2),@"Bcolor":[AVHexColor colorWithHexString:kColor]}];
        
        [((UIButton*)[self withView:cell tag:14]) addTapTarget:self action:@selector(didPressFavorite:)];
        
        NSString * videoId = [NSString stringWithFormat:@"%@+%@", dataList[indexPath.row][@"snippet"][@"title"],dataList[indexPath.row][@"id"][@"videoId"]];

        NSArray * data = [System getFormat:@"key=%@" argument:@[videoId]];
        
        [((UIButton*)[self withView:cell tag:14]) setImage:[UIImage imageNamed:data.count == 0 ? @"add" : @"remove"] forState:UIControlStateNormal];
            
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return /*dataList.count == 0 ? CGSizeMake(screenWidth, screenWidth) : */ CGSizeMake(screenWidth / 2 - 4.0, screenWidth / 2 - 4.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (void)collectionView:(UICollectionView *)_collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];

    if(dataList.count == 0) return;
    
    YoutubeChildViewController *videoPlayerViewController = [[YoutubeChildViewController alloc] initWithVideoIdentifier:dataList[indexPath.row][@"id"][@"videoId"]];

    videoPlayerViewController.delegate = self;

    [self presentViewController:videoPlayerViewController animated:YES completion:nil];
    
    if(![self getValue:@"multi"])
    {
        [self addValue:@"1" andKey:@"multi"];
    }
    else
    {
        int k = [[self getValue:@"multi"] intValue] + 1 ;
        
        [self addValue:[NSString stringWithFormat:@"%i", k] andKey:@"multi"];
    }
    
    if([[self getValue:@"multi"] intValue] % 6 == 0)
    {
        //[self performSelector:@selector(showAds) withObject:nil afterDelay:0.5];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
