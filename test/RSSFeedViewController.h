//
//  ViewController.h
//  test
//
//  Created by Admin on 28.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationController.h"

@interface RSSFeedViewController : UIViewController <SlideNavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *rssfeeds;

@end

