//
//  ViewController.m
//  test
//
//  Created by Admin on 28.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "RSSFeedViewController.h"
#import "RSSFeedTableViewCell.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface RSSFeedViewController (){
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *description;
    NSMutableString *link;
    NSString *element;
}
@end

@implementation RSSFeedViewController

- (void)addFavorite:(UIButton*)sender {
    NSLog(@"%ld",(long)sender.tag);
    NSManagedObjectContext *context = [self managedObjectContext];
    if ([[[self.feeds objectAtIndex:sender.tag]valueForKey: @"favorite"] boolValue]){
        [[self.feeds objectAtIndex:sender.tag] setValue:@NO forKey:@"favorite"];
    }else{
        [[self.feeds objectAtIndex:sender.tag] setValue:@YES forKey:@"favorite"];
    }
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    [self.tableView reloadData];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feeds = [[NSMutableArray alloc] init];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Feeds"];
    self.rssfeeds = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSObject *feed in self.rssfeeds) {
        NSURL *url = [NSURL URLWithString:[feed valueForKey:@"link"]];
        parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
    }
    
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSS"];
    if(self.isFavorite){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite==YES"];
        [fetchRequest setPredicate:predicate];
    }
    self.feeds = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
- (IBAction)segmentChange:(id)sender {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Feeds"];
    fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RSS"];
    
    if (self.segmentedControl.selectedSegmentIndex == 1){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite==YES"];
        [fetchRequest setPredicate:predicate];
    }

    self.feeds = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feeds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RSSFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RSSFeedCell" forIndexPath:indexPath];
    cell.labelTitle.text = [[self.feeds objectAtIndex:indexPath.row] valueForKey: @"title"];
    cell.labelDescription.text = [[self.feeds objectAtIndex:indexPath.row]valueForKey: @"info"];
    if([[[self.feeds objectAtIndex:indexPath.row]valueForKey: @"favorite"] boolValue]){
        [cell.favoriteButton setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
    }else{
        [cell.favoriteButton setImage:[UIImage imageNamed:@"AddFavorite"] forState:UIControlStateNormal];
    }
    cell.favoriteButton.tag = indexPath.row;
    [cell.favoriteButton addTarget:self action:@selector(addFavorite:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        NSManagedObjectContext *context = [self managedObjectContext];        
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"RSS" inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        [request setFetchLimit:1];
        [request setPredicate:[NSPredicate predicateWithFormat:@"title == %@", title]];
        
        NSError *error = nil;
        NSUInteger count = [context countForFetchRequest:request error:&error];
        
        if (!count)
        {
            NSManagedObject *newFeed = [NSEntityDescription insertNewObjectForEntityForName:@"RSS" inManagedObjectContext:context];
            [newFeed setValue:title forKey:@"title"];
            [newFeed setValue:link forKey:@"link"];
            [newFeed setValue:description forKey:@"info"];
            [newFeed setValue:@NO forKey:@"favorite"];
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't add! %@ %@", error, [error localizedDescription]);
            }
        }

        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([element isEqualToString:@"description"]) {
        [description appendString:string];
    } else if ([element isEqualToString:@"pubDate"]){
        //Date
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *string = [self.feeds[indexPath.row] valueForKey: @"link"];
        [[segue destinationViewController] setUrl:string];
        
    }
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}

@end
