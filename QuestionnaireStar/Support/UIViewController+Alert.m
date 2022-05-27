//
//  UIViewController+Alert.m
//  UnityCarDrive
//
//  Created by lax on 2019/3/27.
//  Copyright © 2019 TSingYan. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)showAlertController:(NSString *)title message:(NSString *)message {
    [self showAlertController:title message:message complation:^{}];
}

- (void)showAlertController:(NSString *)title
                    message:(NSString *)message
                confirmText:(NSString *)confirmText {
    [self showAlertController:title
                      message:message
                  confirmText:confirmText
                   complation:^{}];
}

- (void)showAlertController:(NSString *)title
                    message:(NSString *)message
                 complation:(void(^)(void))complation {
    [self showAlertController:title
                      message:message
                  confirmText:@"确定"
                 complation:complation];
}

- (void)showAlertController:(NSString *)title
                    message:(NSString *)message
                confirmText:(NSString *)confirmText
                 complation:(void(^)(void))complation {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:confirmText style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (complation) {
            complation();
        }
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertControllerWithCancel:(NSString *)title
                              message:(NSString *)message
                           complation:(void(^)(void))complation {
    [self showAlertControllerWithCancel:title
                                message:message
                            confirmText:@"确定"
                             cancelText:@"取消"
                           confirmBlock:complation
                            cancelBlock:^{}];
}

- (void)showAlertControllerWithCancel:(NSString *)title
                              message:(NSString *)message
                          confirmText:(NSString *)confirmText
                           complation:(void(^)(void))complation {
    [self showAlertControllerWithCancel:title
                                message:message
                            confirmText:confirmText
                             cancelText:@"取消"
                           confirmBlock:complation
                            cancelBlock:^{}];
}


- (void)showAlertControllerWithCancel:(NSString *)title
                              message:(NSString *)message
                         confirmBlock:(void(^)(void))confirmBlock
                          cancelBlock:(void(^)(void))cancelBlock {
    [self showAlertControllerWithCancel:title
                                message:message
                            confirmText:@"确定"
                             cancelText:@"取消"
                           confirmBlock:confirmBlock
                            cancelBlock:cancelBlock];
}

- (void)showAlertControllerWithCancel:(NSString *)title
                              message:(NSString *)message
                          confirmText:(NSString *)confirmText
                           cancelText:(NSString *)cancelText
                         confirmBlock:(void(^)(void))confirmBlock
                          cancelBlock:(void(^)(void))cancelBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:confirmText style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:cancelText style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    [alert addAction:action];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
- (void)showActionSheetController:(NSString *)confirmText complation:(void (^)(void))complation {
    [self showActionSheetController:@""
                            message:@""
                        confirmText:confirmText
                       confirmBlock:complation
                        cancelBlock:^{}];
}

- (void)showActionSheetController:(NSString *)title
                          message:(NSString *)message
                      confirmText:(NSString *)confirmText
                     confirmBlock:(void(^)(void))confirmBlock
                      cancelBlock:(void(^)(void))cancelBlock {
    title = [title isEqualToString:@""] ? nil : title;
    message = [message isEqualToString:@""] ? nil : message;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:confirmText style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    [alert addAction:action];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
