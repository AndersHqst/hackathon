//
//  StreamTableViewController.m
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import "StreamTableViewController.h"
#import "Post.h"
#import "ECMLib.h"
#import "StreamTableViewCell.h"
#import "NSDate+Additions.h"
#import "ChatViewController.h"

@interface StreamTableViewController ()
@property (nonatomic, strong)NSArray *posts;
@property (nonatomic, strong)NSOperationQueue *queue;
@end

@implementation StreamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:@"StreamTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"StreamTableViewCell"];
    
    self.queue = [[NSOperationQueue alloc] init];
    
    ECMLabel *titleView = [ECMLabel initNavigationTitleLabel:@""];
    titleView.text = @"Feed";
    self.navigationItem.titleView = titleView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://econ-ios-proxy.staging.e-conomic.ws/feed"]];
    [NSURLConnection sendAsynchronousHTTPRequest:request queue:self.queue completionHandler:^(NSHTTPURLResponse *response, id responseObject, NSError *error){
        if(response.SUCCESS) {
            NSArray *posts = [Post arrayOfModelsFromDictionaries:responseObject];
            self.posts = [posts sortedArrayUsingComparator:^NSComparisonResult(Post *post1, Post *post2) {
                return [post2.date compare:post1.date];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"failed to fetch users! %@", response);
        }
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 146.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.posts count] == 0){
        self.tableView.hidden = YES;
        return 0;
    }
    self.tableView.hidden = NO;
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StreamTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StreamTableViewCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Post *post = self.posts[indexPath.row];
    
    NSString *dateString = [post.date shortFormat];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:dateString];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor ecm_orange] range:NSMakeRange(0, dateString.length)];
    
    cell.dateLabel.attributedText = attr;
    
    NSString *postType = nil;
    if([post.type isEqualToString:@"facebook"]){
        postType = @"facebook";
    } else {
        postType = @"blog";
    }
    NSMutableAttributedString *authorString = [[NSMutableAttributedString alloc] initWithString:postType];
    [authorString addAttribute:NSForegroundColorAttributeName value:[UIColor ecm_blue] range:NSMakeRange(0, postType.length)];
    cell.authorLabel.attributedText = authorString;
    NSString *text = nil;
    if(post.title.length < 110) {
        text = [post.title stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    } else {
        text = [[[post.title substringToIndex:110] stringByAppendingString:@"..."] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    }
    cell.descriptionLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = self.posts[indexPath.row];
    ChatViewController *cvc = [[ChatViewController alloc] initWithPost:post];
    [self.navigationController pushViewController:cvc animated:YES];
}

@end
