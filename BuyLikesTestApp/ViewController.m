//
//  ViewController.m
//  BuyLikesTestApp
//
//  Created by Ankit on 11/01/14.
//  Copyright (c) 2014 ApptitudeTechnologies. All rights reserved.
//

#import "ViewController.h"
#import "UserInfoViewController.h"
#import "InternetCheck.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [InternetCheck sharedInstance];
    [self.loginIndicator setHidden:YES];


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginTapped:(UIButton *)sender
{
    if ([InternetCheck sharedInstance].internetWorking)
    {
        [self.loginIndicator setHidden:NO];
        [self loadWebView];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection!!" message:@"Please check your internet connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }
}

-(void)loadWebView
{
    self.loginWebView.delegate = self;
    NSString *auth = [NSString stringWithFormat:@"%@%@&redirect_uri=%@&response_type=token",KAUTHURL,KCLIENTID,kREDIRECTURI];
    NSURL *authURL = [[NSURL alloc]initWithString:auth];
    [self.loginWebView setHidden:NO];
    [self.loginIndicator setHidden:NO];
    [self.workingText setHidden:NO];
    [self.loginIndicator startAnimating];
    [self.loginWebView loadRequest:[NSURLRequest requestWithURL:authURL]];
    
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* urlString = [[request URL] absoluteString];
    NSLog(@"URL STRING : %@ ",urlString);
    NSArray *UrlParts = [urlString componentsSeparatedByString:[NSString stringWithFormat:@"%@#", kREDIRECTURI]];
    if ([UrlParts count] > 1) {
        // do any of the following here
        urlString = [UrlParts objectAtIndex:1];
        NSRange accessToken = [urlString rangeOfString: @"access_token="];
        if (accessToken.location != NSNotFound) {
            NSString* strAccessToken = [urlString substringFromIndex: NSMaxRange(accessToken)];
            // Save access token to user defaults for later use.
            // Add contant key #define KACCESS_TOKEN @”access_token” in contant //class
            [[NSUserDefaults standardUserDefaults] setValue:strAccessToken forKey: KACCESS_TOKEN]; [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"AccessToken = %@ ",strAccessToken);
            [self.loginIndicator setHidden:NO];
            [self.loginWebView setHidden:YES];
           UserInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"userInfoVC"];
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
        return NO;
    }
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.loginIndicator setHidden:YES];
    [self.workingText setHidden:YES];

}


@end
