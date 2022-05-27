//
//  NSString+Extention.h
//  UnityCarDrive
//
//  Created by lax on 2019/2/2.
//  Copyright © 2019 TSingYan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extention)


- (BOOL)isTelephoneNumber;
- (BOOL)isIdentifyNumber;
- (BOOL)isIdentifyNumberTest;
- (BOOL)isNumber;
- (BOOL)isNumberAndDot;

//获取时间差
- (NSDateComponents *)getDifferenceTimeFromDate:(NSDate *)date;
- (NSDateComponents *)getDifferenceTimeToDate:(NSDate *)date;
//字符串转日期
- (NSDate *)dateWithDefaultFormatString;
- (NSDate *)dateWithFormatString:(NSString *)format;
//格式化日期
- (NSString *)dateStringWithFormatString:(NSString *)formatStr;
- (NSString *)dateStringWithChinese;
- (NSString *)dateStringWithChineseNoTime;
- (NSString *)dateStringWithChineseNoYear;
- (NSString *)dateString;
- (NSString *)dateStringNoSecondWithDot;
- (NSString *)dateStringNoSecond;
- (NSString *)dateStringNoYearSecond;
- (NSString *)dateStringNoTime;

//字符串行数 向上取整
- (NSInteger)numberOfLinesWidth:(CGFloat)width andFont:(UIFont *)font;
// 根据字符串计算label高度
- (CGFloat)getHeightWithWidth:(CGFloat)width andFont:(UIFont *)font;
- (CGFloat)getWidthWithWidth:(CGFloat)width andFont:(UIFont *)font;

//向上取整
- (NSInteger)ceilFloatString;
//向下取整
- (NSInteger)floorFloatString;
//四舍五入
- (NSInteger)roundFloatString;

- (NSString *)floatFormatString;
- (NSString *)floatFormatShortString;

//去空格
- (NSString *)trim;
- (NSString *)trimAllSpace;

- (NSString *)bankcardTailNumber;
- (NSString *)numberString;

//距离和时间
- (NSString *)formatDistanceString;
- (NSString *)formatPersonString;
- (NSString *)formatTimeString;
- (NSString *)timeString;
- (NSString *)formatDetailTimeString;
- (NSString *)formatShortTimeString;
- (NSString *)formatMoneyString;
- (NSString *)formatGradeString;

//NSAttributedString
- (NSAttributedString *)attributedStringWithLineSpace:(CGFloat)lineSpace;
- (NSAttributedString *)attributedString:(NSString *)subString font:(UIFont *)font;
- (NSAttributedString *)attributedString:(NSString *)subString fontSize:(CGFloat)size;
- (NSAttributedString *)attributedString:(NSString *)subString fontSize:(CGFloat)size color:(UIColor *)color;
- (NSAttributedString *)attributedString:(NSString *)subString fontSize:(CGFloat)size color:(UIColor *)color subColor:(UIColor *)subColor;
- (NSAttributedString *)attributedStringWithRange:(NSRange)range fontSize:(CGFloat)size color:(UIColor *)color;

//htmlString
- (NSString *)htmlString;
- (NSDictionary *)dictionaryWithJsonString;

@end

NS_ASSUME_NONNULL_END
