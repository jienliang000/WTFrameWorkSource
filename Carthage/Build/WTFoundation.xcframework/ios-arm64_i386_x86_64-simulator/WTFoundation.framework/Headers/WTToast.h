/*
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum WTToastGravity {
	WTToastGravityTop = 1000001,
	WTToastGravityBottom,
	WTToastGravityCenter
}WTToastGravity;

typedef enum WTToastDuration {
	WTToastDurationLong = 10000,
	WTToastDurationShort = 1000,
	WTToastDurationNormal = 3000
}WTToastDuration;

typedef enum WTToastType {
	WTToastTypeInfo = -100000,
	WTToastTypeNotice,
	WTToastTypeWarning,
	WTToastTypeError,
	WTToastTypeNone // For internal use only (to force no image)
}WTToastType;

typedef enum {
    WTToastImageLocationTop,
    WTToastImageLocationLeft
} WTToastImageLocation;


@class WTToastSettings;

@interface WTToast : NSObject {
	WTToastSettings *_settings;
	
	NSTimer *timer;
	
	UIView *view;
	NSString *text;
}

- (void) show;
- (void) show:(WTToastType) type;
- (WTToast *) setDuration:(NSInteger ) duration;
- (WTToast *) setGravity:(WTToastGravity) gravity
			 offsetLeft:(NSInteger) left
			 offsetTop:(NSInteger) top;
- (WTToast *) setGravity:(WTToastGravity) gravity;
- (WTToast *) setPostion:(CGPoint) position;
- (WTToast *) setFontSize:(CGFloat) fontSize; // 设置字体大小
- (WTToast *) setUseShadow:(BOOL) useShadow;
- (WTToast *) setCornerRadius:(CGFloat) cornerRadius;
- (WTToast *) setBgRed:(CGFloat) bgRed;
- (WTToast *) setBgGreen:(CGFloat) bgGreen;
- (WTToast *) setBgBlue:(CGFloat) bgBlue;
- (WTToast *) setBgAlpha:(CGFloat) bgAlpha;

+ (WTToast *) makeText:(NSString *) text;

// 添加初始化方法：
- (id) initWithText:(NSString *) tex;
// 设置字体颜色：默认是白色
- (WTToast *) setFontColor:(UIColor *) fontColor;

-(WTToastSettings *) theSettings;

@end



@interface WTToastSettings : NSObject<NSCopying>{
   
}


@property(assign) NSInteger duration;
@property(assign) WTToastGravity gravity;
@property(assign) CGPoint postition;
@property(assign) CGFloat fontSize;
@property(nonatomic, strong) UIColor *fontColor; // 字体颜色
@property(assign) BOOL useShadow;
@property(assign) CGFloat cornerRadius;
@property(assign) CGFloat bgRed;
@property(assign) CGFloat bgGreen;
@property(assign) CGFloat bgBlue;
@property(assign) CGFloat bgAlpha;
@property(assign) NSInteger offsetLeft;
@property(assign) NSInteger offsetTop;
@property(readonly) NSDictionary *images;
@property(assign) WTToastImageLocation imageLocation;


- (void) setImage:(UIImage *)img forType:(WTToastType) type;
- (void) setImage:(UIImage *)img withLocation:(WTToastImageLocation)location forType:(WTToastType)type;
+ (WTToastSettings *) getSharedSettings;
						  
@end
