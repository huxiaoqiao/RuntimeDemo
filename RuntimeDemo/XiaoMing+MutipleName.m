//
//  XiaoMing+MutipleName.m
//  RuntimeDemo
//
//  Created by huxiaoqiao on 16/4/20.
//  Copyright © 2016年 huxiaoqiao. All rights reserved.
//

#import "XiaoMing+MutipleName.h"
#import <objc/runtime.h>

@implementation XiaoMing (MutipleName)

char cName;
//动态添加属性和方法
- (void)setChineseName:(NSString *)chineseName{
    objc_setAssociatedObject(self, &cName, chineseName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)chineseName{
   return  objc_getAssociatedObject(self, &cName);
}

@end
