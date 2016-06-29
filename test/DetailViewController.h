//
//  DetailViewController.h
//  test
//
//  Created by Admin on 29.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
@property (copy, nonatomic) NSString *url;
@end
