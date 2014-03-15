//
//  UserInfoViewController.h
//  BuyLikesTestApp
//
//  Created by Ankit on 11/01/14.
//  Copyright (c) 2014 ApptitudeTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCell.h"

@interface UserInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ImageSelectedDelegate>

@property (weak, nonatomic) IBOutlet UIView *userInfoView;
@property (weak, nonatomic) IBOutlet UIImageView *coverPicImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profilepicImageView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userType;
@property (weak, nonatomic) IBOutlet UITableView *photosTableView;
@property (nonatomic,strong)NSString *userid;
@property (nonatomic,strong)NSString *accToken;
@property (nonatomic,strong)NSMutableArray *pictureArray;
@property (nonatomic,assign)BOOL menuVisible;

- (IBAction)buyLikesPacksTapped:(UIButton*)sender;
- (IBAction)trackOrdersTapped:(UIButton*)sender;
- (IBAction)removeAdsTapped:(UIButton*)sender;
- (IBAction)promotionsTapped:(UIButton*)sender;
- (IBAction)earnFreeCoinsTapped:(UIButton*)sender;
- (IBAction)logoutTapped:(UIButton*)sender;




@end
