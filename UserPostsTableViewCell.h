//
//  UserPostsTableViewCell.h
//  Application-Test
//
//  Created by Spandana Nayakanti on 12/18/16.
//  Copyright © 2016 Spandana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPostsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblForUserName;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewForUserAvatar;
@property (strong, nonatomic) IBOutlet UILabel *lblForUserPostText;

@end
