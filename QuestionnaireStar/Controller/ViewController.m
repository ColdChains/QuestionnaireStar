//
//  ViewController.m
//  QuestionnaireStar
//
//  Created by lax on 2021/2/28.
//

#import "ViewController.h"
#import "ShareViewController.h"
#import "FileListViewController.h"

#import "UIViewController+Alert.h"
#import "NSString+Extention.h"

@interface ViewController ()

// 单选题
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
// 多选题
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;

// 题库目录
@property (copy, nonatomic) NSString *sourcePathSingle;
@property (copy, nonatomic) NSString *sourcePathMultiple;

// 题库数据源
@property (copy, nonatomic) NSArray<NSArray<NSString *> *> *dataArraySingle;
@property (copy, nonatomic) NSArray<NSArray<NSString *> *> *dataArrayMultiple;

// 生成文件路径
@property (copy, nonatomic) NSString *filePath;
// 题库文件路径
@property (copy, nonatomic) NSString *bankPath;

@end

@implementation ViewController

- (NSString *)filePath {
    // 获取Documents目录路径
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"Excel"];
    if (![NSFileManager.defaultManager fileExistsAtPath:directoryPath]){
        [NSFileManager.defaultManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return directoryPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstTextField.text = [NSUserDefaults.standardUserDefaults objectForKey:@"countSingle"];
    self.secondTextField.text = [NSUserDefaults.standardUserDefaults objectForKey:@"countMultiple"];
    
    // 题库目录
    self.sourcePathSingle = [[NSBundle mainBundle] pathForResource:@"单选题库2023" ofType:@"xls"];
    self.sourcePathMultiple = [[NSBundle mainBundle] pathForResource:@"多选题库2023" ofType:@"xls"];
    
    //读取文件内容
    self.dataArraySingle = [self readFileFromPath:self.sourcePathSingle];
    self.dataArrayMultiple = [self readFileFromPath:self.sourcePathMultiple];
    
    // 获取题库路径
    NSString *name = [self.sourcePathSingle componentsSeparatedByString:@"/"].lastObject;
    self.bankPath = [self.sourcePathSingle stringByReplacingOccurrencesOfString:name withString:@""];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

// 读取文件内容
- (NSArray<NSArray<NSString *> *> *)readFileFromPath:(NSString *)path {
    NSData *fileData = [NSFileManager.defaultManager contentsAtPath:path];
    // 使用UTF16才能显示汉字
    NSString *dataStr = [[NSString alloc] initWithData:fileData encoding:NSUTF16StringEncoding];
    // 过滤多余字符
    for (NSString *str in @[@"A.", @"B.", @"C.", @"D.", @"E.", @"F.", @"A、", @"B、", @"C、", @"D、", @"E、", @"F、"]) {
        dataStr = [dataStr stringByReplacingOccurrencesOfString:str withString:@""];
    }
    //转数组
    NSArray *fileArr = [dataStr componentsSeparatedByString:@"\r\n"];
    
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *item in fileArr) {
        NSString *str = [item stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSArray *arr = [str componentsSeparatedByString:@"\t"];
        if ([arr.firstObject isEqualToString:@""]) {
            continue;
        }
        [muArr addObject:arr];
    }
    return muArr;
}

- (NSArray<NSArray<NSString *> *> *)getRandomDataFromArray:(NSArray<NSArray<NSString *> *> *)dataArray type:(NSString *)type count:(NSInteger)count {
    count = MIN(count, dataArray.count);
    NSMutableArray *rowArr = [[NSMutableArray alloc] init];
    NSMutableArray *sourceArray = [dataArray mutableCopy];
    while (count > 0 && sourceArray.count > 0) {
        count --;
        
        int index = arc4random() % sourceArray.count;
        NSArray<NSString *> *arr = sourceArray[index];
        [sourceArray removeObjectAtIndex:index];
        
        NSMutableArray *columnArr = [[NSMutableArray alloc] init];
        [columnArr addObject:type ?: @"单选题"];
        // 题目
        [columnArr addObject:[NSString stringWithFormat:@"%@", arr[0]]];
        // 选项
        [columnArr addObject:[NSString stringWithFormat:@"A.%@", arr[2].trim]];
        [columnArr addObject:[NSString stringWithFormat:@"B.%@", arr[3].trim]];
        if (arr.count > 4 && ![arr[4].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"C.%@", arr[4].trim]];
        } else {
            [columnArr addObject:@""];
        }
        if (arr.count > 5 && ![arr[5].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"D.%@", arr[5].trim]];
        } else {
            [columnArr addObject:@""];
        }
        if (arr.count > 6 && ![arr[6].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"E.%@", arr[6].trim]];
        } else {
            [columnArr addObject:@""];
        }
        if (arr.count > 7 && ![arr[7].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"F.%@", arr[7].trim]];
        } else {
            [columnArr addObject:@""];
        }
        // 正确答案
        [columnArr addObject:arr[1]];
        // 答案解析
        [columnArr addObject:@""];
        // 分值
        [columnArr addObject:@"4"];
        NSString *columnStr = [columnArr componentsJoinedByString:@"\t"];
        [rowArr addObject:columnStr];
    }
    return rowArr.copy;
}

// 生成文件
- (IBAction)confirmButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.firstTextField.text.trim isEqualToString:@""] && [self.secondTextField.text.trim isEqualToString:@""]) {
        [self showAlertController:@"请输入题目数量" message:@"" complation:^{
        }];
        return;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *name = [NSString stringWithFormat:@"问卷星%@.xlsx", [dateFormat stringFromDate:[NSDate date]]];
    // 生成文件目录
    NSString *filePath = [self.filePath stringByAppendingPathComponent:name];

    NSInteger countSingle = self.firstTextField.text.intValue;
    NSInteger countMultiple = self.secondTextField.text.intValue;
    [NSUserDefaults.standardUserDefaults setValue:[NSString stringWithFormat:@"%ld", countSingle] forKey:@"countSingle"];
    [NSUserDefaults.standardUserDefaults setValue:[NSString stringWithFormat:@"%ld", countMultiple] forKey:@"countMultiple"];
    [NSUserDefaults.standardUserDefaults synchronize];
    
    // 创建存放XLS文件数据的数组
    NSMutableArray *rowArr = [[NSMutableArray alloc] init];
    [rowArr addObject:@"题型\t题目\t选项1\t选项2\t选项3\t选项4\t选项5\t选项6\t正确答案\t答案解析\t分值"];
    [rowArr addObjectsFromArray:[self getRandomDataFromArray:self.dataArraySingle type:@"单选题" count:countSingle]];
    [rowArr addObjectsFromArray:[self getRandomDataFromArray:self.dataArrayMultiple type:@"多选题" count:countMultiple]];
    
    NSString *newStr = [rowArr componentsJoinedByString:@"\r\n"];
    // 使用UTF16才能显示汉字；如果显示为#######是因为格子宽度不够，拉开即可
    NSData *newData = [newStr dataUsingEncoding:NSUTF16StringEncoding];
    // 文件路径
    NSLog(@"文件路径：\n%@", filePath);
    // 生成xls文件
    [NSFileManager.defaultManager createFileAtPath:filePath contents:newData attributes:nil];

    [self showAlertControllerWithCancel:@"文件生成成功" message:[NSString stringWithFormat:@"文件路径：%@", filePath] confirmText:@"查看" cancelText:@"取消" confirmBlock:^{
        ShareViewController *vc = [[ShareViewController alloc] initWithFilePath:filePath];
        [self.navigationController pushViewController:vc animated:YES];
    } cancelBlock:^{
    }];
}

// 查看文件
- (IBAction)lookFileButtonAction:(id)sender {
    [self.view endEditing:YES];
    FileListViewController *vc = [[FileListViewController alloc] initWithFilePath:self.filePath];
    vc.canEdit = YES;
    vc.title = @"文件列表";
    [self.navigationController pushViewController:vc animated:YES];
}

// 查看题库
- (IBAction)lookBankButtonAction:(id)sender {
    [self.view endEditing:YES];
    FileListViewController *vc = [[FileListViewController alloc] initWithFilePath:self.bankPath];
    vc.title = @"题库";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
