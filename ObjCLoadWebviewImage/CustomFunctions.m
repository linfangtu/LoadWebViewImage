//
//  CustomFunctions.m
//  ObjCLoadWebviewImage
//
//  Created by LinfangTu on 15/12/18.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "CustomFunctions.h"


@implementation CustomFunctions

+ (CustomFunctions *)sharedManager
{
    static CustomFunctions *sharedCustomManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedCustomManagerInstance = [[self alloc] init];
    });
    return sharedCustomManagerInstance;
}



@end
