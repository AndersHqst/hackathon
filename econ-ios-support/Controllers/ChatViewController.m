//
//  ChatViewController.m
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import "ChatViewController.h"
#import "ECMLib.h"
#import "UIView+HUD.h"
#import <Masonry.h>

@interface ChatViewController ()
@property (nonatomic, strong)UIWebView *webView;
@end

@implementation ChatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationItem.leftBarButtonItem = [[ECMBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_top_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (!self.webView) {
        ECMLabel *titleLabel = [[ECMLabel alloc] init];
        titleLabel.text = @"Chat";
        self.navigationItem.titleView = titleLabel;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        self.webView.delegate = self;
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.alpha = .0;
        [self.view addSubview:self.webView];
        [self.view showHUD];
        
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        NSURL *url = [NSURL URLWithString:@"https://liveguide01eu.netop.com/lg/engine/sources/swf.php?LiveGuideUID=lgW9JHrdb73ZwHkMd2Cg0b&myurl=Email&title=Email&LiveGuideCIDuration=&LiveGuideCIRef=&LiveGuideCITitle=&LiveGuideCIUrl="];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
        [request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
        [self.webView loadRequest:request];
        
        //    [[ECMUser user] requestNewTokenIfNeeded:^{
        //        [request setValue:kECMPrivateAppId forHTTPHeaderField:@"appId"];
        //        [request setValue:[[ECMUser user] requestToken] forHTTPHeaderField:@"accessId"];
        //
        //        // Allow zoom
        //        self.webView.scalesPageToFit = YES;
        //
        //        [self.webView loadRequest:request];
        //    }];
        

    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)dealloc {
    [_webView setDelegate:nil];
    [_webView stopLoading];
}

#pragma mark - Clean up

// Removed black border around PDF on iOS 8.
// This is on the edge of App Store policy,
// but technically we do not use private API.
// The code does not break if Apple changes it.
- (void)cleanUpPDFView {
    for (UIView *subview in self.webView.subviews) {
        for (UIView *view in subview.subviews) {
            if ([NSStringFromClass([view class]) isEqualToString:@"UIWebPDFView"]) {
                view.backgroundColor = [UIColor whiteColor];
            }
        }
    }
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view hideHUD];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.view hideHUD];
    // Do this only on iOS 8.
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [self performSelector:@selector(cleanUpPDFView) withObject:nil afterDelay:.1];
    }
    // Fade in web view
    [UIView animateWithDuration:1.0
                          delay:.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.webView.alpha = 1.0;
                     } completion:nil];
}

@end
