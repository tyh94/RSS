//
//  RSSSourceEditViewController.m
//  test
//
//  Created by Admin on 29.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "RSSSourceEditViewController.h"
#import "AppDelegate.h"

@interface RSSSourceEditViewController ()

@end

@implementation RSSSourceEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveFeed:(id)sender {
    if (self.titleTextField.text) {
        if (self.linkTextField.text) {
            
            NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Feeds" inManagedObjectContext:[((AppDelegate *)[[UIApplication sharedApplication] delegate])managedObjectContext]];
            [person setValue:self.titleTextField.text forKey:@"title"];
            [person setValue:self.linkTextField.text forKey:@"link"];
            
            [((AppDelegate *)[[UIApplication sharedApplication] delegate]) saveContext];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end
