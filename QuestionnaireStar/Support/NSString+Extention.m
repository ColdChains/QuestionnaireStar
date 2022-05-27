//
//  NSString+Extention.m
//  UnityCarDrive
//
//  Created by lax on 2019/2/2.
//  Copyright © 2019 TSingYan. All rights reserved.
//

#import "NSString+Extention.h"

@implementation NSString (Extention)

#pragma mark - 正则验证
- (BOOL)isTelephoneNumber {
    NSString *regex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isIdentifyNumber {
//    NSString *regex = @"^(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$";
    NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [identityCardPredicate evaluateWithObject:self];
}

- (BOOL)isIdentifyNumberTest {
    NSString *regex = @"^(^[0-9]*$)|(^[0-9]{17}[Xx]$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [identityCardPredicate evaluateWithObject:self];
}

- (BOOL)isNumber {
    NSString *regex = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumberAndDot {
    NSString *regex = @"^[0-9.]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

//- (BOOL)isChineseWithStr:(NSString *)str {
//    for(int i = 0; i < str.length; i ++)
//    {
//        int a = [str characterAtIndex:i];
//        
//        if( a > 0x4e00 && a < 0x9fff)
//        {
//            return YES;
//        }
//        else
//        {
//            return NO;
//        }
//    }
//    return NO;
//}

#pragma mark - 时间
//从self到某个时间的差
- (NSDateComponents *)getDifferenceTimeToDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [formatter dateFromString:self];
    //获取俩个日期之前的天数差值
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unit fromDate:startDate toDate:date options:0];
    return components;
}
//从某个时间开始到self的时间差
- (NSDateComponents *)getDifferenceTimeFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [formatter dateFromString:self];
    //获取俩个日期之前的天数差值
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unit fromDate:date toDate:endDate options:0];
    return components;
}
//字符串转日期
- (NSDate *)dateWithDefaultFormatString {
    return [self dateWithFormatString:@"MMM dd, yyyy hh:mm:ss aa"];
}
- (NSDate *)dateWithFormatString:(NSString *)format {
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [dateFormat dateFromString:self];
    return date;
}
//格式化时间
// in Mar 20, 2019 2:40:00 PM
// out 2019-01-01 00:00:00
- (NSString *)dateStringWithFormatString:(NSString *)formatStr {
    NSDate *date;
    if ([self containsString:@"-"]) {
        date = [self dateWithFormatString:@"yyyy-MM-dd HH:mm:ss"];;
    } else {
        date = [self dateWithDefaultFormatString];
    }
    NSDateFormatter* dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat2 setDateFormat:formatStr];
    NSString *publishtimeStr = [dateFormat2 stringFromDate:date];
    return publishtimeStr;
}

- (NSString *)dateStringWithChinese {
    return [self dateStringWithFormatString:@"yyyy年MM月dd日 HH:mm"];
}
- (NSString *)dateStringWithChineseNoTime {
    return [self dateStringWithFormatString:@"yyyy年MM月dd日"];
}
- (NSString *)dateStringWithChineseNoYear {
    return [self dateStringWithFormatString:@"MM月dd日 HH:mm"];
}
- (NSString *)dateString {
    return [self dateStringWithFormatString:@"yyyy-MM-dd HH:mm:ss"];
}
- (NSString *)dateStringNoSecondWithDot {
    return [self dateStringWithFormatString:@"yyyy.MM.dd HH:mm"];
}
- (NSString *)dateStringNoSecond {
    return [self dateStringWithFormatString:@"yyyy-MM-dd HH:mm"];
}
- (NSString *)dateStringNoYearSecond {
    return [self dateStringWithFormatString:@"MM-dd HH:mm"];
}
- (NSString *)dateStringNoTime {
    return [self dateStringWithFormatString:@"yyyy-MM-dd"];
}

#pragma mark - 计算字符串大小
//字符串行数 向上取整
- (NSInteger)numberOfLinesWidth:(CGFloat)width andFont:(UIFont *)font {
    CGFloat height = [self getHeightWithWidth:width andFont:font];
    return ceil(height / font.pointSize);
}

// 根据字符串计算label高度
- (CGFloat)getHeightWithWidth:(CGFloat)width andFont:(UIFont *)font {
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 1000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font}; //, NSParagraphStyleAttributeName:style
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return ceil(height);
}

// 根据字符串计算label宽度
- (CGFloat)getWidthWithWidth:(CGFloat)width andFont:(UIFont *)font {
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, 1000);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    //1.3配置计算时的字体的大小
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font}; //, NSParagraphStyleAttributeName:style
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat w = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.width;
    return ceil(w);
}

#pragma mark - 字符串取整
//向上取整 取大的
- (NSInteger)ceilFloatString {
    return ceil(self.floatValue);
}
//向下取整
- (NSInteger)floorFloatString {
    return floor(self.floatValue);
}
//四舍五入
- (NSInteger)roundFloatString {
    return round(self.floatValue);
}

- (NSString *)floatFormatString {
    NSString *str = [NSString stringWithFormat:@"%.2f", self.doubleValue];
    while ([str hasSuffix:@"0"]) {
        str = [str substringToIndex:str.length - 1];
    }
    if ([str hasSuffix:@"."]) {
        str = [str substringToIndex:str.length - 1];
    }
    return str;
}
- (NSString *)floatFormatShortString {
    NSString *str = [NSString stringWithFormat:@"%.1f", self.doubleValue];
    if ([str hasSuffix:@"0"]) {
        str = [str substringToIndex:str.length - 2];
    }
    return str;
}

#pragma makr - 字符串处理
- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimAllSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//银行卡尾号
- (NSString *)bankcardTailNumber {
    if (self.length >= 4) {
        return [self substringFromIndex:self.length - 4];
    } else
    {
        return @"xxxx";
    }
}

- (NSString *)numberString {
    NSString *str = @"";
    for (int i = 0; i < self.length; i++) {
        if ([self characterAtIndex:i] >= 48 && [self characterAtIndex:i] <= 57) {
            str = [NSString stringWithFormat:@"%@%c", str, [self characterAtIndex:i]];
        }
    }
    return str;
}

#pragma mark - 时间和距离
- (NSString *)formatDistanceString {
    NSInteger distance = self.floatValue * 1000.0;
    if (distance > 1000) {
        NSString *dist = [NSString stringWithFormat:@"%f", distance / 1000.0];
        return [NSString stringWithFormat:@"%@公里", [dist floatFormatString]];
    } else {
        return [NSString stringWithFormat:@"%ld米", (long)distance];
    }
}
//设置距离和时间
- (NSString *)timeString {
    NSInteger time = self.integerValue / 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", time / 60, time % 60];
}
- (NSString *)formatTimeString {
    NSInteger time = self.integerValue;
    if (time >= 24 * 60 * 60) {
            if (time %  (24 * 60 * 60) == 0) {
                return [NSString stringWithFormat:@"%ld天", time / (24 * 60 * 60)];
            } else {
                return [NSString stringWithFormat:@"%ld天%ld小时", time / (24 * 60 * 60), (time % (24 * 60 * 60)) / (60 * 60)];
            }
    } else if (time >= (60 * 60)) {
        if (time %  (60 * 60) == 0) {
            return [NSString stringWithFormat:@"%ld小时", time / (60 * 60)];
        } else {
            return [NSString stringWithFormat:@"%ld小时%ld分", time / (60 * 60), (time % (60 * 60)) / 60];
        }
    } else if (time >= 60) {
        return [NSString stringWithFormat:@"%ld分钟", time / 60];
    } else {
        return [NSString stringWithFormat:@"0分钟"];
    }
}
- (NSString *)formatDetailTimeString {
    NSInteger time = self.integerValue;
    if (time >= 60 * 60) {
        if (time %  (60 * 60) == 0) {
            return [NSString stringWithFormat:@"%ld小时", time / (60 * 60)];
        } else {
            if (time % 60 == 0) {
                return [NSString stringWithFormat:@"%ld小时%ld分", time / (60 * 60), (time % (60 * 60)) / 60];
            } else {
                return [NSString stringWithFormat:@"%ld小时%ld分%ld秒", time / (60 * 60), (time % (60 * 60)) / 60, time % 60];
            }
        }
    } else if (time >= 60) {
        if (time % 60 == 0) {
            return [NSString stringWithFormat:@"%ld分钟", time / 60];
        } else {
            return [NSString stringWithFormat:@"%ld分钟%ld秒", time / 60, time % 60];
        }
    } else {
        return [NSString stringWithFormat:@"%ld秒", time];
    }
}
- (NSString *)formatShortTimeString {
    NSInteger time = self.integerValue;
    if (time >= 60 * 60) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", time / (60 * 60), (time % (60 * 60)) / 60, time % 60];
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld", time / 60, time % 60];
    }
}
- (NSString *)formatPersonString {
    return [NSString stringWithFormat:@"%zd人", self.integerValue];
}
- (NSString *)formatMoneyString {
    return [NSString stringWithFormat:@"%@元", [self floatFormatString]];
}
- (NSString *)formatGradeString {
    return [NSString stringWithFormat:@"%@分", [self floatFormatShortString]];
}

#pragma mark - NSAttributedString
- (NSAttributedString *)attributedStringWithLineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    NSRange range = NSMakeRange(0, self.length);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}

- (NSAttributedString *)attributedString:(NSString *)subString font:(UIFont *)font {
    NSRange range = [self rangeWithSubString:subString];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *dict = @{NSFontAttributeName : font};
    [attributeStr addAttributes:dict range:range];
    return attributeStr;
}

- (NSAttributedString *)attributedString:(NSString *)subString fontSize:(CGFloat)size {
    NSRange range = [self rangeWithSubString:subString];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:size]};
    [attributeStr addAttributes:dict range:range];
    return attributeStr;
}

- (NSAttributedString *)attributedString:(NSString *)subString fontSize:(CGFloat)size color:(UIColor *)color {
    NSRange range = [self rangeWithSubString:subString];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *dict = @{ NSForegroundColorAttributeName : color,
                            NSFontAttributeName : [UIFont systemFontOfSize:size]};
    [attributeStr addAttributes:dict range:range];
    return attributeStr;
}

- (NSAttributedString *)attributedString:(NSString *)subString fontSize:(CGFloat)size color:(UIColor *)color subColor:(UIColor *)subColor {
    NSRange range = [self rangeWithSubString:subString];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *dict = @{ NSForegroundColorAttributeName : color};
    NSDictionary *subDict = @{ NSForegroundColorAttributeName : subColor,
                            NSFontAttributeName : [UIFont systemFontOfSize:size]};
    [attributeStr addAttributes:dict range:[self rangeWithSubString:self]];
    [attributeStr addAttributes:subDict range:range];
    return attributeStr;
}

- (NSRange)rangeWithSubString:(NSString *)subString {
    if (!subString) {
        return NSMakeRange(0, 0);
    } else {
        if (@available(iOS 9.0, *)) {
            return [self localizedStandardRangeOfString:subString];
        } else {
            return [self rangeOfString:subString];
        }
    }
}

- (NSAttributedString *)attributedStringWithRange:(NSRange)range fontSize:(CGFloat)size color:(UIColor *)color {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *dict = @{ NSForegroundColorAttributeName : color,
                            NSFontAttributeName : [UIFont systemFontOfSize:size]};
    [attributeStr addAttributes:dict range:range];
    return attributeStr;
}

#pragma mark - 解析HTML字符串
- (NSString *)htmlString {
    NSString *string =  [self stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]
                                           initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding]
                                           options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                           documentAttributes:nil
                                           error:nil];
    string = [attrStr string];
//    string =  [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return string;
}
//转字典
- (NSDictionary *)dictionaryWithJsonString {
//    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
//    if(err) {
//        NSLog(@"json解析失败：%@",err);
//        return nil;
//    }
//    return dic;
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
