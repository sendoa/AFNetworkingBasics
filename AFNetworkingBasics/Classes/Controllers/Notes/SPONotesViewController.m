//
//  SPONotesViewController.m
//  AFNetworkingBasics
//
//  Created by Sendoa Portuondo on 18/10/13.
//  Copyright (c) 2013 Sendoa Portuondo. All rights reserved.
//

#import "SPONotesViewController.h"
#import "SPONotesAPIEngine.h"
#import "SPOUser.h"
#import "SPONote.h"

@interface SPONotesViewController ()

@property (strong, nonatomic) SPOUser *user;
@property (copy, nonatomic) NSArray *notes;

@end

@implementation SPONotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get active user info
    [[SPONotesAPIEngine sharedInstance] fetchUserDataWithUserId:@"abSEqbrJF9MW0kNNqhip" onCompletion:^(SPOUser *user, NSError *error) {
        if (!error) {
            self.user = user;
            self.title = [NSString stringWithFormat:@"Notas de %@", self.user.completeName];
            [self fetchNotes];
        } else {
            // Error processing
        }
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *noteCellidentifier = @"NoteCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noteCellidentifier];
    SPONote *note = self.notes[indexPath.row];
    cell.textLabel.text = note.textContent;
    
    return cell;
}

#pragma mark - Helpers
- (void)fetchNotes
{
    [[SPONotesAPIEngine sharedInstance] fetchNotesForUser:self.user onCompletion:^(NSArray *notes, NSError *error) {
        if (!error) {
            self.notes = notes;
            [self.tableView reloadData];
        } else {
            // Error processing
        }
    }];
}

@end
