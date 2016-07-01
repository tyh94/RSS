//
//  RSSSourceViewController.m
//  test
//
//  Created by Admin on 29.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "RSSSourceViewController.h"
#import "AppDelegate.h"
#import "RSSSourceTableViewCell.h"
#import "RSSSourceEditViewController.h"
#import "RSSFeedViewController.h"

@interface RSSSourceViewController ()

@end

@implementation RSSSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Feeds"];
    
       self.feeds = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    
    [self.tableView reloadData];
}

- (void)deleteAllEntities:(NSString *)nameEntity
{
    
    NSManagedObjectContext *theContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [theContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [theContext deleteObject:object];
    }
    
    error = nil;
    [theContext save:&error];
}

-(NSArray *) createRightButtons:(NSIndexPath *)indexPath
{
    NSMutableArray * result = [NSMutableArray array];
    NSManagedObjectContext *context = [self managedObjectContext];
    
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell * sender){
#if DEBUG
            NSLog(@"Deleted.");
#endif
            // Delete object from database
            [context deleteObject:[self.feeds objectAtIndex:indexPath.row]];
            NSError *error = nil;
            
            error = nil;
            if (![context save:&error]) {
#if DEBUG
                NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
#endif
            }else{
                // Remove device from table view
                [self.feeds removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadData];
            }
            [self deleteAllEntities:@"RSS"];
            
            return NO; //Don't autohide in delete button to improve delete expansion animation
        }];
        [result addObject:button];
        
    button = [MGSwipeButton buttonWithTitle:@"Edit" backgroundColor:[UIColor lightGrayColor] callback:^BOOL(MGSwipeTableCell * sender){
#if DEBUG
        NSLog(@"Edited.");
#endif
        NSManagedObject *selectedFeed = [self.feeds objectAtIndex:indexPath.row];
        RSSSourceEditViewController *rssSourceEditViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RSSSourceEditViewController"];
        rssSourceEditViewController.feed = selectedFeed;
        [self.navigationController pushViewController:rssSourceEditViewController animated:YES];
        return NO; //Don't autohide in delete button to improve delete expansion animation
    }];
    [result addObject:button];
    return result;
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RSSFeedCell";
    
    RSSSourceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RSSSourceTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.rightButtons = [self createRightButtons:indexPath];
    cell.labelTitle.text = [[self.feeds objectAtIndex:indexPath.row] valueForKey: @"title"];
    cell.labelLink.text = [[self.feeds objectAtIndex:indexPath.row] valueForKey: @"link"];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}

@end
