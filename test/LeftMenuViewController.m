//
//  LeftMenuViewController.m
//  test
//
//  Created by Admin on 28.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LeftMenuTableViewCell.h"
#import "SlideNavigationController.h"
#import "RSSFeedViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController


- (id) initWithCoder:(NSCoder *)aDecoder{
    self.slideOutAnimationEnabled = YES;
    return [super initWithCoder:aDecoder];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    
    switch (indexPath.row)
    {
        case 0:
            cell.labelTitle.text = @"RSS source";
            break;
            
        case 1:
            cell.labelTitle.text = @"RSS feeds";
            break;
            
        case 2:
            cell.labelTitle.text = @"Favorites";
            break;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    UIViewController *vc ;
    
    switch (indexPath.row)
    {
        case 0:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"RSSSourceViewController"];
            break;
            
        case 1:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"RSSFeedViewController"];
            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
            break;
            
        case 2:
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"RSSFeedViewController"];
            ((RSSFeedViewController *)vc).isFavorite = @YES;
            break;
    }
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
                                                                     andCompletion:nil];
    if(indexPath.row == 2 || indexPath.row == 1){
        
        [((RSSFeedViewController *)vc) viewDidLoad];
        [((RSSFeedViewController *)vc).tableView reloadData];
    }
}


@end
