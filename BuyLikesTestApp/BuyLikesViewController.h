//
//  BuyLikesViewController.h
//  instalikes
//
//  Created by Ankit on 12/01/14.
//  Copyright (c) 2014 ApptitudeTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface BuyLikesViewController : UIViewController<UIAlertViewDelegate,NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *largeImageView;
@property (weak, nonatomic) IBOutlet UIButton *buyLikesButton;
@property(nonatomic,strong)id obj;

@property(nonatomic)int likesSelected;
@property(nonatomic,strong)NSString *orderID;
@property(nonatomic,strong)NSString *imageSelectedLink;

@property(nonatomic,strong)NSMutableData *receivedData;
- (IBAction)LikesCountChanged:(UISlider *)sender;
- (IBAction)buyLikesButtonTapped:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *mainView;


@property (nonatomic,assign)BOOL menuVisible;
- (IBAction)backPressd:(UIButton *)sender;


- (IBAction)buyLikesPacksTapped:(UIButton*)sender;
- (IBAction)trackOrdersTapped:(UIButton*)sender;
- (IBAction)removeAdsTapped:(UIButton*)sender;
- (IBAction)promotionsTapped:(UIButton*)sender;
- (IBAction)earnFreeCoinsTapped:(UIButton*)sender;
- (IBAction)logoutTapped:(UIButton*)sender;

@end
