//
//  ASListViewCell.h
//  ASTumblrClient
//
//  Created by sakahara on 2013/10/20.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASListViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *listImageView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UILabel *userIdLabel;

@end
