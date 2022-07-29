//
//  Header.h
//  QuestionnaireStar
//
//  Created by lax on 2022/7/29.
//

#ifndef Header_h
#define Header_h

#define SCREEN_BOUNDS           [UIScreen mainScreen].bounds

#define SCREEN_HEIGHT           ([UIScreen mainScreen].bounds.size.height > [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

#define SCREEN_WIDTH            ([UIScreen mainScreen].bounds.size.height < [UIScreen mainScreen].bounds.size.width ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].bounds.size.width)

#define IS_IPHONEX              (SCREEN_WIDTH >= 375.0f && SCREEN_HEIGHT >= 812.0f)

#define STATUSBAR_HEIGHT        (IS_IPHONEX ? 44.0f : 20.0f)

#define NAVIGATIONBAR_HEIGHT    (STATUSBAR_HEIGHT + 44.0f)

#define TABBAR_HEIGHT           (IS_IPHONEX ? (49.0f + 34.0f) : (49.0f))

#define HOMEBAR_HEIGHT          (IS_IPHONEX ? 34.0f : 0.0f)

#define BOTTOM_MARGIN           (IS_IPHONEX ? 34.0f : 10.0f)

#endif /* Header_h */
