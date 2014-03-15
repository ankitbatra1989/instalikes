//
//  TrackOrdersViewController.h
//  instalikes
//
//  Created by Ankit on 12/01/14.
//  Copyright (c) 2014 ApptitudeTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackOrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDelegate>

@property(nonatomic,strong)NSArray *ordersArray;
@property (nonatomic,assign)BOOL menuVisible;

@property(nonatomic,strong)NSMutableData *receivedData;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property(nonatomic,strong)NSString *orderStatus;

- (IBAction)buyLikesPacksTapped:(UIButton*)sender;
- (IBAction)trackOrdersTapped:(UIButton*)sender;
- (IBAction)removeAdsTapped:(UIButton*)sender;
- (IBAction)promotionsTapped:(UIButton*)sender;
- (IBAction)earnFreeCoinsTapped:(UIButton*)sender;
- (IBAction)logoutTapped:(UIButton*)sender;
- (IBAction)backPressd:(UIButton *)sender;


@end
