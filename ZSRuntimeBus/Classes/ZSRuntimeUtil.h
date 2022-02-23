//
//  ZSRuntimeUtil.h
//  SKIO_K_SDRuntimeBus
//
//  Created by shuaishuai on 2021/4/29.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN


/**
 Replace a method with another method
 @discussion
 You can call original method by calling the swizzle method name:
 @code
 zs_replaceMethodWithMethod([ClassA class],
                             @selector(myMethod),
                             [ClassB class],
                             @selector(hooked_myMethod));
 
 @implementation ClassA
 - (void)myMethod {
     NSLog(@"Call origin method");
 }
 @end
 
 @implementation ClassB
 - (void)hooked_myMethod {
     //Call origin method
     [self hooked_myMethod];
 }
 @end
 @endcode
 
 @param originalClass The class you want to hook
 @param originalSelector The selector to be hooked. When there are same selector for class method and instance method, instance method is priority.
 @param swizzledClass The class providing the new method
 @param swizzledSelector The selector of new method. When there are same selector for class method and instance method, instance method is priority.
 @return True when hook successfully
 */
FOUNDATION_EXTERN bool zs_replaceMethodWithMethod(Class originalClass, SEL originalSelector,
                                                   Class swizzledClass, SEL swizzledSelector);

/// Same with zs_replaceMethodWithMethod, but you can specify class method or instance method.
FOUNDATION_EXTERN bool zs_replaceMethodWithMethodType(Class originalClass, SEL originalSelector, bool originIsClassMethod,
                                                       Class swizzledClass, SEL swizzledSelector, bool swizzledIsClassMethod);

/// Enumerate all classes.
FOUNDATION_EXTERN void zs_enumerateClassList(void(^handler)(Class aClass));

/// Enumerate all protocols.
FOUNDATION_EXTERN void zs_enumerateProtocolList(void(^handler)(Protocol *protocol));

/// Check whether a class is a subclass of another class.
FOUNDATION_EXTERN bool zs_classIsSubclassOfClass(Class aClass, Class parentClass);

/// Check whether a class is from Apple's system framework, or from your project.
FOUNDATION_EXTERN bool zs_classIsCustomClass(Class aClass);

/// Check whether a class self implementing a method.
FOUNDATION_EXTERN bool zs_classSelfImplementingMethod(Class aClass, SEL method, bool isClassMethod);

/// Check whether an object is an objc protocol.
FOUNDATION_EXTERN bool zs_isObjcProtocol(id protocol);

/// Check whether a protocol has a parent protocol.
FOUNDATION_EXTERN bool zs_protocolConformsToProtocol(Protocol *protocol, Protocol *parentProtocol);

/// Return objc protocol if object is Protocol.
FOUNDATION_EXTERN Protocol *_Nullable zs_objcProtocol(id protocol);

// Test whether can use `zs_enumerateClassesInMainBundleForParentClass`. It should always be true unless layout of OC class and Mach-O is changed.
FOUNDATION_EXTERN BOOL zs_canEnumerateClassesInImage(void);

/**
 Enumerate all subclasses of the parent class in app read from section `__objc_classlist`. It's much faster than `objc_copyClassList` because it won't realize these subclasses.
 @warning
 Those classes may not be realized yet. If you use OC runtime functions with the class that will access class_rw_t (such as `class_copyIvarList`), it will crash because class_rw_t is not initialized yet. You can try to trigger `realizeClass()` by method finding (such as `class_getMethodImplementation` or just perform some method).

 @param parentClass Parent class for enumeration
 @param handler Handler subclasses
 */
FOUNDATION_EXTERN void zs_enumerateClassesInMainBundleForParentClass(Class parentClass, void(^handler)(__unsafe_unretained Class aClass));


//Enumerate all Method for parentClass
FOUNDATION_EXTERN void zs_enumerateClassMethodsForClass(Class aClass, void(^handler)(Method classMethod));


NS_ASSUME_NONNULL_END
