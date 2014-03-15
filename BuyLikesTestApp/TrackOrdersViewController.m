//
//  TrackOrdersViewController.m
//  instalikes
//
//  Created by Ankit on 12/01/14.
//  Copyright (c) 2014 ApptitudeTechnologies. All rights reserved.
//

#import "TrackOrdersViewController.h"
#import "TrackOrdersCell.h"

@interface TrackOrdersViewController ()

@end

@implementation TrackOrdersViewController

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
	// Do any additional setup after loading the view.
    self.ordersArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"ordersArray"];
    
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
#pragma mark - TableView DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ordersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tocell";
    TrackOrdersCell *cell = (TrackOrdersCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell =[[TrackOrdersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    [cell.orderImage.layer setCornerRadius:10.0];
    [cell.orderImage setClipsToBounds:YES];
    NSDictionary *dic =[self.ordersArray objectAtIndex:indexPath.row];
    cell.orderID.text =   [NSString stringWithFormat:@"ID :%@",[dic objectForKey:@"orderid"]];
    cell.likesRequested.text = [NSString stringWithFormat:@"%@ likes",[dic objectForKey:@"likes"]];
    [cell.orderImage setImage:[UIImage imageWithData:[dic objectForKey:@"imagedata"]]];
    //getstatus

    NSURL *aUrl = [NSURL URLWithString:@"http://bulkandcheap.com/api.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"key=80d9a7647838729ea780126c61cd7592&action=status&id=%@",[dic objectForKey:@"orderid"]];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    [cell.orderStatus setTextColor:[UIColor redColor]];
    cell.orderStatus.text =@"Unknown";
    if (self.orderStatus)
    {
        switch ([self.orderStatus intValue])
        {
            case 0:
                cell.orderStatus.text = @"Pending";
                break;
            case 1:
                cell.orderStatus.text = @"In progress";
                break;
            case 2:
                [cell.orderStatus setTextColor:[UIColor greenColor]];
                cell.orderStatus.text = @"Completed";
                break;
            case 3:
                cell.orderStatus.text = @"Partially completed";
                break;
            case 4:
                cell.orderStatus.text = @"Canceled";
                break;
            case 5:
                cell.orderStatus.text = @"Processing";
                break;
            default:
                break;
        }
    }else
    {
        cell.orderStatus.text = @"Unknown";

    }
 
    return cell;
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

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if (!self.receivedData)
    {
        self.receivedData = [NSMutableData data];
    }
    else
        [self.receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"%@",self.receivedData);
    NSError *error;

    NSString *responseString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);

    NSLog(@"Error %@",[error localizedDescription]);

    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:self.receivedData options:kNilOptions error:&error];
   
    if (error)
    {
        NSLog(@"Error %@",[error localizedDescription]);
    }
    self.orderStatus =[dictionary objectForKey:@"status"];
    NSLog(@"Status : %@",self.orderStatus);

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"%@",response);

    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // Fail..
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error ", @"")
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}


- (IBAction)buyLikesPacksTapped:(UIButton*)sender
{
    
}
- (IBAction)trackOrdersTapped:(UIButton*)sender
{
      
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
