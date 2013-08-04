//
//  ViewController.h
//  ToDoList
//
//  Created by Nimish Manjarekar on 8/3/13.
//  Copyright (c) 2013 nimishm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *list;

@end
