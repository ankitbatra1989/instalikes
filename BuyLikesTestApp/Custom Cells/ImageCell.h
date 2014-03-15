//
//  ImageCell.h
//  BuyLikesTestApp
//
//  Created by Ankit on 11/01/14.
//  Copyright (c) 2014 ApptitudeTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageSelectedDelegate <NSObject>
-(void)imageSelectedWithTag:(int)tag;
@end

@interface ImageCell : UITableViewCell
{
    __unsafe_unretained id <ImageSelectedDelegate> delegate;

}
@property (nonatomic, assign) id <ImageSelectedDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgFirst;
@property (weak, nonatomic) IBOutlet UIImageView *bgsecong;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@end
