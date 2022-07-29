//
//  ShareViewController.m
//  QuestionnaireStar
//
//  Created by lax on 2021/2/28.
//

#import "ShareViewController.h"
#import <QuickLook/QuickLook.h>

@interface ShareViewController () <QLPreviewControllerDataSource, UIDocumentInteractionControllerDelegate>

@property (copy, nonatomic) NSString *filePath;

@property (strong, nonatomic) UIDocumentInteractionController *documentController;

@end

@implementation ShareViewController

- (instancetype)initWithFilePath:(NSString *)filePath
{
    self = [super init];
    if (self) {
        self.filePath = filePath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.view.frame = self.view.bounds;
    previewController.dataSource = self;
    [self addChildViewController:previewController];
    [self.view addSubview:previewController.view];

    self.navigationItem.rightBarButtonItem = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"分享" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        rightItem;
    });
    
}

// 分享
- (void)rightAction {
    self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:self.filePath]];
    self.documentController.delegate = self;
    [self.documentController presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    NSLog(@"path = %@", self.filePath);
    return [NSURL fileURLWithPath:self.filePath];
}

@end
