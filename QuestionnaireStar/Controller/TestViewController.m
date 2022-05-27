//
//  TestViewController.m
//  问卷星
//
//  Created by lax on 2021/2/28.
//

#import "TestViewController.h"
#import <QuickLook/QuickLook.h>

@interface TestViewController () <QLPreviewControllerDataSource, UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) UIDocumentInteractionController *documentController;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.filePath) {
        NSString *name = self.type == 0 ? @"file1.xls" : @"file2.xls";
        self.filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    }
    //    self.filePath = @"/Users/apple/Library/Developer/CoreSimulator/Devices/55BA4D81-D70B-4C4B-A650-2ECBB6CCF7E5/data/Containers/Data/Application/98A3F43A-4243-45A7-BE12-A73518FBE92A/Documents/test0330.xlsx";
//        self.filePath = [[NSBundle mainBundle] pathForResource:@"test0330" ofType:@"xlsx"];
    
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
