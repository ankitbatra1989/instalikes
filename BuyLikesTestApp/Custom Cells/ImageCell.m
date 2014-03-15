//
//  ImageCell.m
//  BuyLikesTestApp
//
//  Created by Ankit on 11/01/14.
//  Copyright (c) 2014 ApptitudeTechnologies. All rights reserved.
//


#import "ImageCell.h"

@implementation ImageCell
@synthesize delegate = _delegate;

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


- (IBAction)firstButtonTapped:(UIButton *)sender
{
    [self.delegate imageSelectedWithTag:self.firstButton.tag];
}
- (IBAction)secondButtonTapped:(id)sender
{
        [self.delegate imageSelectedWithTag:self.secondButton.tag];
}
@end
