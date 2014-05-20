//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Joanne McNamee on 5/19/14.
//  Copyright (c) 2014 JMWHS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property NSMutableArray *toDoArray;
@property (weak, nonatomic) IBOutlet UITableView *toDoTableView;

@property NSInteger indexPathRowToBeDeleted;

@property NSMutableArray *toDoItemPriorityArray;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.toDoArray = [NSMutableArray arrayWithObjects:@"Ignore Don",
                      @"Buy Kevin Lunch",
                      @"Make the early train",
                      @"Don't sleep in tomorrow", nil];

    self.toDoItemPriorityArray = [NSMutableArray arrayWithObjects:
                                  [NSNumber numberWithInt:0],
                                  [NSNumber numberWithInt:0],
                                  [NSNumber numberWithInt:0],
                                  [NSNumber numberWithInt:0], nil];

    [self.navigationController setNavigationBarHidden:YES];
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) {

        [self.toDoArray removeObjectAtIndex:self.indexPathRowToBeDeleted];
        [self.toDoItemPriorityArray removeObjectAtIndex:self.indexPathRowToBeDeleted];
        [self.toDoTableView reloadData];

    }

}


#pragma mark - TableView Delegate Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.toDoArray.count;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCell"];
    cell.textLabel.text = [self.toDoArray objectAtIndex:indexPath.row];

    if ([self.toDoItemPriorityArray objectAtIndex:indexPath.row] == [NSNumber numberWithInt:1]) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor greenColor];
    }
    else if ([self.toDoItemPriorityArray objectAtIndex:indexPath.row] == [NSNumber numberWithInt:2]) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor yellowColor];
    }
    else if ([self.toDoItemPriorityArray objectAtIndex:indexPath.row] == [NSNumber numberWithInt:3]) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor redColor];
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
    }

    return cell;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    self.indexPathRowToBeDeleted = indexPath.row;

    UIAlertView *confirmDeleteAlertView = [[UIAlertView alloc]initWithTitle:@"Delete Item?"
                                                                    message:@"This cannot be undone"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:@"Delete", nil];
    [confirmDeleteAlertView show];
}


-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
        if([self.editButton.currentTitle isEqualToString:@"Done" ])
        {
            NSString *stringToMove = [self.toDoArray objectAtIndex:sourceIndexPath.row];
            [self.toDoArray removeObjectAtIndex:sourceIndexPath.row];
            [self.toDoArray insertObject:stringToMove atIndex:destinationIndexPath.row];

            NSNumber *priorityToMove = [self.toDoItemPriorityArray objectAtIndex:sourceIndexPath.row];
            [self.toDoItemPriorityArray removeObjectAtIndex:sourceIndexPath.row];
            [self.toDoItemPriorityArray insertObject:priorityToMove atIndex:destinationIndexPath.row];
        }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if([self.editButton.currentTitle isEqualToString:@"Done"])
    {
        [self.toDoArray removeObjectAtIndex:indexPath.row];
        [self.toDoItemPriorityArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}


#pragma mark - Helper Methods

- (IBAction)onCancelButtonPressed:(id)sender {
    [self.inputTextField resignFirstResponder];
}

- (IBAction)onAddButtonPressed:(id)sender
{
    if (self.inputTextField.text.length != 0) {

        NSString *nextToDoItem = self.inputTextField.text;
        [self.toDoArray addObject:nextToDoItem];
        [self.toDoItemPriorityArray addObject:[NSNumber numberWithInt:0]];

        [self.inputTextField resignFirstResponder];
        self.inputTextField.text = @"";

        [self.toDoTableView reloadData];
    }
}

- (IBAction)onEditButtonPressed:(id)sender
{
    UIButton *editButton = sender;

    if([editButton.currentTitle isEqualToString:@"Edit List" ])
    {
        [editButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.toDoTableView setEditing:YES animated:YES];
    }
    else if([editButton.currentTitle isEqualToString:@"Done" ])
    {
        [editButton setTitle:@"Edit List" forState:UIControlStateNormal];
        [self.toDoTableView setEditing:NO animated:NO];
    }
    
}


- (IBAction)onSwipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{

    if ([self.editButton.currentTitle isEqualToString:@"Done"]) {

        if (swipeGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint swipeLocation = [swipeGestureRecognizer locationInView:self.toDoTableView];
            NSIndexPath *swipeIndex = [self.toDoTableView indexPathForRowAtPoint:swipeLocation];
            [self.toDoArray removeObjectAtIndex:swipeIndex.row];
            [self.toDoItemPriorityArray removeObjectAtIndex:swipeIndex.row];

            [self.toDoTableView reloadData];
        }
    }

    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {

        if (swipeGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint swipeLocation = [swipeGestureRecognizer locationInView:self.toDoTableView];
            NSIndexPath *swipeIndex = [self.toDoTableView indexPathForRowAtPoint:swipeLocation];
            UITableViewCell *swipedCell = [self.toDoTableView cellForRowAtIndexPath:swipeIndex];

            if (swipedCell.textLabel.textColor == [UIColor blackColor]) {
                swipedCell.backgroundColor = [UIColor greenColor];
                swipedCell.textLabel.textColor = [UIColor whiteColor];
                [self.toDoItemPriorityArray replaceObjectAtIndex:swipeIndex.row withObject:[NSNumber numberWithInt:1]];
            }
            else if (swipedCell.backgroundColor == [UIColor greenColor]) {
                swipedCell.backgroundColor = [UIColor yellowColor];
                swipedCell.textLabel.textColor = [UIColor whiteColor];
                [self.toDoItemPriorityArray replaceObjectAtIndex:swipeIndex.row withObject:[NSNumber numberWithInt:2]];
            }
            else if (swipedCell.backgroundColor == [UIColor yellowColor]) {
                swipedCell.backgroundColor = [UIColor redColor];
                swipedCell.textLabel.textColor = [UIColor whiteColor];
                [self.toDoItemPriorityArray replaceObjectAtIndex:swipeIndex.row withObject:[NSNumber numberWithInt:3]];
            }
            else if (swipedCell.backgroundColor == [UIColor redColor]) {
                swipedCell.textLabel.textColor = [UIColor blackColor];
                swipedCell.backgroundColor = [UIColor whiteColor];
                [self.toDoItemPriorityArray replaceObjectAtIndex:swipeIndex.row withObject:[NSNumber numberWithInt:0]];
            }

            [self.toDoTableView reloadData];
        }
    }
}
@end
