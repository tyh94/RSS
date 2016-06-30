//
//  RSSSourceTableViewCell.h
//  test
//
//  Created by Admin on 30.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface RSSSourceTableViewCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelLink;

@end
