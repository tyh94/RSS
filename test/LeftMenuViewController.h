//
//  LeftMenuViewController.h
//  test
//
//  Created by Admin on 28.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *leftMenuTableView;
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;
@end
