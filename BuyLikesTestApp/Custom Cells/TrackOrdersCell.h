//
//  TrackOrdersCell.h
//  instalikes
//
//  Created by Ankit on 12/01/14.
//  Copyright (c) 2014 ApptitudeTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackOrdersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *orderImage;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *likesRequested;
@property (weak, nonatomic) IBOutlet UILabel *orderID;

@end
