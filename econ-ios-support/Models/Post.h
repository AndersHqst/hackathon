//
//  Post.h
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import "JSONModel.h"

@interface Post : JSONModel
@property (nonatomic, strong)NSString<Optional> *title;
@property (nonatomic, strong)NSDate<Optional> *date;
@property (nonatomic, strong)NSString<Optional> *author;
@property (nonatomic, strong)NSString<Optional> *link;
@property (nonatomic, strong)NSString<Optional> *desc;
@property (nonatomic, strong)NSString<Optional> *type; //blog|facebook
@end
