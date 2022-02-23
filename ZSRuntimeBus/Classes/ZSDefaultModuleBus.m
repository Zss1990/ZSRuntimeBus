//
//  SDRDefaultModuleBus.m
//  SKIO_K_SDRuntimeBus
//
//  Created by shuaishuai on 2021/4/29.
//

#import "ZSDefaultModuleBus.h"
#import "ZSDefaultModuleAdapter.h"

@implementation ZSDefaultModuleBus


+ (void)load {
    [ZSRuntimeBus addBus:[ZSDefaultModuleBus class]];
}

+ (void)handleEnumerateAdapterClass:(Class)class {
    static Class SDRModuleAdapter_class;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SDRModuleAdapter_class = [ZSDefaultModuleAdapter class];
    });
    if (zs_classIsSubclassOfClass(class, SDRModuleAdapter_class)) {
        [class zs_appLaunching];
//        [self autoSearchAdapterMethod:class markSel:@"zs_auto"];
    }
}

+ (void)didFinishRegistration {
}


/////自动查询方法注册
//+ (void)autoSearchAdapterMethod:(Class)aClass markSel:(NSString *)markSel
//{
//    zs_enumerateClassMethodsForClass(aClass, ^(Method  _Nonnull classMethod) {
//        SEL selector = method_getName(classMethod);
//        NSString *name = NSStringFromSelector(selector);
//        int methodArgCount = method_getNumberOfArguments(classMethod);
//        if ([name hasPrefix:markSel] && (methodArgCount >= 4)) {
////        if ([name isEqualToString:@"customHander:responseCallback:"]) {
//
//            @try {
//                id arg1 = [[NSData alloc]init];
//                id arg2 = [[NSString alloc]init];
////                method_invoke(aClass,classMethod,@"");
//            } @catch (NSException *exception) {
//
//            } @finally {
//
//            }
//        }
//    });
//}

/// 自动查询方法注册
//+ (void)autoSearchBridgeAdapterMethod:(Class)aClass bridge:(WebViewJavascriptBridge *)bridge;
//{
////    aClass = [SDRDemoAdapter_A class];
//    zs_enumerateClassMethodsForClass(aClass, ^(Method  _Nonnull classMethod) {
//        SEL selector = method_getName(classMethod);
//        NSString *name = NSStringFromSelector(selector);
//        int methodArgCount = method_getNumberOfArguments(classMethod);
//        NSLog(@"+++++++>: %@ name: %@ - %d",aClass,name,methodArgCount);
//        if ([name isEqualToString:@"customHander:responseCallback:"]) {
//            NSString *name_head =  [name componentsSeparatedByString:@":"].firstObject;
////            [bridge registerHandler:name_head handler:^(id data, WVJBResponseCallback responseCallback) {
//                @try {
//                    method_invoke(aClass,classMethod,data,responseCallback);
//                } @catch (NSException *exception) {
//
//                } @finally {
//
//                }
////            }];
//        }
//
//
////        for (int i=0; i<methodArgCount; i++) {
////            NSLog(@"方法参数 %s",method_copyArgumentType(classMethod,i));
////        }
//    });
//
//}


@end
