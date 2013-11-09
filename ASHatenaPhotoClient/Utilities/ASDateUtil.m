//
//  ASDateUtils.m
//  ASTwitterClient
//
//  Created by sakahara on 2013/10/05.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import "ASDateUtil.h"

@implementation ASDateUtil

+ (NSString *)parseDate:(NSString *)dateString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    // 2013-10-27T06:45:16+09:00
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssz"];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *date = [df dateFromString:dateString];
    [df setDateFormat:@"yyyy/MM/dd HH:mm"];
    return [df stringFromDate:date];
}

@end
