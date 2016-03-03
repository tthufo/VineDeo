//
//  M_Second_ViewController.m
//  Music
//
//  Created by thanhhaitran on 11/25/15.
//  Copyright © 2015 thanhhaitran. All rights reserved.
//

#import "M_Second_ViewController.h"

#import "YoutubeChildViewController.h"

@interface M_Second_ViewController () <UISearchBarDelegate, PlayerDelegate>
{
    IBOutlet UICollectionView * collectionView;
    NSMutableArray * dataList;
    IBOutlet UISearchBar * searchBar;
    BOOL isSearch;
    float height;
}

@end

@implementation M_Second_ViewController

- (void)playerDidFinish:(NSDictionary*)dict
{
    if(![self getValue:@"fav"])
    {
        [self addValue:@"1" andKey:@"fav"];
    }
    else
    {
        int count = [[self getValue:@"fav"] intValue] + 1 ;
        
        [self addValue:[NSString stringWithFormat:@"%i", count] andKey:@"fav"];
    }
    
    if([[self getValue:@"fav"] intValue] % 3 == 0)
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


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self registerForKeyboardNotifications:NO andSelector:@[@"keyboardWasShown:",@"keyboardWillBeHidden:"]];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect f = collectionView.frame;
    f.size.height -= keyboardSize.height - 50;
    collectionView.frame = f;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect f = collectionView.frame;
    f.size.height += keyboardSize.height - 50;
    collectionView.frame = f;
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
    
    dataList = [NSMutableArray new];
    
    UIBarButtonItem * seachBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didPressSearch)];
    
    self.navigationItem.rightBarButtonItem = seachBar;
    
    searchBar.frame = CGRectMake(0, SYSTEM_VERSION_LESS_THAN(@"7") ? 2 : 2, screenWidth, 35);
    
    searchBar.delegate = self;
    
    collectionView.frame = CGRectMake(0, SYSTEM_VERSION_LESS_THAN(@"7") ? 0.1 : 0, screenWidth, screenHeight - (SYSTEM_VERSION_LESS_THAN(@"7") ? 0.1 : 0));
    
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
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [dataList removeAllObjects];
    
    if(searchText.length != 0)
        [dataList addObjectsFromArray:[System getFormat:@"key contains[cd] %@" argument:@[searchText]]];
    else
        [dataList addObjectsFromArray:[System getAll]];
    
    [collectionView reloadData];
}

- (void)didPressSearch
{
    if(dataList.count == 0) return;
    isSearch =! isSearch;
    [collectionView reloadData];
    if(isSearch)
    {
        [self.view addSubview:searchBar];
        [searchBar becomeFirstResponder];
    }
    else
    {
        searchBar.text = @"";
        [dataList removeAllObjects];
        [dataList addObjectsFromArray:[System getAll]];
        [collectionView reloadData];
        [searchBar resignFirstResponder];
        [searchBar removeFromSuperview];
    }
    collectionView.contentInset = UIEdgeInsetsMake(isSearch ? 40 : 0, 0, SYSTEM_VERSION_LESS_THAN(@"7") ? 15 : 45, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications:YES andSelector:@[@"keyboardWasShown:",@"keyboardWillBeHidden:"]];
    
    [dataList removeAllObjects];
    
    [dataList addObjectsFromArray:[System getAll]];
    
    [collectionView reloadData];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return isSearch ? 40 : 0;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return dataList.count == 0 ? 1 : dataList.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return dataList.count == 0 ? 150 : 134;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(dataList.count == 0)
//    {
//        return [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil][3];
//    }
//    
//    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"detailCell"];
//    if(!cell)
//    {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil][2];
//    }
//    
//    NSDictionary * dict = [System getValue:((System*)dataList[indexPath.row]).key];
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
//    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dict[@"snippet"][@"title"],dict[@"snippet"][@"resourceId"][@"videoId"] ? dict[@"snippet"][@"resourceId"][@"videoId"] : dict[@"id"][@"videoId"]];
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
//    NSString * url = [NSString stringWithFormat: @"https://www.youtube.com/watch?v=%@",[System getValue:((System*)dataList[indexing]).key][@"snippet"][@"resourceId"][@"videoId"] ? [System getValue:((System*)dataList[indexing]).key][@"snippet"][@"resourceId"][@"videoId"] : [System getValue:((System*)dataList[indexing]).key][@"id"][@"videoId"]];
//    
//    [[FB shareInstance] startShareWithInfo:@[@"Check out this ASMR video",url] andBase:sender andRoot:self andCompletion:^(NSString *responseString, id object, int errorCode, NSString *description, NSError *error) {
//        
//        
//    }];
//}

- (void)didPressFavorite:(UIButton*)sender
{
    int indexing = [self inDexOf:sender andCollection:collectionView];
    
    NSDictionary * dict = [System getValue:((System*)dataList[indexing]).key];
    
    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dict[@"snippet"][@"title"],dict[@"snippet"][@"resourceId"][@"videoId"] ? dict[@"snippet"][@"resourceId"][@"videoId"] : dict[@"id"][@"videoId"]];
    
    [System removeValue:videoId];

    [dataList removeAllObjects];
    
    [dataList addObjectsFromArray:[System getAll]];
    
    [collectionView reloadData];
}

//- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    [self.view endEditing:YES];
//    
//    if(dataList.count == 0) return;
//    
//    NSDictionary * dict = [System getValue:((System*)dataList[indexPath.row]).key];
//    
//    YoutubeChildViewController *videoPlayerViewController = [[YoutubeChildViewController alloc] initWithVideoIdentifier:dict[@"snippet"][@"resourceId"][@"videoId"] ? dict[@"snippet"][@"resourceId"][@"videoId"] : dict[@"id"][@"videoId"]];
//    
//    videoPlayerViewController.delegate = self;
//    
//    [self presentViewController:videoPlayerViewController animated:YES completion:^{
//        if(isSearch)
//        {
//            isSearch = NO;
//            [tableView reloadDataWithAnimation:YES];
//            searchBar.text = @"";
//            [searchBar resignFirstResponder];
//            [searchBar removeFromSuperview];
//        }
//    }];
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
//        ((UILabel*)[self withView:cell tag:18]).text = @"Add favorite video to your list";
//        
//        return cell;
//    }
    
    NSDictionary * dict = [System getValue:((System*)dataList[indexPath.row]).key];
    
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
    
    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dict[@"snippet"][@"title"],dict[@"snippet"][@"resourceId"][@"videoId"] ? dict[@"snippet"][@"resourceId"][@"videoId"] : dict[@"id"][@"videoId"]];
    
    NSArray * data = [System getFormat:@"key=%@" argument:@[videoId]];
    
    [((UIButton*)[self withView:cell tag:14]) setImage:[UIImage imageNamed:data.count == 0 ? @"add" : @"remove"] forState:UIControlStateNormal];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return /*dataList.count == 0 ? CGSizeMake(screenWidth, screenWidth) : */CGSizeMake(screenWidth / 2 - 4.0, screenWidth / 2 - 4.0);
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

    NSDictionary * dict = [System getValue:((System*)dataList[indexPath.row]).key];

    YoutubeChildViewController *videoPlayerViewController = [[YoutubeChildViewController alloc] initWithVideoIdentifier:dict[@"snippet"][@"resourceId"][@"videoId"] ? dict[@"snippet"][@"resourceId"][@"videoId"] : dict[@"id"][@"videoId"]];

    videoPlayerViewController.delegate = self;

    [self presentViewController:videoPlayerViewController animated:YES completion:^{
        if(isSearch)
        {
            isSearch = NO;
            [collectionView reloadData];
            searchBar.text = @"";
            [searchBar resignFirstResponder];
            [searchBar removeFromSuperview];
            collectionView.contentInset = UIEdgeInsetsMake(isSearch ? 40 : 0, 0, SYSTEM_VERSION_LESS_THAN(@"7") ? 15 : 45, 0);
        }
    }];

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
        [self performSelector:@selector(presentAds) withObject:nil afterDelay:0.5];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
