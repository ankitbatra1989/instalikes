//
//  UserInfoViewController.m
//  BuyLikesTestApp
//
//  Created by Ankit on 11/01/14.
//  Copyright (c) 2014 ApptitudeTechnologies. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ImageCell.h"
#import "BuyLikesViewController.h"
#import "InternetCheck.h"
#import "TrackOrdersViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   [InternetCheck sharedInstance];
    [self.navigationController setNavigationBarHidden:YES];

    
	// Do any additional setup after loading the view
    [self.navigationItem setTitle:@"Magic Page"];
    [self.profilepicImageView.layer setCornerRadius:10.0];
    [self.profilepicImageView setClipsToBounds:YES];
    
        [self requestUserData];
        [self requestMedia];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.menuVisible = YES;
    [self toggleMenu];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)requestUserData {
    self.accToken = [[NSUserDefaults standardUserDefaults] valueForKey:KACCESS_TOKEN];
    self.userid = [[self.accToken componentsSeparatedByString:@"."] objectAtIndex:0];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/?access_token=%@",kAPIURl,self.userid,[[ NSUserDefaults standardUserDefaults] valueForKey:KACCESS_TOKEN]]]];
   
    if (data)
    {
        // Here you can handle response as well
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //parseuserdata
        [self parseUserInfo:dictResponse];
        }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"Sorry!!" message:@"Couldnot retrieve user." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
        
    }
}

-(void)parseUserInfo:(NSDictionary *)response
{
    NSDictionary *infodict = [response objectForKey:@"data"];
    NSString *username = [infodict objectForKey:@"username"];
    self.username.text = username;
    
    //set image
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void)
    {
        NSURL *url = [NSURL URLWithString:[infodict objectForKey:@"profile_picture"]];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        if (imageData)
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                self.profilepicImageView.image =[UIImage imageWithData:imageData];
                
            });
        }
        else
        {
            self.profilepicImageView.image = nil;
            NSLog(@"No Image");
        }
    });
    
}


-(void)requestMedia
{
    NSLog(@"%@%@/media/recent/?access_token=%@&count=-1",kAPIURl,self.userid,[[ NSUserDefaults standardUserDefaults] valueForKey:KACCESS_TOKEN]);
     NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/media/recent/?access_token=%@",kAPIURl,self.userid,[[ NSUserDefaults standardUserDefaults] valueForKey:KACCESS_TOKEN]]]];
    if (data)
    {
        // Here you can handle response as well
        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        self.pictureArray = [dictResponse objectForKey:@"data"];
        if ([dictResponse objectForKey:@"pagination"])
        {
            [self getMoreData:dictResponse];
            
        }
        if ([self.pictureArray count] == 0)
        {
            [self.photosTableView setHidden:YES];
        }
        else
        {
            [self.photosTableView setHidden:NO];

        }
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:@"Sorry!!" message:@"No Media Found." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]show];
        
    }
 
}

-(void)getMoreData:(NSDictionary *)responsedict
{
    if ([[ responsedict objectForKey:@"pagination"]objectForKey:@"next_url"])
    {

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[responsedict objectForKey:@"pagination"]objectForKey:@"next_url"]]];
    // Here you can handle response as well
    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray * moredataarray = [dictResponse objectForKey:@"data"];
    self.pictureArray = [[self.pictureArray arrayByAddingObjectsFromArray:moredataarray] mutableCopy];
    if ([dictResponse objectForKey:@"pagination"])
    {
        [self getMoreData:dictResponse];
    }
    }
}

-(IBAction)menuButtonTapped:(UIButton*)sender
{
    NSLog(@"Menu Tapped");
    [self toggleMenu];
}

-(void)toggleMenu
{
    if (self.menuVisible)
    {
        self.menuVisible = !self.menuVisible;
        [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^(void){
            self.userInfoView.frame = CGRectMake(0, self.userInfoView.frame.origin.y, self.userInfoView.frame.size.width, self.userInfoView.frame.size.height);
            
        }completion:^(BOOL finished){
            
        }];
 
    }
    else
    {
        self.menuVisible = !self.menuVisible;

        [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^(void){
        self.userInfoView.frame = CGRectMake(140, self.userInfoView.frame.origin.y, self.userInfoView.frame.size.width, self.userInfoView.frame.size.height);
        
    }completion:^(BOOL finished){
        
    }];
    }
}

#pragma mark - TableView DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.pictureArray count]%2 == 0)
    {
        return [self.pictureArray count]/2;
    }
    else
     return [self.pictureArray count]/2+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"imagecell";
    ImageCell *cell = (ImageCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell =[[ImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.firstImageView.image = nil;
    cell.secondImageView.image = nil;
    //
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.bgFirst.layer setBorderColor:[UIColor grayColor].CGColor];
    [cell.bgFirst.layer setBorderWidth:1.0];
    [cell.bgsecong.layer setBorderColor:[UIColor grayColor].CGColor];
    [cell.bgsecong.layer setBorderWidth:1.0];
    
    cell.firstButton.tag = (indexPath.row *2) +1;
    cell.secondButton.tag = (indexPath.row *2)+ 2;
    NSString *firsturl =[[[[self.pictureArray objectAtIndex:(indexPath.row *2)] objectForKey:@"images"]objectForKey:@"thumbnail"]objectForKey:@"url"];
    NSString *secondurl = nil;
    if ([self.pictureArray count] == (indexPath.row *2)+1)
    {
        if ([self.pictureArray count]%2 == 0)
        {
            secondurl =[[[[self.pictureArray objectAtIndex:((indexPath.row *2)+1)] objectForKey:@"images"]objectForKey:@"thumbnail"]objectForKey:@"url"];
        }
        
    }
    else
    {
        
        secondurl =[[[[self.pictureArray objectAtIndex:((indexPath.row *2)+1)] objectForKey:@"images"]objectForKey:@"thumbnail"]objectForKey:@"url"];
    }
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void)
    {
        NSData *firstimageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:firsturl]];
        NSData *secondimageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:secondurl]];
        UIImage* oneImage = [UIImage imageWithData:firstimageData];
        UIImage* twoImage = [UIImage imageWithData:secondimageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                if (oneImage)
                {
                    cell.firstImageView.image = oneImage;
                    [cell setNeedsLayout];
                    
                }
            if (twoImage)
            {
                cell.secondImageView.image = twoImage;
               [ cell.secondImageView setHidden:NO];
                [cell.bgsecong setHidden:NO];

                [cell setNeedsLayout];
                
            }
            else
            {
                [cell.secondImageView setHidden:YES];
                [cell.bgsecong setHidden:YES];
            }
            });
        });

    cell.delegate =self;
    return cell;
}

-(void)imageSelectedWithTag:(int)tag
{
    NSLog(@"tag : %d",tag);
    id obj = [self.pictureArray objectAtIndex:tag-1];
    BuyLikesViewController *blvc = [self.storyboard instantiateViewControllerWithIdentifier:@"buylikesvc"];
    blvc.obj = obj;
    [self.navigationController pushViewController:blvc animated:YES];
}


- (IBAction)buyLikesPacksTapped:(UIButton*)sender
{
    
}
- (IBAction)trackOrdersTapped:(UIButton*)sender
{
    TrackOrdersViewController *tOVC = [self.storyboard instantiateViewControllerWithIdentifier:@"trackordersVC"];
//    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.navigationController pushViewController:tOVC animated:YES];
    
}
- (IBAction)removeAdsTapped:(UIButton*)sender
{
    
}
- (IBAction)promotionsTapped:(UIButton*)sender
{
    
}
- (IBAction)earnFreeCoinsTapped:(UIButton*)sender
{
    
}
- (IBAction)logoutTapped:(UIButton*)sender
{
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:KACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // clear cookie
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* instagramCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://instagram.com/"]];
    for (NSHTTPCookie* cookie in instagramCookies)
    {
        [cookies deleteCookie:cookie];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
