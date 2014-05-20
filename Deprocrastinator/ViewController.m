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

@property int indexPathRowToBeDeleted;

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	self.toDoArray = [NSMutableArray arrayWithObjects:@"Ignore Don",
                      @"Buy Kevin Lunch",
                      @"Maker the early train",
                      @"Don't sleep in tomorrow", nil];

    [self.navigationController setNavigationBarHidden:YES];
}


- (IBAction)onEditButtonPressed:(id)sender
{
    UIButton *editButton = sender;
    if([editButton.currentTitle isEqualToString:@"Edit" ])
    {
    [editButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.toDoTableView setEditing:YES animated:YES];
    }
    else if([editButton.currentTitle isEqualToString:@"Done" ])
    {
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.toDoTableView setEditing:NO animated:NO];
    }

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {

        [self.toDoArray removeObjectAtIndex:self.indexPathRowToBeDeleted];
        [self.toDoTableView reloadData];

    }

}


#pragma mark - Table Delegate Methods

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

        }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.toDoArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCell"];
    cell.textLabel.text = [self.toDoArray objectAtIndex:indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if([self.editButton.currentTitle isEqualToString:@"Done"])
    {
        [self.toDoArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}


#pragma mark - Helper Methods

- (IBAction)onAddButtonPressed:(id)sender
{
    NSString *nextToDoItem = self.inputTextField.text;
    [self.toDoArray addObject:nextToDoItem];
    [self.inputTextField resignFirstResponder];
    self.inputTextField.text = @"";

    [self.toDoTableView reloadData];
    
}

- (IBAction)onSwipeGesture:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{

    if ([self.editButton.currentTitle isEqualToString:@"Done"]) {

        if (swipeGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint swipeLocation = [swipeGestureRecognizer locationInView:self.toDoTableView];
            NSIndexPath *swipeIndex = [self.toDoTableView indexPathForRowAtPoint:swipeLocation];
            [self.toDoArray removeObjectAtIndex:swipeIndex.row];

            [self.toDoTableView reloadData];
        }
    }

    if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"YOU SWIPED RIGHT");

        if (swipeGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint swipeLocation = [swipeGestureRecognizer locationInView:self.toDoTableView];
            NSIndexPath *swipeIndex = [self.toDoTableView indexPathForRowAtPoint:swipeLocation];

            UITableViewCell *swipedCell = [self.toDoTableView cellForRowAtIndexPath:swipeIndex];
            if (swipedCell.textLabel.textColor == [UIColor blackColor]) {
                swipedCell.textLabel.textColor = [UIColor whiteColor];
                swipedCell.backgroundColor = [UIColor greenColor];
            }
            else if (swipedCell.backgroundColor == [UIColor greenColor]) {
                swipedCell.backgroundColor = [UIColor yellowColor];
            }
            else if (swipedCell.backgroundColor == [UIColor yellowColor]) {
                swipedCell.backgroundColor = [UIColor redColor];
            }
            else if (swipedCell.backgroundColor == [UIColor redColor]) {
                swipedCell.textLabel.textColor = [UIColor blackColor];
                swipedCell.backgroundColor = [UIColor whiteColor];
            }

            [self.toDoTableView reloadData];
        }
    }
}
@end
