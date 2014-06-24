//
//  TimelineViewController.h
//  AppDotNetClient
//
//  Created by Anson Brown on 6/24/14.
//  Copyright (c) 2014 Anson Brown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIKit+AFNetworking/UIImageView+AFNetworking.h"
#import "Post.h"

static NSString * const timelineURL = @"https://alpha-api.app.net/stream/0/posts/stream/global";

@interface TimelineViewController : UITableViewController

@property (nonatomic, copy) NSDictionary *timeline;
@property (nonatomic, strong) NSMutableArray *posts;

@end
