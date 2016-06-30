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
    if (self.feed) {
        [self.titleTextField setText:[self.feed valueForKey:@"title"]];
        [self.linkTextField setText:[self.feed valueForKey:@"link"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (BOOL)validateUrl:(NSString *)candidate {
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

- (IBAction)saveFeed:(id)sender {
    if ([self.titleTextField.text length]) {
        if ([self.linkTextField.text length]) {
            if([self validateUrl:self.linkTextField.text]){
            NSManagedObjectContext *context = [self managedObjectContext];
            if(self.feed){
                [self.feed setValue:self.titleTextField.text forKey:@"title"];
                [self.feed setValue:self.linkTextField.text forKey:@"link"];
            } else{
                // Create a new managed object
                NSManagedObject *newFeed = [NSEntityDescription insertNewObjectForEntityForName:@"Feeds" inManagedObjectContext:context];
                [newFeed setValue:self.titleTextField.text forKey:@"title"];
                [newFeed setValue:self.linkTextField.text forKey:@"link"];
                            }
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            [self.navigationController popViewControllerAnimated:YES];
            } else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Invalid link!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];

            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Empty link!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    } else{
        if ([self.linkTextField.text length]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Empty title!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Empty title and link!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        }
    }
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
