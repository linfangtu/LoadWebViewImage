//
//  CustomisNSNull.m
//  ObjCLoadWebviewImage
//
//  Created by LinfangTu on 15/12/18.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "CustomisNSNull.h"

#define NSNullObjects @[@"",@{},@0,@[]]

@implementation CustomisNSNull

+ (CustomisNSNull *)sharedManager
{
    static CustomisNSNull *sharedCustomManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedCustomManagerInstance = [[self alloc] init];
    });
    return sharedCustomManagerInstance;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    for (NSObject *obj in NSNullObjects) {
        if ([obj respondsToSelector:aSelector]) {
            return obj;
        }
    }
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        for (NSObject *obj in NSNullObjects) {
            signature = [obj methodSignatureForSelector:aSelector];
            if (signature) {
                break;
            }
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL aSelector = [anInvocation selector];
    for (NSObject *obj in NSNullObjects) {
        if ([obj respondsToSelector:aSelector]) {
            [anInvocation invokeWithTarget:obj];
            return;
        }
    }
    return [self doesNotRecognizeSelector:aSelector];
}

@end
