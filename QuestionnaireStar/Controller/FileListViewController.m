//
//  FileListViewController.m
//  QuestionnaireStar
//
//  Created by lax on 2022/7/27.
//

#import "FileListViewController.h"
#import "ShareViewController.h"
#import "Header.h"

@interface FileListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSDictionary<NSString *, NSString *> *> *dataArray;

@property (copy, nonatomic) NSString *filePath;

@end

@implementation FileListViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.estimatedRowHeight = 46;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    }
    return _tableView;
}

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
    
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    self.tableView.frame = CGRectMake(0, NAVIGATIONBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT);
    [self.view addSubview:self.tableView];
    
    NSArray<NSString *> *files = [self getFileListWithPath:self.filePath];
    for (NSString *name in files) {
        [self.dataArray addObject:@{@"name" : name, @"path" : [self.filePath stringByAppendingPathComponent:name]}];
    }
}

// 获取目录中的文件列表
- (NSArray<NSString *> *)getFileListWithPath:(NSString *)path {
    NSMutableArray *arr = [NSMutableArray array];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    
    // 获取目录下的所以内容
    NSArray *dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
    NSString *subPath = nil;
    for (NSString *name in dirArray) {
        subPath = [path stringByAppendingPathComponent:name];
        // 是否是文件夹
        BOOL isSubDir = NO;
        // 路径是否存在
        BOOL isExist = [fileManger fileExistsAtPath:subPath isDirectory:&isSubDir];
        if (!isSubDir && isExist && ([name hasSuffix:@"xls"] || [name hasSuffix:@"xlsx"])) {
            [arr addObject:name];
        }
    }
    
    //文件排序
    return [arr sortedArrayUsingComparator:^(NSString * firstPath, NSString* secondPath) {
        NSString *firstUrl = [path stringByAppendingPathComponent:firstPath];/*获取前一个文件完整路径*/
        NSString *secondUrl = [path stringByAppendingPathComponent:secondPath];/*获取后一个文件完整路径*/
        NSDictionary *firstFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:firstUrl error:nil];/*获取前一个文件信息*/
        NSDictionary *secondFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:secondUrl error:nil];/*获取后一个文件信息*/
        id firstData = [firstFileInfo objectForKey:NSFileCreationDate];/*获取前一个文件创建时间*/
        id secondData = [secondFileInfo objectForKey:NSFileCreationDate];/*获取后一个文件创建时间*/
        return [secondData compare:firstData];//降序
    }];
}

// 获取目录下的所有文件
- (void)showAllFileWithPath:(NSString *)path {
    NSFileManager *fileManger = [NSFileManager defaultManager];
    // 是否是文件夹
    BOOL isDir = NO;
    // 路径是否存在
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    if (isExist) {
        if (isDir) {
            // 获取目录下的所以内容
            NSArray *dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
            NSString *subPath = nil;
            for (NSString *str in dirArray) {
                subPath = [path stringByAppendingPathComponent:str];
                // 是否是文件夹
                BOOL isSubDir = NO;
                // 路径是否存在
                [fileManger fileExistsAtPath:subPath isDirectory:&isSubDir];
                [self showAllFileWithPath:subPath];
            }
        } else {
            NSString *fileName = [[path componentsSeparatedByString:@"/"] lastObject];
            NSLog(@"%@", fileName);
        }
    } else {
        NSLog(@"this path is not exist!");
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class) forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShareViewController *vc = [[ShareViewController alloc] initWithFilePath:self.dataArray[indexPath.row][@"path"]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.canEdit ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [NSFileManager.defaultManager removeItemAtPath:self.dataArray[indexPath.row][@"path"] error:nil];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
