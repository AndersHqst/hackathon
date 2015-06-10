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

@interface SupportsTableViewController ()
@property (nonatomic, strong)NSArray *supporters;
@end

@implementation SupportsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"SupporterTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"SupporterTableViewCell"];
    
    Supporter *s = [[Supporter alloc] init];
    s.name = @"Anders Høst kjærgaard";
    s.image = @"https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/3/000/0fd/11b/165c912.jpg";
    s.skills = @[@"programming", @"flying", @"Test automation", @"Shopping for belts", @"Owl stretching", @"Building canons", @"Being naked", @"Eating candy", @"Hijacking in general"];
    s.about = @"Dette er en tekst om Anders";
    s.nickName = @"Anders and";
    s.background = @"EDB på mobil telefoner";
    s.country = @"dk";
    
    self.supporters = @[s];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.supporters count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SupporterTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SupporterTableViewCell"];
    
    Supporter *s = self.supporters[indexPath.row];
    cell.nameLabel.text = s.name;
    cell.skillsLabel.attributedText = [self attributedStringForSkills:s];
    NSURL *imageUrl = [NSURL URLWithString:s.image];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    cell.image.image = image;
    
    return cell;
}

- (NSMutableAttributedString *)attributedStringForSkills:(Supporter *)supporter {
    NSString *skillString = [supporter.skills componentsJoinedByString:@" // "];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:skillString];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, skillString.length)];
    for(NSString *string in supporter.skills) {
        NSRange range = [skillString rangeOfString:string];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor ecm_orange] range:range];
    }

    return attr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.hidesBackButton = YES;
    Supporter *s = self.supporters[indexPath.row];
    SupportDetailViewController *sdvc = [[SupportDetailViewController alloc] initWithSupporter:s];
    [self.navigationController pushViewController:sdvc animated:YES];
}

@end
