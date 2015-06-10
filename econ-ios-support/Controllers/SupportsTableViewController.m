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
    s.initials = @"AHK";
//    s.image = @"https://media.licdn.com/mpr/mpr/shrinknp_400_400/p/3/000/0fd/11b/165c912.jpg";
    s.skills = @[@"programming", @"flying", @"Test automation", @"Shopping for belts", @"Owl stretching", @"Building canons", @"Being naked", @"Eating candy", @"Hijacking in general"];
    s.about = @"Dette er en tekst om Anders Dette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om AndersDette er en tekst om Anders";
    s.nickName = @"Anders and";
    s.background = @"EDB på mobil telefoner";
    s.country = @"no";
    
    self.supporters = @[s];
    
    ECMLabel *titleView = [ECMLabel initNavigationTitleLabel:@""];
    titleView.text = @"Heroes";
    self.navigationItem.titleView = titleView;
    
    self.navigationItem.title = @"Heroes";
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
    cell.skillsLabel.attributedText = [s attributedStringForSkills];
    UIImage *image = [UIImage imageNamed:[s.initials stringByAppendingString:@".png"]];
    if(!image) {
        image = [UIImage imageNamed:[s.initials stringByAppendingString:@".jpg"]];
    }
    cell.image.image = image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.navigationItem.hidesBackButton = YES;
    Supporter *s = self.supporters[indexPath.row];
    SupportDetailViewController *sdvc = [[SupportDetailViewController alloc] initWithSupporter:s];
    [self.navigationController pushViewController:sdvc animated:YES];
}

@end
