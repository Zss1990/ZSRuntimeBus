//
//  SDRuntimeBus.h
//  SKIO_K_SDRuntimeBus
//
//  Created by shuaishuai on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import <ZSRuntimeBus/ZSRuntimeUtil.h>

NS_ASSUME_NONNULL_BEGIN

/// Abstract registry for Adapter classes . In consideration of performance, methods in registry are not thread safe.
/// This example should be needed
@interface ZSRuntimeBus : NSObject

/// Whether auto register all routers when app launches. Default is YES. You can set this to NO before UIApplicationMain, and manually register your routers with +registerAll or call +registerRoutableDestination for each router.
@property (nonatomic, class) BOOL autoRegister;
/// Whether registration is finished.
@property (nonatomic, class, readonly) BOOL registrationFinished;

#pragma mark  Register
/// Add registry subclass.
+ (void)addBus:(Class)busClass;

#pragma mark Register calling
+ (void)handleEnumerateAdapterClass:(Class)aClass;
+ (void)didFinishRegistration;

#pragma mark Manually Register

/// Search all  bus,  when found a SDRuntimeAdapter subclass , should be  calling each Register's  +handleEnumerateAdapterClass:  , later , Registers call +didFinishRegistration.
+ (void)busAll;

/// Notify that registration is finished,  let Registers call +_didFinishRegistration.
+ (void)notifyAddBusFinished;


@end

NS_ASSUME_NONNULL_END
