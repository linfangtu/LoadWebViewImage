//
//  CustomisNSNull.h
//  ObjCLoadWebviewImage
//
//  Created by LinfangTu on 15/12/18.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  NSnull类目 消息转发 解决一切null问题
 */
@interface CustomisNSNull : NSNull

+ (CustomisNSNull *)sharedManager;

@end
