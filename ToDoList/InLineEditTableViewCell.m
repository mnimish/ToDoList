//
//  InLineEditTableViewCell.m
//  ToDoList
//
//  Created by Nimish Manjarekar on 8/4/13.
//  Copyright (c) 2013 nimishm. All rights reserved.
//

#import "InLineEditTableViewCell.h"

@implementation InLineEditTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(0,10,125,25)];
        myTextField.adjustsFontSizeToFitWidth = NO;
        myTextField.backgroundColor = [UIColor clearColor];
        myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        myTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        myTextField.keyboardType = UIKeyboardTypeDefault;
        myTextField.returnKeyType = UIReturnKeyDone;
        myTextField.clearButtonMode = UITextFieldViewModeNever;
        self.propertyTextField = myTextField;
        self.accessoryView = myTextField;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
