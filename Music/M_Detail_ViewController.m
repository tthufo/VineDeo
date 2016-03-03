//
//  M_Detail_ViewController.m
//  Music
//
//  Created by thanhhaitran on 11/25/15.
//  Copyright © 2015 thanhhaitran. All rights reserved.
//

#import "M_Detail_ViewController.h"

#import "YoutubeChildViewController.h"

@interface M_Detail_ViewController ()<PlayerDelegate>
{
    NSMutableArray * dataList;
    
    IBOutlet UICollectionView * collectionView;
}

@end

@implementation M_Detail_ViewController

@synthesize playListId, titleName;

- (void)playerDidFinish:(NSDictionary*)dict
{
    if(![self getValue:@"detail"])
    {
        [self addValue:@"1" andKey:@"detail"];
    }
    else
    {
        int count = [[self getValue:@"detail"] intValue] + 1 ;
        
        [self addValue:[NSString stringWithFormat:@"%i", count] andKey:@"detail"];
    }
    
    if([[self getValue:@"detail"] intValue] % 3 == 0)
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = titleName;
    
    dataList = [NSMutableArray new];
    
    if(SYSTEM_VERSION_LESS_THAN(@"7"))
    {
        UIBarButtonItem * back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didPressDone)];
        self.navigationItem.leftBarButtonItem = back;
    }
    
    [collectionView registerNib:[UINib nibWithNibName:@"EM_Cells" bundle:nil] forCellWithReuseIdentifier:@"imageCell"];
    
    if(SYSTEM_VERSION_GREATER_THAN(@"7"))
    {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        
        collectionView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
    }
    
    [self didRequestData];
}

- (void)didPressDone
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRequestData
{
    NSString * string = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet,contentDetails,status&playlistId=%@&maxResults=25&key=AIzaSyB9IuIAwAJQhhSOQY3rn4bc9A2EjpdG_7c",playListId];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[string stringByAddingPercentEscapesUsingEncoding:
                                                                  NSUTF8StringEncoding],@"method":@"GET",@"host":self,@"overrideError":@(1)} withCache:^(NSString *cacheString) {
        
        NSDictionary * dict = [cacheString objectFromJSONString];
        
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

    } andCompletion:^(NSString *responseString, NSError *error, BOOL isValidated) {
        
        if(isValidated)
        {
            NSDictionary * dict = [responseString objectFromJSONString];
            
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
        }
        
    }];
}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return dataList.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 134;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
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
//    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dataList[indexPath.row][@"snippet"][@"title"],dataList[indexPath.row][@"snippet"][@"resourceId"][@"videoId"]];
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
//    NSString * url = [NSString stringWithFormat: @"https://www.youtube.com/watch?v=%@",dataList[indexing][@"snippet"][@"resourceId"][@"videoId"]];
//    
//    [[FB shareInstance] startShareWithInfo:@[@"Check out this ASMR videos",url] andBase:sender andRoot:self andCompletion:^(NSString *responseString, id object, int errorCode, NSString *description, NSError *error) {
//        
//    }];
//}

- (void)didPressFavorite:(UIButton*)sender
{
    int indexing = [self inDexOf:sender andCollection:collectionView];
    
    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dataList[indexing][@"snippet"][@"title"],dataList[indexing][@"snippet"][@"resourceId"][@"videoId"]];
    
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
//    YoutubeChildViewController *videoPlayerViewController = [[YoutubeChildViewController alloc] initWithVideoIdentifier:dataList[indexPath.row][@"snippet"][@"resourceId"][@"videoId"]];
//    
//    videoPlayerViewController.delegate = self;
//    
//    [self presentViewController:videoPlayerViewController animated:YES completion:nil];
//}

#pragma CollectionView

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return dataList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
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
    
    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dataList[indexPath.row][@"snippet"][@"title"],dataList[indexPath.row][@"snippet"][@"resourceId"][@"videoId"]];
    
    NSArray * data = [System getFormat:@"key=%@" argument:@[videoId]];
    
    [((UIButton*)[self withView:cell tag:14]) setImage:[UIImage imageNamed:data.count == 0 ? @"add" : @"remove"] forState:UIControlStateNormal];
    
//    ((UIButton*)[self withView:cell tag:14]).alpha = data.count == 0 ? 1 : 0.3;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(screenWidth / 2 - 4.0, screenWidth / 2 - 4.0);
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
    YoutubeChildViewController *videoPlayerViewController = [[YoutubeChildViewController alloc] initWithVideoIdentifier:dataList[indexPath.row][@"snippet"][@"resourceId"][@"videoId"]];

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
