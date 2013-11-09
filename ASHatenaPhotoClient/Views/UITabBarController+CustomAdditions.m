//
//  UITabBarController+CustomAdditions.m
//  ASHatenaPhotoClient
//
//  Created by sakahara on 2013/11/07.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import "UITabBarController+CustomAdditions.h"

@implementation UITabBarController (CustomAdditions)

- (BOOL)isTabBarHidden
{
    return CGRectGetMaxY([UIScreen mainScreen].applicationFrame) < CGRectGetMaxY(self.view.frame);
}

- (void)setTabBarHidden:(BOOL)tabBarHidden
{
    [self setTabBarHidden:tabBarHidden animated:NO];
}

- (void)setTabBarHidden:(BOOL)hidden
               animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.0
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction |
                                 UIViewAnimationOptionLayoutSubviews |
                                 UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         
                         CGRect frame = [UIScreen mainScreen].bounds;
                         if (hidden) {
                             frame.size.height += self.tabBar.frame.size.height;
                         }
                         self.view.frame = frame;
                     }
                     completion:NULL];
}

@end
