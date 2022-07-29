//
//  FileListViewController.h
//  QuestionnaireStar
//
//  Created by lax on 2022/7/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileListViewController : UIViewController

@property (nonatomic) BOOL canEdit;

/// 初始化
/// @param filePath 文件路径
- (instancetype)initWithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
