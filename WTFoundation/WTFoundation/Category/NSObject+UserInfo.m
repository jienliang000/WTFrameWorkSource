//
//  NSObject+UserInfo.m
//  ChiXinTiYuProject
//
//  Created by cx-fu on 2018/7/26.
//  Copyright © 2018年 cx-fu. All rights reserved.
//

#import "NSObject+UserInfo.h"
#import <objc/runtime.h>
static const void *tagKey = &tagKey;
@implementation NSObject (UserInfo)

- (void)setZxUserInfo:(id)zxUserInfo {
    objc_setAssociatedObject(self, tagKey, zxUserInfo, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)zxUserInfo {
	return objc_getAssociatedObject(self, tagKey);
}
-(void)removeObjects{
    objc_removeAssociatedObjects(self);
}
@end
