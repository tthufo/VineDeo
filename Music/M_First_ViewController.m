//
//  M_First_ViewController.m
//  Music
//
//  Created by thanhhaitran on 11/24/15.
//  Copyright © 2015 thanhhaitran. All rights reserved.
//

#import "M_First_ViewController.h"

#import "XCDYouTubeVideoPlayerViewController.h"

#import "M_Detail_ViewController.h"

#import "LMDropdownViewChild.h"

@interface M_First_ViewController ()<LMDropdownViewDelegate>
{
    IBOutlet UITableView * tableView, *dropTableView;
    LMDropdownViewChild * dropdownView;
    NSMutableArray * dataList, * menuList;
    NSString * nextPage, * currentId;
    int totalResult;
    BOOL isLoadMore;
}

@end

@implementation M_First_ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    
    nextPage = @"";
    
    UIBarButtonItem * menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:SYSTEM_VERSION_LESS_THAN(@"7") ? @"menu6" : @"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(didPressMenu)];
    self.navigationItem.leftBarButtonItem = menu;

//    UIBarButtonItem * share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didPressShare)];
//    self.navigationItem.rightBarButtonItem = share;
    
    __weak M_First_ViewController * weakSelf  = self;
    
    [tableView addFooterWithBlock:^{
        
        [weakSelf didLoadMore];
        
    } withIndicatorColor:[UIColor grayColor]];
    
    UIRefreshControl * refresh = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    refresh.tag = 6996;
    [refresh addTarget:self action:@selector(didReload) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refresh];
    
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":@"https://dl.dropboxusercontent.com/s/1svbw0ojlufe56j/VineDeo1_0.plist",@"overrideError":@(1),@"overrideLoading":@(1),@"host":self} withCache:^(NSString *cacheString) {
    } andCompletion:^(NSString *responseString, NSError *error, BOOL isValidated) {
        
        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * er = nil;
        NSDictionary * dict = [self returnDictionary: [XMLReader dictionaryForXMLData:data
                                                                              options:XMLReaderOptionsProcessNamespaces
                                                                                error:&er]];
        
        [self addObject:@{@"banner":dict[@"banner"],@"fullBanner":dict[@"fullBanner"],@"adsMob":dict[@"ads"]} andKey:@"adsInfo"];
        
        [self didPrepareData:[dict[@"show"] boolValue]];
        
        BOOL isUpdate = [dict[@"version"] compare:[self appInfor][@"majorVersion"] options:NSNumericSearch] == NSOrderedDescending;
        
        if(isUpdate)
        {
            [[DropAlert shareInstance] alertWithInfor:@{/*@"option":@(0),@"text":@"wwww",*/@"cancel":@"Close",@"buttons":@[@"Download now"],@"title":@"New Update",@"message":dict[@"update_message"]} andCompletion:^(int indexButton, id object) {
                switch (indexButton)
                {
                    case 0:
                    {
                        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:dict[@"url"]]])
                        {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dict[@"url"]]];
                        }
                    }
                        break;
                    case 1:
                        
                        break;
                    default:
                        break;
                }
            }];
        }
    }];
}

- (void)didPrepareData:(BOOL)isShow
{
    menuList = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithContentsOfPlist:isShow ? @"MenuList" : @"MenuList_short"]];
    
    currentId = [menuList firstObject][@"id"];
    
    self.title = [menuList firstObject][@"title"];
    
    [self didRequestData:currentId];
}

- (NSDictionary*)returnDictionary:(NSDictionary*)dict
{
    NSMutableDictionary * result = [NSMutableDictionary new];
    
    for(NSDictionary * key in dict[@"plist"][@"dict"][@"key"])
    {
        result[key[@"jacknode"]] = dict[@"plist"][@"dict"][@"string"][[dict[@"plist"][@"dict"][@"key"] indexOfObject:key]][@"jacknode"];
    }
    
    return result;
}

- (void)didPressShare
{
    [[FB shareInstance] startShareWithInfo:@[@"ASMRTube for your relaxation and more ",@"https://itunes.apple.com/us/developer/thanh-hai-tran/id1073174100",[UIImage imageNamed:@"Icon-76"]] andBase:nil andRoot:self andCompletion:^(NSString *responseString, id object, int errorCode, NSString *description, NSError *error) {
        
    }];
}

- (void)didRequestData:(NSString *)channelId
{
//    NSString * string = @"https://www.googleapis.com/youtube/v3/search?part=snippet&q=katyperry&type=video&maxResults=25&key=AIzaSyB9IuIAwAJQhhSOQY3rn4bc9A2EjpdG_7c";
    
//  https://www.googleapis.com/youtube/v3/channels?part=snippet&id=UCX70sfic86MKcid2n0mmmqg&fields=itemssnippet%2Fthumbnails&key=AIzaSyB9IuIAwAJQhhSOQY3rn4bc9A2EjpdG_7c
    
    NSString * url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlists?part=snippet,status&contentDetails&channelId=%@&type=video&maxResults=25&key=AIzaSyB9IuIAwAJQhhSOQY3rn4bc9A2EjpdG_7c",channelId];

    if(nextPage.length != 0)
    {
        url = [NSString stringWithFormat:@"%@&pageToken=%@",url,nextPage];
    }
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":url,@"method":@"GET",@"host":self,@"overrideError":@(1)} withCache:^(NSString *cacheString) {
        
        [self didSetupData:cacheString];
        
    } andCompletion:^(NSString *responseString, NSError *error, BOOL isValidated) {
        
        [((UIRefreshControl*)[self withView:tableView tag:6996]) endRefreshing];
        
        [tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:0.5];
        
        if(isValidated)
        {
            [self didSetupData:responseString];
        }
        
    }];
}

- (void)didSetupData:(NSString*)json
{
    NSDictionary * dict = [json objectFromJSONString];
    
    nextPage = dict[@"nextPageToken"];
    
    if(dataList.count >= [dict[@"pageInfo"][@"totalResults"] intValue])
    {
        return ;
    }
    
    if(!isLoadMore)
    {
        [dataList removeAllObjects];
    }
    
    [dataList addObjectsFromArray:dict[@"items"]];
        
    [tableView reloadData];
}

- (void)didPressMenu
{
    if (!dropdownView)
    {
        dropdownView = [[LMDropdownViewChild alloc] init];
        dropdownView.delegate = self;
        dropdownView.menuContentView = dropTableView;
        dropdownView.menuBackgroundColor = [UIColor whiteColor];
        CGRect rect = dropTableView.frame;
        rect.size.height = screenHeight - 64 - 50;
        rect.size.width = screenWidth;
        dropTableView.frame = rect;
    }
    if ([dropdownView isOpen])
    {
        [dropdownView hide];
    }
    else
    {
        [dropdownView showInView:self.view withFrame:CGRectMake(0, SYSTEM_VERSION_LESS_THAN(@"7") ? 0 : 0, screenWidth, screenHeight)];
    }
    if(![self getValue:@"menu"])
    {
        [self addValue:@"1" andKey:@"menu"];
    }
    else
    {
        int count = [[self getValue:@"menu"] intValue] + 1 ;
        
        [self addValue:[NSString stringWithFormat:@"%i", count] andKey:@"menu"];
    }
    
    if([[self getValue:@"menu"] intValue] % 5 == 0)
    {
        [self performSelector:@selector(presentAds) withObject:nil afterDelay:2];
    }

}

- (void)didReload
{
    isLoadMore = NO;
    [self didRequestData:currentId];
}

- (void)didLoadMore
{
    isLoadMore = YES;
    [self didRequestData:currentId];
}

-(NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableView.tag == 111 ? menuList.count : dataList.count;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tableView.tag == 111 ? 70 : 74;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:_tableView.tag == 111 ? @"menuCell" : @"listCell"];
    if(!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil][_tableView.tag == 111 ? 1 : 0];
    }
    
    if(_tableView.tag != 111)
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
        
        ((UILabel*)[self withView:cell tag:12]).text = dict[@"snippet"][@"title"];
        
        [((UIView*)[self withView:cell tag:8899]) withShadow:[AVHexColor colorWithHexString:@"#F7F7F7"]];
    }
    else
    {
        [((UIImageView*)[self withView:cell tag:11]) sd_setImageWithURL:[NSURL URLWithString:menuList[indexPath.row][@"image"]] placeholderImage:kAvatar options:SDWebImageCacheMemoryOnly];
        
        ((UILabel*)[self withView:cell tag:12]).text = menuList[indexPath.row][@"title"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_tableView.tag != 111)
    {
        M_Detail_ViewController * detail = [M_Detail_ViewController new];
        detail.playListId = dataList[indexPath.row][@"id"];
        detail.titleName = self.title;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        isLoadMore = NO;
        nextPage = @"";
        [dropdownView hide];
        currentId = menuList[indexPath.row][@"id"];
        self.title = menuList[indexPath.row][@"title"];
        [dataList removeAllObjects];
        [self didRequestData:currentId];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
