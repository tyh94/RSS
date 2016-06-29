//
//  RSSSourceViewController.m
//  test
//
//  Created by Admin on 29.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "RSSSourceViewController.h"
#import "AppDelegate.h"

@interface RSSSourceViewController ()

@end

@implementation RSSSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feeds = [[[((AppDelegate *)[[UIApplication sharedApplication] delegate]) data] valueForKey:@"feeds"] firstObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RSSFeedCell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.feeds objectAtIndex:indexPath.row] valueForKey: @"title"];
    return cell;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}

@end
