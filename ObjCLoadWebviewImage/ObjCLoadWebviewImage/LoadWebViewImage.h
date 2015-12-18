//
//  LoadWebViewImage.h
//  ObjCLoadWebviewImage
//
//  Created by LinfangTu on 15/12/18.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LoadWebViewImage : NSObject {
    NSString *htmlString;
    NSMutableArray *imageViews;
}

+ (LoadWebViewImage *)sharedManager;

- (void)loadImageWithHtmlContent:(NSString *)htmlContont webView:(UIWebView *)webView baseUrl:(NSURL *)url;

@end
