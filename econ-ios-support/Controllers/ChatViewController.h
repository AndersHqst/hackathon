//
//  ChatViewController.h
//  econ-ios-support
//
//  Created by Anders Høst Kjærgaard on 10/06/15.
//  Copyright (c) 2015 e-conomic International A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface ChatViewController : UIViewController<UIWebViewDelegate>
- (id)initWithUrl:(NSString *)string;
- (id)initWithPost:(Post *)post;
@end
