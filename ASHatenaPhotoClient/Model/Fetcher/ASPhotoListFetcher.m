//
//  ASPhotoListFetcher.m
//  ASHatenaPhotoClient
//
//  Created by rumi on 2013/11/02.
//  Copyright (c) 2013年 Mocology. All rights reserved.
//

#import "ASPhotoListFetcher.h"
#import "GTMHTTPFetcher.h"
#import "DDXMLDocument.h"
#import "DDXMLElement+Dictionary.h"
#import "GTMMIMEDocument.h"
#import "GTMHTTPFetcherService.h"

@implementation ASPhotoListFetcher

- (void)beginFetchPopularPhotoList:(void (^)(NSDictionary *result, NSError *error)) completionHandler {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:@"http://f.hatena.ne.jp/hotfoto?mode=rss"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    [request addValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    
    GTMHTTPFetcher* fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        
        NSDictionary *xml = nil;
        if (!error) {
            DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:&error];
            
            if (!error) {
                xml = [doc.rootElement convertDictionary];
                
            } else {
                NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
            }
        }
        
        if (completionHandler) {
            completionHandler(xml, error);
        }
    }];
}

- (void)beginFetchNewPhotoList:(int)currentPage completionHandler:(void (^)(NSDictionary *result, NSError *error)) completionHandler
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:
                                     [NSString stringWithFormat:
                                      @"http://f.hatena.ne.jp/userlist?mode=rss&page=%d", currentPage]]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    [request addValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    
    GTMHTTPFetcher* fetcher = [GTMHTTPFetcher fetcherWithRequest:request];
    
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        
        NSDictionary *xml = nil;
        if (!error) {
            DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:data options:0 error:&error];
            
            if (!error) {
                xml = [doc.rootElement convertDictionary];
                
            } else {
                NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
            }
        }
        
        if (completionHandler) {
            completionHandler(xml, error);
        }
    }];
}

@end
