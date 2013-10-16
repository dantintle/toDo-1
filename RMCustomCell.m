//
//  RMCustomCell.m
//  toDo
//
//  Created by Robert Manson on 10/13/13.
//  Copyright (c) 2013 Robert Manson. All rights reserved.
//

#import "RMCustomCell.h"

@implementation RMCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
