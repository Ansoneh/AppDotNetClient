//
//  Post.h
//  AppDotNetClient
//
//  Created by Anson Brown on 6/24/14.
//  Copyright (c) 2014 Anson Brown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *avatarURL;

@end
