//
//  BuyLikesViewController.m
//  instalikes
//
//  Created by Ankit on 12/01/14.
//  Copyright (c) 2014 ApptitudeTechnologies. All rights reserved.
//

#import "BuyLikesViewController.h"
#import "InternetCheck.h"
#import "TrackOrdersViewController.h"

@interface BuyLikesViewController ()
{
    NSMutableArray *ordersArray;
}
@end

@implementation BuyLikesViewController

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
	// Do any additional setup after loading the view.
    ordersArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ordersArray"]];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void)
    {
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[self.obj objectForKey:@"images"]objectForKey:@"standard_resolution"]objectForKey:@"url"]]];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self.largeImageView setImage:[UIImage imageWithData:imageData]];
                       });
    });
    self.likesSelected = 400;

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

- (IBAction)LikesCountChanged:(UISlider *)sender
{
    [self.buyLikesButton setTitle:[NSString stringWithFormat:@"Buy %d likes",(int)sender.value*100] forState:UIControlStateNormal];
    self.likesSelected = (int)sender.value * 100;
}
- (IBAction)buyLikesButtonTapped:(UIButton *)sender
{

    [[[UIAlertView alloc]initWithTitle:@"Confirm Purchase" message:[NSString stringWithFormat:@"You are about to buy a %d likes for this picture.Please confirm your purchase.",self.likesSelected] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Buy", nil]show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //calling post
        
        if ([InternetCheck sharedInstance].internetWorking)
        {
        NSURL *aUrl = [NSURL URLWithString:@"http://bulkandcheap.com/api.php"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        timeoutInterval:60.0];
        
              [request setHTTPMethod:@"POST"];
        NSString *postString = [NSString stringWithFormat:@"key=80d9a7647838729ea780126c61cd7592&action=add&link=%@&type=1125&quantity=%d",[self.obj objectForKey:@"link"],self.likesSelected];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection!!" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }

        
        }
        else
        {
            UIAlertView *regretalert =[[UIAlertView alloc]initWithTitle:@"Regret" message:@"Purchase Was not Confirmed." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [regretalert show];
            
        }
}

#pragma NSURLConnection Delegates

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if (!self.receivedData)
    {
        self.receivedData = [NSMutableData data];
    }
    else
        [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSString *responseString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
    if (![responseString isEqualToString:@""] )
    {
        NSError *error =nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
        if (error)
        {
            NSLog(@"Error %@",[error localizedDescription]);
        }
        else
        self.orderID =[dictionary objectForKey:@"id"];
            [[[UIAlertView alloc]initWithTitle:@"Order Received" message:[NSString stringWithFormat:@"Your order id is  %@",self.orderID] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]show];
        NSMutableDictionary *infodict = [[NSMutableDictionary alloc]init];
        [infodict removeAllObjects];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^(void)
                       {
                           NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[self.obj objectForKey:@"images"]objectForKey:@"thumbnail"]objectForKey:@"url"]]];
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              [infodict setObject:imageData forKey:@"imagedata"];
                                              [infodict setObject:[NSNumber numberWithInt:self.likesSelected] forKey:@"likes"];
                                              [infodict setObject:self.orderID forKey:@"orderid"];
                                              [ordersArray addObject:infodict];
                                              [[NSUserDefaults standardUserDefaults] setObject:ordersArray forKey:@"ordersArray"];
                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                          });
                       });
        
       
    }
    else
    {
        UIAlertView *regretalert =[[UIAlertView alloc]initWithTitle:@"Regret" message:@"Order was not received." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [regretalert show];
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Fail..
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error ", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
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
            self.mainView.frame = CGRectMake(0, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height);
            
        }completion:^(BOOL finished){
            
        }];
        
    }
    else
    {
        self.menuVisible = !self.menuVisible;
        
        [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^(void){
            self.mainView.frame = CGRectMake(140, self.mainView.frame.origin.y, self.mainView.frame.size.width, self.mainView.frame.size.height);
            
        }completion:^(BOOL finished){
            
        }];
    }
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
- (IBAction)backPressd:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
