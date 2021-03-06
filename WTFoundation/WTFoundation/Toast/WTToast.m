/*

*/


#import "WTToast.h"
#import <QuartzCore/QuartzCore.h>

#define CURRENT_TOAST_TAG 6984678

#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

static const CGFloat kComponentPadding = 5;

static WTToastSettings *sharedSettings = nil;

@interface WTToast(private){
    
    
}

- (WTToast *) settings;
- (CGRect)_toastFrameForImageSize:(CGSize)imageSize withLocation:(WTToastImageLocation)location andTextSize:(CGSize)textSize;
- (CGRect)_frameForImage:(WTToastType)type inToastFrame:(CGRect)toastFrame;



@end


@implementation WTToast



- (id) initWithText:(NSString *) tex{
	if (self = [super init]) {
		text = [tex copy];
	}
	
	return self;
}

- (void) show{
	[self show:WTToastTypeNone];
}

- (void) show:(WTToastType) type {
	
	WTToastSettings *theSettings = _settings;
	
	if (!theSettings) {
		theSettings = [WTToastSettings getSharedSettings];
	}
	
	UIImage *image = [theSettings.images valueForKey:[NSString stringWithFormat:@"%i", type]];
	
	UIFont *font = [UIFont systemFontOfSize:theSettings.fontSize];
    UIColor *color = theSettings.fontColor; // [UIColor whiteColor]
    
    CGSize textSize;
    // 下面的方法在iOS7.0后就过期了
    if(IOS7_OR_LATER)
    {
        textSize = [text boundingRectWithSize:CGSizeMake(280,60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    }else
    {
        textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
    }
//	CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 60)];
//	CGSize textSize = [text boundingRectWithSize:CGSizeMake(280,60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + kComponentPadding, textSize.height + kComponentPadding)];
	label.backgroundColor = [UIColor clearColor];
    // 字体颜色：白色
//	label.textColor = [UIColor whiteColor];
    label.textColor = color;
	label.font = font;
	label.text = text;
	label.numberOfLines = 0;
	if (theSettings.useShadow) {
		label.shadowColor = [UIColor darkGrayColor];
		label.shadowOffset = CGSizeMake(1, 1);
	}
	
	UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
	if (image) {
		v.frame = [self _toastFrameForImageSize:image.size withLocation:[theSettings imageLocation] andTextSize:textSize];
        
        switch ([theSettings imageLocation]) {
            case WTToastImageLocationLeft:
                [label setTextAlignment:NSTextAlignmentLeft];
                label.center = CGPointMake(image.size.width + kComponentPadding * 2 
                                           + (v.frame.size.width - image.size.width - kComponentPadding * 2) / 2, 
                                           v.frame.size.height / 2);
                break;
            case WTToastImageLocationTop:
                [label setTextAlignment:NSTextAlignmentCenter];
                label.center = CGPointMake(v.frame.size.width / 2, 
                                           (image.size.height + kComponentPadding * 2 
                                            + (v.frame.size.height - image.size.height - kComponentPadding * 2) / 2));
                break;
            default:
                break;
        }
		
	} else {
		v.frame = CGRectMake(0, 0, textSize.width + kComponentPadding * 2+8, textSize.height + kComponentPadding * 2+8);
		label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
	}
	CGRect lbfrm = label.frame;
	lbfrm.origin.x = ceil(lbfrm.origin.x+2);
	lbfrm.origin.y = ceil(lbfrm.origin.y);
	label.frame = lbfrm;
	[v addSubview:label];
//	[label release];
	
	if (image) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = [self _frameForImage:type inToastFrame:v.frame];
		[v addSubview:imageView];
//		[imageView release];
	}
	
	v.backgroundColor = [UIColor colorWithRed:theSettings.bgRed green:theSettings.bgGreen blue:theSettings.bgBlue alpha:theSettings.bgAlpha];
	v.layer.cornerRadius = theSettings.cornerRadius;
	
	UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
	
	CGPoint point;
	
	// Set correct orientation/location regarding device orientation
	UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIApplication sharedApplication] statusBarOrientation];
	switch (orientation) {
		case UIDeviceOrientationPortrait:
		{
			if (theSettings.gravity == WTToastGravityTop) {
				point = CGPointMake(window.frame.size.width / 2, 45);
			} else if (theSettings.gravity == WTToastGravityBottom) {
				point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
			} else if (theSettings.gravity == WTToastGravityCenter) {
				point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
			} else {
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x + theSettings.offsetLeft, point.y + theSettings.offsetTop);
			break;
		}
		case UIDeviceOrientationPortraitUpsideDown:
		{
			v.transform = CGAffineTransformMakeRotation(M_PI);
			
			float width = window.frame.size.width;
			float height = window.frame.size.height;
			
			if (theSettings.gravity == WTToastGravityTop) {
				point = CGPointMake(width / 2, height - 45);
			} else if (theSettings.gravity == WTToastGravityBottom) {
				point = CGPointMake(width / 2, 45);
			} else if (theSettings.gravity == WTToastGravityCenter) {
				point = CGPointMake(width/2, height/2);
			} else {
				// TODO : handle this case
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x - theSettings.offsetLeft, point.y - theSettings.offsetTop);
			break;
		}
		case UIDeviceOrientationLandscapeLeft:
		{
			v.transform = CGAffineTransformMakeRotation(M_PI/2); //rotation in radians
			
			if (theSettings.gravity == WTToastGravityTop) {
				point = CGPointMake(window.frame.size.width - 45, window.frame.size.height / 2);
			} else if (theSettings.gravity == WTToastGravityBottom) {
				point = CGPointMake(45,window.frame.size.height / 2);
			} else if (theSettings.gravity == WTToastGravityCenter) {
				point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
			} else {
				// TODO : handle this case
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x - theSettings.offsetTop, point.y - theSettings.offsetLeft);
			break;
		}
		case UIDeviceOrientationLandscapeRight:
		{
			v.transform = CGAffineTransformMakeRotation(-M_PI/2);
			
			if (theSettings.gravity == WTToastGravityTop) {
				point = CGPointMake(45, window.frame.size.height / 2);
			} else if (theSettings.gravity == WTToastGravityBottom) {
				point = CGPointMake(window.frame.size.width - 45, window.frame.size.height/2);
			} else if (theSettings.gravity == WTToastGravityCenter) {
				point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
			} else {
				// TODO : handle this case
				point = theSettings.postition;
			}
			
			point = CGPointMake(point.x + theSettings.offsetTop, point.y + theSettings.offsetLeft);
			break;
		}
		default:
			break;
	}

	v.center = point;
	v.frame = CGRectIntegral(v.frame);
	
	NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000 
											 target:self selector:@selector(hideToast:) 
										   userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
	
	v.tag = CURRENT_TOAST_TAG;

	UIView *currentToast = [window viewWithTag:CURRENT_TOAST_TAG];
	if (currentToast != nil) {
    	[currentToast removeFromSuperview];
	}

	v.alpha = 0;
	[window addSubview:v];
	[UIView beginAnimations:nil context:nil];
	v.alpha = 1;
	[UIView commitAnimations];
	
//	view = [v retain];
//    view = [v retain];
//    __strong view =  v;
    view =  v;
	
	[v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
}

- (CGRect)_toastFrameForImageSize:(CGSize)imageSize withLocation:(WTToastImageLocation)location andTextSize:(CGSize)textSize {
    CGRect theRect = CGRectZero;
    switch (location) {
        case WTToastImageLocationLeft:
            theRect = CGRectMake(0, 0, 
                                 imageSize.width + textSize.width + kComponentPadding * 3, 
                                 MAX(textSize.height, imageSize.height) + kComponentPadding * 2);
            break;
        case WTToastImageLocationTop:
            theRect = CGRectMake(0, 0, 
                                 MAX(textSize.width, imageSize.width) + kComponentPadding * 2, 
                                 imageSize.height + textSize.height + kComponentPadding * 3);
            
        default:
            break;
    }    
    return theRect;
}

- (CGRect)_frameForImage:(WTToastType)type inToastFrame:(CGRect)toastFrame {
    WTToastSettings *theSettings = _settings;
    UIImage *image = [theSettings.images valueForKey:[NSString stringWithFormat:@"%i", type]];
    
    if (!image) return CGRectZero;
    
    CGRect imageFrame = CGRectZero;

    switch ([theSettings imageLocation]) {
        case WTToastImageLocationLeft:
            imageFrame = CGRectMake(kComponentPadding, (toastFrame.size.height - image.size.height) / 2, image.size.width, image.size.height);
            break;
        case WTToastImageLocationTop:
            imageFrame = CGRectMake((toastFrame.size.width - image.size.width) / 2, kComponentPadding, image.size.width, image.size.height);
            break;
            
        default:
            break;
    }
    
    return imageFrame;
    
}

- (void) hideToast:(NSTimer*)theTimer{
	[UIView beginAnimations:nil context:NULL];
	view.alpha = 0;
	[UIView commitAnimations];
	
	NSTimer *timer2 = [NSTimer timerWithTimeInterval:500 
											 target:self selector:@selector(hideToast:) 
										   userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

- (void) removeToast:(NSTimer*)theTimer{
	[view removeFromSuperview];
}


+ (WTToast *) makeText:(NSString *) _text{
    WTToast *toast = [[WTToast alloc] initWithText:_text] ;
    [toast setGravity:WTToastGravityCenter];
    [toast show:WTToastTypeInfo];
    return toast;
}


- (WTToast *) setDuration:(NSInteger ) duration{
	[self theSettings].duration = duration;
	return self;
}

- (WTToast *) setGravity:(WTToastGravity) gravity
			 offsetLeft:(NSInteger) left
			  offsetTop:(NSInteger) top{
	[self theSettings].gravity = gravity;
	[self theSettings].offsetLeft = left;
	[self theSettings].offsetTop = top;
	return self;
}

- (WTToast *) setGravity:(WTToastGravity) gravity{
	[self theSettings].gravity = gravity;
	return self;
}

- (WTToast *) setPostion:(CGPoint) _position{
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	
	return self;
}

- (WTToast *) setFontSize:(CGFloat) fontSize{
	[self theSettings].fontSize = fontSize;
	return self;
}

// 设置字体颜色：默认是白色
- (WTToast *) setFontColor:(UIColor *) fontColor{
	[self theSettings].fontColor = fontColor;
	return self;
}

- (WTToast *) setUseShadow:(BOOL) useShadow{
	[self theSettings].useShadow = useShadow;
	return self;
}

- (WTToast *) setCornerRadius:(CGFloat) cornerRadius{
	[self theSettings].cornerRadius = cornerRadius;
	return self;
}

- (WTToast *) setBgRed:(CGFloat) bgRed{
	[self theSettings].bgRed = bgRed;
	return self;
}

- (WTToast *) setBgGreen:(CGFloat) bgGreen{
	[self theSettings].bgGreen = bgGreen;
	return self;
}

- (WTToast *) setBgBlue:(CGFloat) bgBlue{
	[self theSettings].bgBlue = bgBlue;
	return self;
}

- (WTToast *) setBgAlpha:(CGFloat) bgAlpha{
	[self theSettings].bgAlpha = bgAlpha;
	return self;
}


-(WTToastSettings *) theSettings{
	if (!_settings) {
		_settings = [[WTToastSettings getSharedSettings] copy];
	}
	
	return _settings;
}

@end


@implementation WTToastSettings

 
- (void) setImage:(UIImage *) img withLocation:(WTToastImageLocation)location forType:(WTToastType) type {
	if (type == WTToastTypeNone) {
		// This should not be used, internal use only (to force no image)
		return;
	}
	
	if (!_images) {
		_images = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	
	if (img) {
		NSString *key = [NSString stringWithFormat:@"%i", type];
		[_images setValue:img forKey:key];
	}
    
    [self setImageLocation:location];
}

- (void)setImage:(UIImage *)img forType:(WTToastType)type {
    [self setImage:img withLocation:WTToastImageLocationLeft forType:type];
}


+ (WTToastSettings *) getSharedSettings{
	if (!sharedSettings) {
		sharedSettings = [WTToastSettings new];
		sharedSettings.gravity = WTToastGravityCenter;
		sharedSettings.duration = WTToastDurationShort;
		sharedSettings.fontSize = 14.0;
        sharedSettings.fontColor = [UIColor whiteColor]; // 默认是白色
		sharedSettings.useShadow = YES;
		sharedSettings.cornerRadius = 5.0;
		sharedSettings.bgRed = 0;
		sharedSettings.bgGreen = 0;
		sharedSettings.bgBlue = 0;
		sharedSettings.bgAlpha = 0.7;
		sharedSettings.offsetLeft = 0;
		sharedSettings.offsetTop = 0;
	}
	
	return sharedSettings;
	
}

- (id) copyWithZone:(NSZone *)zone{
	WTToastSettings *copy = [WTToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
	copy.fontSize = self.fontSize;
    copy.fontColor = self.fontColor;
	copy.useShadow = self.useShadow;
	copy.cornerRadius = self.cornerRadius;
	copy.bgRed = self.bgRed;
	copy.bgGreen = self.bgGreen;
	copy.bgBlue = self.bgBlue;
	copy.bgAlpha = self.bgAlpha;
	copy.offsetLeft = self.offsetLeft;
	copy.offsetTop = self.offsetTop;
	
	NSArray *keys = [self.images allKeys];
	
	for (NSString *key in keys){
		[copy setImage:[_images valueForKey:key] forType:[key intValue]];
	}
    
    [copy setImageLocation:_imageLocation];
	
	return copy;
}

@end
