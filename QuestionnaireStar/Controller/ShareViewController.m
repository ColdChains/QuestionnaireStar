//
//  ShareViewController.m
//  QuestionnaireStar
//
//  Created by lax on 2021/2/28.
//

#import "ShareViewController.h"
#import <QuickLook/QuickLook.h>
#import <WebKit/WebKit.h>

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
    [self showPreview];
}
- (void)showPreview {
    NSString *jsString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, user-scalable=yes\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [configuration.userContentController addUserScript:userScript];
    WKWebView *previewWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    NSURL *accessURL = [[NSURL fileURLWithPath:self.filePath] URLByDeletingLastPathComponent];
    [previewWebView loadFileURL:[NSURL fileURLWithPath:self.filePath] allowingReadAccessToURL:accessURL];
    //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:self.fileLocalPath]];
    //[previewWebView loadRequest:request];
    [self.view addSubview:previewWebView];
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
