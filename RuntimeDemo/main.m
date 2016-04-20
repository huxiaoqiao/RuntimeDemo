//
//  main.m
//  RuntimeDemo
//
//  Created by huxiaoqiao on 16/4/20.
//  Copyright © 2016年 huxiaoqiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "XiaoMing.h"
#import "XiaoMing+MutipleName.h"

void guessAnswer(id self, SEL _cmd){
    NSLog(@"He is from Guangdong");
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        /*runtime应用场景一：动态变量控制
         sense:
         Teacher: What's your name?
         XiaoMing: My name is XiaoMing.
         Teacher: Pardon?
         XiaoMing: My name is __
         */
        
        
        XiaoMing *xiaoming = [[XiaoMing alloc] init];
        xiaoming.englishName = @"XiaoMing";
        
        NSLog(@"XiaoMing first answer is %@",xiaoming.englishName);
        
        unsigned int count = 0;
        //动态获取XiaoMing类中的所有属性[包括私有]
        Ivar *ivar = class_copyIvarList([xiaoming class], &count);
        
        for (int i = 0; i < count; i ++) {
            Ivar var = ivar[i];
            const char *varName = ivar_getName(var);
            
            NSString *name = [NSString stringWithUTF8String:varName];
            
            if ([name isEqualToString:@"_englishName"]) {
                object_setIvar(xiaoming, var, @"MingGo");
                break;
            }
            
        }
        
        NSLog(@"XiaoMing's second answer is %@",xiaoming.englishName);
        
        /*runtime应用场景二：动态交换方法
         sense:
         Teacher: What's your name?
         XiaoMing: My name is XiaoMing.
         Teacher: Pardon?
         XiaoMing: My name is __
         */

        
        [xiaoming firstSay];
        //动态找到firstSay和secondSay方法
        
        Method m1 = class_getInstanceMethod([xiaoming class], @selector(firstSay));
        Method m2 = class_getInstanceMethod([xiaoming class], @selector(secondSay));
        //交换两个方法
        method_exchangeImplementations(m1, m2);
        [xiaoming firstSay];
        
        /*runtime应用场景三：动态添加方法
         sense:
         Teacher: Where is LiLei from?
         XiaoMing: I don't know.
         Teacher: Guess?.
         LiHua: He is from __
         */

        
        //动态给XiaoMing类添加guess方法
         /*
          (IMP)guessAnswer 意思是guessAnswer的地址指针;
          "v@:" 意思是，v代表无返回值void，如果是i则代表int；@代表 id sel; : 代表 SEL _cmd;
          “v@:@@” 意思是，两个参数的没有返回值
          */
        class_addMethod([xiaoming class], @selector(guess), (IMP)guessAnswer, "v@:");
        
        if ([xiaoming respondsToSelector:@selector(guess)]) {
            //调用guess方法响应事件
            [xiaoming performSelector:@selector(guess)];
        }else{
            NSLog(@"Sorry,I don't know");
        }
        
        
        xiaoming.chineseName = @"小明";
        NSLog(@"XiaoMing:My Chinese name is %@",xiaoming.chineseName);
        
        
        
        
        
    }
    return 0;
}
