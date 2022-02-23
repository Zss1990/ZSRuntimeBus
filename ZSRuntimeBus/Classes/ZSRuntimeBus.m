//
//  SDRuntimeBus.m
//  SKIO_K_SDRuntimeBus
//
//  Created by shuaishuai on 2021/4/29.
//

#import "ZSRuntimeBus.h"
#import <UIKit/UIKit.h>
#import "ZSRuntimeUtil.h"
#import "ZSRuntimeAdapter.h"

typedef UIStoryboard XXStoryboard;
typedef UIApplication XXApplication;

#if TARGET_OS_IOS || TARGET_OS_TV || TARGET_OS_WATCH
#define zs_HAS_UIKIT 1
#elif TARGET_OS_MAC
#define zs_HAS_UIKIT 0
#else
#error "Unsupported Platform"
#endif

static NSMutableSet<Class> *_registries;
static BOOL _autoRegister = YES;
static BOOL _registrationFinished = NO;

@interface ZSRuntimeBus ()
@property (nonatomic, class, readonly) NSMutableSet *registries;
@property (nonatomic, class) BOOL registrationFinished;
@end
@implementation ZSRuntimeBus

#pragma mark - Auto Register

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        zs_replaceMethodWithMethod([XXApplication class], @selector(setDelegate:),
                                    self, @selector(SDRRouteRegistry_hook_setDelegate:));
        zs_replaceMethodWithMethodType([XXStoryboard class], @selector(storyboardWithName:bundle:), true,
                                        self, @selector(SDRRouteRegistry_hook_storyboardWithName:bundle:), true);
    });
}

+ (void)SDRRouteRegistry_hook_setDelegate:(id)delegate {
    if (ZSRuntimeBus.autoRegister) {
        [ZSRuntimeBus busAll];
    }
    [self SDRRouteRegistry_hook_setDelegate:delegate];
}

#if zs_HAS_UIKIT
+ (UIStoryboard *)SDRRouteRegistry_hook_storyboardWithName:(NSString *)name bundle:(nullable NSBundle *)storyboardBundleOrNil
#else
+ (NSStoryboard *)SDRRouteRegistry_hook_storyboardWithName:(NSString *)name bundle:(nullable NSBundle *)storyboardBundleOrNil
#endif
{
    if (ZSRuntimeBus.autoRegister) {
        [ZSRuntimeBus busAll];
    }
    return [self SDRRouteRegistry_hook_storyboardWithName:name bundle:storyboardBundleOrNil];
}



#pragma mark  Register
/// Add registry subclass.
+ (void)addBus:(Class)busClass
{
   NSParameterAssert([busClass isSubclassOfClass:[ZSRuntimeBus class]]);
   if (_registries == nil) {
       _registries = [NSMutableSet set];
   }
   [_registries addObject:busClass];
}

#pragma mark Register calling
+ (void)handleEnumerateAdapterClass:(Class)aClass
{}
+ (void)didFinishRegistration
{}

#pragma mark Manually Register

/// Search all  bus,  when found a SDRuntimeAdapter subclass , should be  calling each Register's  +handleEnumerateAdapterClass:  , later , Registers call +didFinishRegistration.
+ (void)busAll
{
    if (self.registrationFinished) {
        return;
    }
    NSSet *registries = [[self registries] copy];
    if (zs_canEnumerateClassesInImage()) {
        // Fast enumeration
        zs_enumerateClassesInMainBundleForParentClass([ZSRuntimeAdapter class], ^(__unsafe_unretained Class  _Nonnull aClass) {
            for (Class registry in registries) {
                [registry handleEnumerateAdapterClass:aClass];
            }
        });
    } else {
        // Slow enumeration
        zs_enumerateClassList(^(__unsafe_unretained Class class) {
            for (Class registry in registries) {
                [registry handleEnumerateAdapterClass:class];
            }
        });
    }
    
    self.registrationFinished = YES;
    for (Class registry in registries) {
        [registry didFinishRegistration];
    }
}

/// Notify that registration is finished,  let Registers call +_didFinishRegistration.
+ (void)notifyAddBusFinished
{
    NSAssert(self.autoRegister == NO, @"Only use -notifyRegistrationFinished for manually registration.");
    if (_registrationFinished) {
        NSAssert(NO, @"Registration is already finished.");
        return;
    }
    self.registrationFinished = YES;
    
    NSSet *registries = [[self registries] copy];
    for (Class registry in registries) {
        [registry didFinishRegistration];
    }
}

#pragma MARK  SET
+ (void)setAutoRegister:(BOOL)autoRegister {
    if (_registrationFinished) {
        NSAssert(NO, @"Set auto register after registration is already finished.");
        return;
    }
    _autoRegister = autoRegister;
}
+ (void)setRegistrationFinished:(BOOL)registrationFinished {
    _registrationFinished = registrationFinished;
}
#pragma MARK  GET
+ (NSSet<Class> *)registries {
    return _registries;
}

+ (BOOL)autoRegister {
    return _autoRegister;
}
+ (BOOL)registrationFinished {
    return _registrationFinished;
}


@end
