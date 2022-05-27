//
//  UIViewController+Alert.h
//  UnityCarDrive
//
//  Created by lax on 2019/3/27.
//  Copyright © 2019 TSingYan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Alert)

- (void)showAlertController:(NSString *)title message:(NSString *)message;
- (void)showAlertController:(NSString *)title
                    message:(NSString *)message
                confirmText:(NSString *)confirmText;
- (void)showAlertController:(NSString *)title
                    message:(NSString *)message
                 complation:(void(^)(void))complation;
- (void)showAlertController:(NSString *)title
                    message:(NSString *)message
                confirmText:(NSString *)confirmText
               complation:(void(^)(void))complation;

- (void)showAlertControllerWithCancel:(NSString *)title
                              message:(NSString *)message
                           complation:(void(^)(void))complation;
- (void)showAlertControllerWithCancel:(NSString *)title
                              message:(NSString *)message
                          confirmText:(NSString *)confirmText
                           complation:(void(^)(void))complation;
- (void)showAlertControllerWithCancel:(NSString *)title
                              message:(NSString *)message
                         confirmBlock:(void(^)(void))confirmBlock
                          cancelBlock:(void(^)(void))cancelBlock;
- (void)showAlertControllerWithCancel:(NSString *)title
                              message:(NSString *)message
                          confirmText:(NSString *)confirmText
                           cancelText:(NSString *)cancelText
                         confirmBlock:(void(^)(void))confirmBlock
                          cancelBlock:(void(^)(void))cancelBlock;

- (void)showActionSheetController:(NSString *)confirmText complation:(void (^)(void))complation;
- (void)showActionSheetController:(NSString *)title
                          message:(NSString *)message
                      confirmText:(NSString *)confirmText
                     confirmBlock:(void(^)(void))confirmBlock
                      cancelBlock:(void(^)(void))cancelBlock;

@end

NS_ASSUME_NONNULL_END
