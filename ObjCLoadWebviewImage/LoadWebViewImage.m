//
//  LoadWebViewImage.m
//  ObjCLoadWebviewImage
//
//  Created by LinfangTu on 15/12/18.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "LoadWebViewImage.h"
#import <CommonCrypto/CommonDigest.h>
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"

@implementation LoadWebViewImage

+ (LoadWebViewImage *)sharedManager
{
    static LoadWebViewImage *sharedImageManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedImageManagerInstance = [[self alloc] init];
    });
    return sharedImageManagerInstance;
}

- (void)loadImageWithHtmlContent:(NSString *)htmlContont webView:(UIWebView *)webView baseUrl:(NSURL *)url {
    htmlString = htmlContont;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<img[^>]+?src=[\"']?([^>'\"]+)[\"']?" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:htmlContont options:NSMatchingReportCompletion range:NSMakeRange(0, htmlContont.length)];
    
    NSMutableDictionary *urlDicts = [[NSMutableDictionary alloc] init];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [htmlContont substringWithRange:[item rangeAtIndex:0]];
        NSLog(@"获取到的image信息：%@", imgHtml);
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@" src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@" src=\""];
        } else if ([imgHtml rangeOfString:@" src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@" src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                
                NSLog(@"正确解析出来的SRC为：%@", src);
                if (src.length > 0) {
                    NSString *localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
                    // 先将链接取个本地名字，且获取完整路径
                    [urlDicts setObject:localPath forKey:src];
                }
            }
        }
    }
    
    // 遍历所有的URL，替换成本地的URL，并异步获取图片
    for (NSString *src in urlDicts.allKeys) {
        NSString *localPath = [urlDicts objectForKey:src];
        
        // 如果已经缓存过，就不需要重复加载了。
        if (![[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
            [self downloadImageWithUrl:src];
        }
        else {
            htmlContont = [htmlContont stringByReplacingOccurrencesOfString:src withString:localPath];
        }
    }
    
    
    [webView loadHTMLString:htmlContont baseURL:url];
    
}

- (void)downloadImageWithUrl:(NSString *)src {
    // 注意：这里并没有写专门下载图片的代码，就直接使用了AFN的扩展，只是为了省麻烦而已。
    UIImageView *imgView = [[UIImageView alloc] init];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
    [imgView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        NSData *data = UIImagePNGRepresentation(image);
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *localPath = [docPath stringByAppendingPathComponent:[self md5:src]];
        
        if (![data writeToFile:localPath atomically:NO]) {
            NSLog(@"写入本地失败：%@", src);
        }
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"download image url fail: %@", src);
    }];
    
    if (imageViews == nil) {
        imageViews = [[NSMutableArray alloc] init];
    }
    [imageViews addObject:imgView];

}

- (NSString *)md5:(NSString *)sourceContent {
    if (self == nil || [sourceContent length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([sourceContent UTF8String], (int)[sourceContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
    
}


@end
