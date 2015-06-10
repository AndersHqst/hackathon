//
//  SupportsTableViewController.m
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import "SupportsTableViewController.h"
#import "Supporter.h"
#import "SupportDetailViewController.h"
#import "SupporterTableViewCell.h"
#import "ECMLib.h"
#import "SupportDetailViewController.h"

@interface SupportsTableViewController ()
@property (nonatomic, strong)NSArray *supporters;
@property (nonatomic, strong)NSOperationQueue *queue;
@property (nonatomic, strong)NSMutableDictionary *cache;
@end

@implementation SupportsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cache = [@{} mutableCopy];
    
    UINib *nib = [UINib nibWithNibName:@"SupporterTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"SupporterTableViewCell"];
    self.queue = [[NSOperationQueue alloc] init];

    self.supporters = @[];
    ECMLabel *titleView = [ECMLabel initNavigationTitleLabel:@""];
    titleView.text = @"Heroes";
    self.navigationItem.titleView = titleView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://econ-ios-proxy.staging.e-conomic.ws/users"]];
    [NSURLConnection sendAsynchronousHTTPRequest:request queue:self.queue completionHandler:^(NSHTTPURLResponse *response, id responseObject, NSError *error){
        if(response.SUCCESS) {
            self.supporters = [Supporter arrayOfModelsFromDictionaries:responseObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"failed to fetch users! %@", response);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 146.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.supporters count] == 0){
        self.tableView.hidden = YES;
        return 0;
    }
    self.tableView.hidden = NO;
    return [self.supporters count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SupporterTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SupporterTableViewCell"];
    
    Supporter *s = self.supporters[indexPath.row];
    cell.nameLabel.text = s.name;
    cell.skillsLabel.attributedText = [s attributedStringForSkills];
    cell.flagView.image = [SupportDetailViewController supporterFlag:s];

    cell.image.image = [self imageForSupporter:s];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.hidesBackButton = YES;
    Supporter *s = self.supporters[indexPath.row];
    SupportDetailViewController *sdvc = [[SupportDetailViewController alloc] initWithSupporter:s];
    [self.navigationController pushViewController:sdvc animated:YES];
}

- (UIImage *)imageForSupporter:(Supporter *)supporter {
    // CHeck .png
    NSString *pngImage = [supporter.initials stringByAppendingString:@".png"];
    if(self.cache[pngImage]) {
        return self.cache[pngImage];
    }
    // load
    UIImage *image = [UIImage imageNamed:pngImage];
    if(image) {
        self.cache[pngImage] = image;
        return image;
    }
    
    // CHeck .jpg
    NSString *jpgImage = [supporter.initials stringByAppendingString:@".jpg"];
    
    if(self.cache[jpgImage]) {
        return self.cache[jpgImage];
    }
    // load
    image = [UIImage imageNamed:jpgImage];
    if(image) {
        self.cache[jpgImage] = image;
        return image;
    }
    
    return [UIImage imageNamed:@"agent_gray_resized.png"];
}

@end
