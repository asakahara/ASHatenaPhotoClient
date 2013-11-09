//
//  ASPhotoListFetcher.h
//  ASHatenaPhotoClient
//
//  Created by rumi on 2013/11/02.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ASPhotoListFetcher : NSObject

- (void)beginFetchPopularPhotoList:(void (^)(NSDictionary *result, NSError *error)) completionHandler;

- (void)beginFetchNewPhotoList:(int)currentPage completionHandler:(void (^)(NSDictionary *result, NSError *error)) completionHandler;

@end
