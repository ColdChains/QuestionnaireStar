//
//  ViewController.m
//  问卷星
//
//  Created by lax on 2021/2/28.
//

#import "ViewController.h"
#import "UIViewController+Alert.h"
#import "NSString+Extention.h"
#import "TestViewController.h"

@interface ViewController ()

// 单选题
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
// 多选题
@property (weak, nonatomic) IBOutlet UITextField *secondTextField;

// 题库目录
@property (copy, nonatomic) NSString *filePath;
@property (copy, nonatomic) NSString *sourcePath;
@property (copy, nonatomic) NSString *sourcePath2;

// 题库数据源
@property (strong, nonatomic) NSMutableArray *sourceArray;
@property (strong, nonatomic) NSMutableArray *sourceArray2;

@property (strong, nonatomic) NSFileManager *fileManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //题库目录
    self.sourcePath = [[NSBundle mainBundle] pathForResource:@"file1" ofType:@"xls"];
    self.sourcePath2 = [[NSBundle mainBundle] pathForResource:@"file2" ofType:@"xls"];
    
    NSString *path = NSHomeDirectory();
    NSLog(@"home = %@\nfile1 = %@\nfile2 = %@", path, self.sourcePath, self.sourcePath2);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMdd"];
    NSString *str = [dateFormat stringFromDate:[NSDate date]];
    NSString *name = [NSString stringWithFormat:@"/Documents/test%@.xlsx", str];
    //生成文件目录
    self.filePath = [path stringByAppendingPathComponent:name];
    
    self.fileManager = [[NSFileManager alloc] init];
    
    //读取文件内容
    NSData *fileData = [self.fileManager contentsAtPath:self.sourcePath];
    NSString *dataStr = [[NSString alloc] initWithData:fileData encoding:NSUTF16StringEncoding];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"A." withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"B." withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"C." withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"D." withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"E." withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"F." withString:@""];
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
    self.sourceArray = muArr;
    
    //读取文件内容
    fileData = [self.fileManager contentsAtPath:self.sourcePath2];
    dataStr = [[NSString alloc] initWithData:fileData encoding:NSUTF16StringEncoding];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"A." withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"B." withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"C." withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"D." withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"E." withString:@""];
    dataStr = [dataStr stringByReplacingOccurrencesOfString:@"F." withString:@""];
    
    //转数组
    fileArr = [dataStr componentsSeparatedByString:@"\r\n"];
    
    muArr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *item in fileArr) {
        NSString *str = [item stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSArray *arr = [str componentsSeparatedByString:@"\t"];
        if ([arr.firstObject isEqualToString:@""]) {
            continue;
        }
        [muArr addObject:arr];
    }
    self.sourceArray2 = muArr;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)startButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    if ([self.firstTextField.text.trim isEqualToString:@""] && [self.secondTextField.text.trim isEqualToString:@""]) {
        [self showAlertController:@"请输入题目数量" message:@"" complation:^{
        }];
        return;
    }
    NSInteger count1 = self.firstTextField.text.intValue;
    NSInteger count2 = self.secondTextField.text.intValue;

    // 创建存放XLS文件数据的数组
    NSMutableArray *rowArr = [[NSMutableArray alloc] init];
    [rowArr addObject:@"题型\t题目\t选项1\t选项2\t选项3\t选项4\t选项5\t选项6\t正确答案\t答案解析\t分值"];
//        题目    答案解析    正确答案    选项A    选项B    选项C    选项D    选项E    选项F    选项G    选项H
    
    //单选题
    NSMutableArray *muArr = [self.sourceArray mutableCopy];
    while (count1 > 0 && muArr.count > 0) {
        count1 --;
        
        int index = arc4random() % muArr.count;
        NSArray<NSString *> *arr = muArr[index];
        [muArr removeObjectAtIndex:index];
        
        NSMutableArray *columnArr = [[NSMutableArray alloc] init];
        [columnArr addObject:@"单选题"];
        [columnArr addObject:[NSString stringWithFormat:@"%ld.%@", rowArr.count, arr[0]]];
        
        [columnArr addObject:[NSString stringWithFormat:@"A.%@", arr[3].trim]];
        [columnArr addObject:[NSString stringWithFormat:@"B.%@", arr[4].trim]];
        if (arr.count > 5 && ![arr[5].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"C.%@", arr[5].trim]];
        } else {
            [columnArr addObject:@""];
        }
        if (arr.count > 6 && ![arr[6].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"D.%@", arr[6].trim]];
        } else {
            [columnArr addObject:@""];
        }
        if (arr.count > 7 && ![arr[7].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"E.%@", arr[7].trim]];
        } else {
            [columnArr addObject:@""];
        }
        if (arr.count > 8 && ![arr[8].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"F.%@", arr[8].trim]];
        } else {
            [columnArr addObject:@""];
        }
        
        [columnArr addObject:arr[2]];
        [columnArr addObject:@""];
        [columnArr addObject:@"4"];
        NSString *columnStr = [columnArr componentsJoinedByString:@"\t"];
        [rowArr addObject:columnStr];
    }
    
    //多选题
    muArr = [self.sourceArray2 mutableCopy];
    while (count2 > 0 && muArr.count > 0) {
        count2 --;
        
        int index = arc4random() % muArr.count;
        NSArray<NSString *> *arr = muArr[index];
        [muArr removeObjectAtIndex:index];
        
        NSMutableArray *columnArr = [[NSMutableArray alloc] init];
        [columnArr addObject:@"多选题"];
        [columnArr addObject:[NSString stringWithFormat:@"%ld.%@", rowArr.count, arr[0]]];
        
        [columnArr addObject:[NSString stringWithFormat:@"A.%@", arr[3].trim]];
        [columnArr addObject:[NSString stringWithFormat:@"B.%@", arr[4].trim]];
        if (arr.count > 5 && ![arr[5].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"C.%@", arr[5].trim]];
        } else {
            [columnArr addObject:@""];
        }
        if (arr.count > 6 && ![arr[6].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"D.%@", arr[6].trim]];
        } else {
            [columnArr addObject:@""];
        }
        if (arr.count > 7 && ![arr[7].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"E.%@", arr[7].trim]];
        } else {
            [columnArr addObject:@""];
        }
        if (arr.count > 8 && ![arr[8].trim isEqualToString:@""]) {
            [columnArr addObject:[NSString stringWithFormat:@"F.%@", arr[8].trim]];
        } else {
            [columnArr addObject:@""];
        }
        
        [columnArr addObject:arr[2]];
        [columnArr addObject:@""];
        [columnArr addObject:@"4"];
        NSString *columnStr = [columnArr componentsJoinedByString:@"\t"];
        [rowArr addObject:columnStr];
    }
    NSString *newStr = [rowArr componentsJoinedByString:@"\r\n"];
    
    // 文件管理器
    //使用UTF16才能显示汉字；如果显示为#######是因为格子宽度不够，拉开即可
    NSData *newData = [newStr dataUsingEncoding:NSUTF16StringEncoding];
    // 文件路径
    NSLog(@"文件路径：\n%@", self.filePath);
    // 生成xls文件
    [self.fileManager createFileAtPath:self.filePath contents:newData attributes:nil];
    
    __weak typeof(self) weakSelf = self;
    [UIPasteboard generalPasteboard].string = weakSelf.filePath;
    [self showAlertControllerWithCancel:@"文件生成成功" message:[NSString stringWithFormat:@"文件路径：%@", self.filePath] confirmText:@"查看" cancelText:@"取消" confirmBlock:^{
        [weakSelf shareButtonAction:nil];
    } cancelBlock:^{
    }];
}

//查看生成文件
- (IBAction)shareButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    if (!self.filePath) { return ; }
    TestViewController *vc = [[TestViewController alloc] init];
    vc.filePath = self.filePath;
    [self.navigationController pushViewController:vc animated:YES];
}

//查看题库
- (IBAction)fileButtonAction:(id)sender {
    TestViewController *vc = [[TestViewController alloc] init];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)file2ButtonAction:(id)sender {
    TestViewController *vc = [[TestViewController alloc] init];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
