//
//  UITabBarController+CustomAdditions.h
//  ASHatenaPhotoClient
//
//  Created by sakahara on 2013/11/07.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITabBarController (CustomAdditions)

- (BOOL)isTabBarHidden;

- (void)setTabBarHidden:(BOOL)tabBarHidden;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
