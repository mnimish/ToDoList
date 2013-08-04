//
//  ViewController.m
//  ToDoList
//
//  Created by Nimish Manjarekar on 8/3/13.
//  Copyright (c) 2013 nimishm. All rights reserved.
//

#import "ViewController.h"
#import "InLineEditTableViewCell.h"

@interface ViewController ()

- (void) onAddButton;
- (void) onAddDoneButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.list = [[NSMutableArray alloc] initWithObjects:@"One", @"Two", @"Three", @"Four", nil];
    
    self.title = @"To Do List";
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(onAddButton)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void) onAddButton {
    [self.list insertObject:@"" atIndex: 0];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexpath] withRowAnimation: UITableViewRowAnimationFade];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
    UITextField *textField = cell.contentView.subviews[0];
    textField.userInteractionEnabled = YES;
    self.tableView.userInteractionEnabled = NO;
    [textField becomeFirstResponder];
    //Hack to make initial cursor size same as the font size
    textField.text = @"";
}

- (void) onAddDoneButton {
    [self.view endEditing:YES];
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
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, (cell.contentView.bounds.size.height-30)/2, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height)];
        [textField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [textField setAutocorrectionType: UITextAutocorrectionTypeNo];
        [cell.contentView addSubview:textField];
        textField.delegate = self;
        textField.userInteractionEnabled = NO;
        textField.tag = indexPath.row;
        textField.text = [self.list objectAtIndex:indexPath.row];
    }
//  cell.textLabel.text = self.list[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.list removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
    } else if(editingStyle == UITableViewCellEditingStyleInsert){
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
        [super setEditing:editing animated: YES];
        [self.tableView setEditing:editing animated: YES];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *temp = self.list[fromIndexPath.row];
    self.list[fromIndexPath.row] = self.list[toIndexPath.row];
    self.list[toIndexPath.row] = temp;
}

#pragma mark -UITextField delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action: @selector(onAddDoneButton)];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(onAddButton)];
    if([textField.text length] != 0) {
        textField.userInteractionEnabled = NO;
        self.list[0] = textField.text;
    } else {
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
