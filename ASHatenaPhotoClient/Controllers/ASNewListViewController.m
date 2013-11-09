//
//  ASNewListViewController.m
//  ASHatenaPhotoClient
//
//  Created by rumi on 2013/11/03.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import "ASNewListViewController.h"
#import "ASListViewCell.h"
#import "ASDateUtil.h"
#import "UIImageView+WebCache.h"
#import "ASStringUtil.h"
#import "ASPhotoListFetcher.h"
#import "UITabBarController+CustomAdditions.h"
#import "SVProgressHUD.h"
#import "IDMPhotoBrowser.h"

@interface ASNewListViewController ()


@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL hasMorePage;
@property (nonatomic, assign) int currentPage;

@end

@implementation ASNewListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.results = [NSMutableArray array];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshAction:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.currentPage = 1;
    [self requestPhotoList];
    
    [SVProgressHUD show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.hasMorePage) {
        return self.results.count + 1;
    }
    
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.results.count) {
        return [self configureCell:indexPath];
    } else {
        return [self loadingCell];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == LOADING_CELL_TAG) {
        cell.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        if (self.hasMorePage) {
            [self requestPhotoList];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= self.results.count) {
        return 50.0;
    }
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.results[indexPath.row];
    
    IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:item[@"hatena:imageurl"]]];
    photo.caption = item[@"title"];
    NSArray *photos = @[photo];
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    
    [self presentViewController:browser animated:YES completion:nil];
}

#pragma mark - action method

- (void)refreshAction:(id)sender
{
    self.isRefresh = YES;
    self.hasMorePage = YES;
    self.currentPage = 1;
    
    [self requestPhotoList];
}

#pragma mark - cell setup

// Setup a timeline cell.
- (UITableViewCell *)configureCell:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ASListViewCell";
    ASListViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *photos = self.results[indexPath.row];
    // caption
    cell.messageLabel.text = photos[@"title"];
    // date
    cell.dateLabel.text = [ASDateUtil parseDate:photos[@"dc:date"]];
    // image
    [cell.listImageView setImageWithURL:[NSURL URLWithString:photos[@"hatena:imageurl"]]
                       placeholderImage:nil];
    
    NSString *syntax = photos[@"hatena:syntax"];
    NSArray *syntaxList = [syntax componentsSeparatedByString:@":"];
    if (syntaxList.count > 3) {
        // userId
        cell.userIdLabel.text = [NSString stringWithFormat:@"id:%@", syntaxList[2]];
    }
    
    return cell;
}

// Setup  a loading cell.
- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleDefault
                             reuseIdentifier:nil];
    
    if (self.results.count > 0) {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = cell.center;
        [cell.contentView addSubview:activityIndicator];
        
        [activityIndicator startAnimating];
    }
    
    cell.tag = LOADING_CELL_TAG;
    
    return cell;
}


- (void)requestPhotoList
{
    __weak ASNewListViewController *weakSelf = self;
    
    ASPhotoListFetcher *fetcher = [[ASPhotoListFetcher alloc] init];
    [fetcher beginFetchNewPhotoList:self.currentPage completionHandler:^(NSDictionary *result, NSError *error) {
        if (!error) {
            NSArray *results = result[@"rdf:RDF"][@"item"];
            NSLog(@"results: %@", results);
            
            if (weakSelf.isRefresh) {
                [weakSelf.results removeAllObjects];
            }
            
            if (results.count > 0) {
                
                self.hasMorePage = YES;
                
                [weakSelf.results addObjectsFromArray:results];
                [weakSelf.tableView reloadData];
                
                weakSelf.currentPage++;
            } else {
                weakSelf.hasMorePage = NO;
            }
        }
        
        weakSelf.isRefresh = NO;
        [weakSelf.refreshControl endRefreshing];
        
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > -64) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideNaviBarAndTabBar) object:nil];
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.tabBarController setTabBarHidden:YES animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self performSelector:@selector(hideNaviBarAndTabBar) withObject:nil afterDelay:0.5];
}

- (void)hideNaviBarAndTabBar
{
    [self.tabBarController setTabBarHidden:NO animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
