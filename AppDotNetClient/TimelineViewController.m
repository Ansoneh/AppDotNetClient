//
//  TimelineViewController.m
//  AppDotNetClient
//
//  Created by Anson Brown on 6/24/14.
//  Copyright (c) 2014 Anson Brown. All rights reserved.
//

#import "TimelineViewController.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController

const float POST_WIDTH = 205;
const int CORNER_RADIUS = 10;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(populateCells) forControlEvents:UIControlEventValueChanged];
    
    self.posts = [[NSMutableArray alloc] init];
    
    [self populateCells];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) populateCells
{
    [self.posts removeAllObjects];
    [self.tableView reloadData];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:timelineURL]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // success
        NSLog(@"Timeline retrieved.");
        
        // grab the JSON response
        NSDictionary *timeline = (NSDictionary*) responseObject;
        NSArray *timelineData;
        
        timelineData = [timeline objectForKey:@"data"];
        
        for(NSDictionary *info in timelineData) {
            
            NSDictionary *user = [info objectForKey:@"user"];
            
            Post *timelinePost = [[Post alloc] init];
            NSDictionary *avatar = [user objectForKey:@"avatar_image"];
            timelinePost.avatarURL = [avatar objectForKey:@"url"];
            timelinePost.userName = [user objectForKey:@"username"];
            timelinePost.text = [info objectForKey:@"text"];
            
            [self.posts addObject:timelinePost];
        }
        
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // failure
        NSLog(@"Failed to retrieve timeline.");
    }];
    
    [operation start];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PostCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Post *timelinePost = (self.posts)[indexPath.row];
    
    UILabel *nameLabel = (UILabel*)[cell viewWithTag:100];
    nameLabel.text = timelinePost.userName;
    
    // resets the textLabel frame size to the same width
    UILabel *textLabel = (UILabel*)[cell viewWithTag:102];
    textLabel.text = timelinePost.text;
    [textLabel sizeToFit];
    CGRect newFrame = textLabel.frame;
    newFrame.size.width = POST_WIDTH;
    textLabel.frame = newFrame;
    
    UIImageView *avatarView = (UIImageView*)[cell viewWithTag:101];
    
    // round edges of avatars
    avatarView.layer.cornerRadius = CORNER_RADIUS;
    avatarView.clipsToBounds = YES;
    
    // uses AFNetworking to set a placeholder avatar and grab the user avatars from URL asynchronously
    [avatarView setImageWithURL:[NSURL URLWithString:timelinePost.avatarURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *timelinePost = (self.posts)[indexPath.row];
    
    // use a placeholder label to get size of text and adjust the row accordingly
    UILabel *sizingLabel = [[UILabel alloc] init];
    sizingLabel.font = [UIFont systemFontOfSize:17.0f];
    sizingLabel.text = timelinePost.text;
    sizingLabel.lineBreakMode = NSLineBreakByWordWrapping;
    sizingLabel.numberOfLines = 0;
    
    CGSize maxSize = CGSizeMake(POST_WIDTH, 9999);
    
    CGSize size = [sizingLabel sizeThatFits:maxSize];
    
    return size.height + 60;
     
}


@end
