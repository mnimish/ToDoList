//
//  ViewController.m
//  ToDoList
//
//  Created by Nimish Manjarekar on 8/3/13.
//  Copyright (c) 2013 nimishm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void) onAddButton;
- (void) showHideEditButton:(BOOL) show;
- (void) showHideAddButton:(BOOL) show;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.list = [[NSMutableArray alloc] initWithObjects:@"Finish Homework", @"Work on group project", nil];
    
    self.title = @"To Do List";
    
    [self showHideEditButton:YES];
    [self showHideAddButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void) onAddButton {
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    UITextField *textField = cell.contentView.subviews[0];
    if([textField.text length] !=0 && textField.editing) {
        [self.view endEditing:YES];
    }
    
    if(cell == nil || [textField.text length] !=0) {
    //Add table cell and make it editable
        [self.list insertObject:@"" atIndex: 0];
        [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation: UITableViewRowAnimationFade];
        cell = [self.tableView cellForRowAtIndexPath:indexpath];
        textField = cell.contentView.subviews[0];
        textField.userInteractionEnabled = YES;
        //self.tableView.userInteractionEnabled = NO;
        [textField becomeFirstResponder];
        //Hack to make initial cursor size same as the font size
        textField.text = @"";
        //Show table edit btn if hidden
        [self showHideEditButton:YES];
    }
}

- (void) showHideEditButton:(BOOL) show {
    if(show) {
        if(self.navigationItem.leftBarButtonItem == nil)
            self.navigationItem.leftBarButtonItem = self.editButtonItem;
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void) showHideAddButton:(BOOL) show {
    if(show) {
        if(self.navigationItem.rightBarButtonItem == nil)
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(onAddButton)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITextField *textField = nil;
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(15, (cell.contentView.bounds.size.height-30)/2, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height)];
        [textField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [textField setAutocorrectionType: UITextAutocorrectionTypeNo];
        [cell.contentView addSubview:textField];
        textField.delegate = self;
        textField.userInteractionEnabled = NO;
        textField.tag = indexPath.row;
        textField.text = [self.list objectAtIndex:indexPath.row];
    } else {    //Assign cell tag
        textField = cell.contentView.subviews[0];
        textField.tag = indexPath.row;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UITextField *textField = cell.contentView.subviews[0];
        //Add this tag to indicate that the corresponding cell is deleted. We need to check that in textFieldDidEndEditing
        textField.tag = -1;
        [self.list removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
        if(![self.list count]) {
            [super setEditing:NO animated: YES];
            [self.tableView setEditing:NO animated: YES];
            [self showHideAddButton:YES];
            [self showHideEditButton:NO];
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated: YES];
    [self.tableView setEditing:editing animated: YES];
    
    //Hide/show add button on edit
    if(editing) {
        [self showHideAddButton:NO];
    } else {
        [self showHideAddButton:YES];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *temp = self.list[fromIndexPath.row];
    self.list[fromIndexPath.row] = self.list[toIndexPath.row];
    self.list[toIndexPath.row] = temp;
}

#pragma mark -UITextField delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([textField.text length] != 0) {
        textField.userInteractionEnabled = NO;
        self.list[0] = textField.text;
    } else if(textField.tag != -1){ //Dont delete is again it's already deleted using table delete op
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.list removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
