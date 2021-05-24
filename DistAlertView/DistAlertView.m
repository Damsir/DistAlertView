/*
 作者：  吴定如 <75081647@qq.com>
 文件：  DistAlertView.m
 版本：  1.0.4
 地址：  https://github.com/Damsir/DistAlertView
 描述：  自定义弹框alert
 更新：
 */

#import "DistAlertView.h"

#define AlertWidth 275

static const CGFloat kTitleFontSize = 17.0f;
static const CGFloat kContentFontSize = 15.0f;
static const CGFloat kButtonTitleFontSize = 16.0f;

@interface DistAlertView()

/** block回调 */
@property (copy, nonatomic) DistAlertBlock alertBlock;
/** 背景图片 */
@property (strong, nonatomic) UIView *backgroundView;
/** 弹出视图 */
@property (strong, nonatomic) UIView *alertView;

@end


@implementation DistAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithTitle:nil message:nil cancelTitle:nil destructiveTitle:nil otherTitle:nil handler:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithTitle:nil message:nil cancelTitle:nil destructiveTitle:nil otherTitle:nil handler:nil];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle otherTitle:(NSString *)otherTitle handler:(DistAlertBlock)alertBlock {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _alertBlock = alertBlock;
        // 默认高度
        CGFloat alertHeight = 20;
        
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        [self addSubview:_backgroundView];
        
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(AlertWidth / 2, 0, AlertWidth, 0)];
        _alertView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.layer.cornerRadius = 10.0f;
        _alertView.layer.masksToBounds = YES;
        [self addSubview:_alertView];
        
        // 标题
        if (title.length > 0 && title != nil) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, alertHeight, AlertWidth, 20)];
            titleLabel.text = title;
            titleLabel.textColor = [self colorFromHexRGB:@"333333"];
//            titleLabel.textColor = [self colorFromHexRGB:@"878787"];
            titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize weight:UIFontWeightMedium];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [_alertView addSubview:titleLabel];
            
            alertHeight = (message.length > 0 && message != nil) ? CGRectGetMaxY(titleLabel.frame) + 8 : CGRectGetMaxY(titleLabel.frame) + 20;
        }
        
        // 内容
        if (message.length > 0 && message != nil) {
            CGSize size = [message boundingRectWithSize:CGSizeMake(AlertWidth - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kContentFontSize]} context:nil].size;
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, alertHeight, AlertWidth - 50, ceil(size.height))];
            contentLabel.text = message;
//            contentLabel.textColor = [self colorFromHexRGB:@"515151"];
            contentLabel.textColor = [self colorFromHexRGB:@"404040"];
            contentLabel.font = [UIFont systemFontOfSize:kContentFontSize];
            contentLabel.numberOfLines = 0;
            contentLabel.textAlignment = NSTextAlignmentCenter;
            [_alertView addSubview:contentLabel];
            
            alertHeight = CGRectGetMaxY(contentLabel.frame) + 20;
        }
        
        // 按钮上面的线条
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, alertHeight, AlertWidth, 0.5)];
        line.backgroundColor = [self colorFromHexRGB:@"EEEEEE"];
        [_alertView addSubview:line];
        // 取消按钮
        if (cancelTitle.length > 0 && cancelTitle != nil) {
            // 取消按钮 删除按钮
            if (destructiveTitle.length > 0 && destructiveTitle != nil) {
                // 左侧按钮
                UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, alertHeight, AlertWidth/2, 50)];
                [leftBtn setTitle:cancelTitle forState:UIControlStateNormal];
                [leftBtn setTitleColor:[self colorFromHexRGB:@"404040"] forState:UIControlStateNormal];
                leftBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize weight:UIFontWeightMedium];
                leftBtn.tag = 0;
                [leftBtn addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_alertView addSubview:leftBtn];
                
                // 按钮上面的线条
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame), alertHeight + 0.5, 0.5, leftBtn.frame.size.height - 0.5)];
                line.backgroundColor = [self colorFromHexRGB:@"EEEEEE"];
                [_alertView addSubview:line];
                
                // 右侧按钮
                UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(AlertWidth/2, alertHeight, AlertWidth/2, 50)];
                [rightBtn setTitle:destructiveTitle forState:UIControlStateNormal];
                [rightBtn setTitleColor:[UIColor colorWithRed:230.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
                rightBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize weight:UIFontWeightMedium];
                rightBtn.tag = -1;
                [rightBtn addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_alertView addSubview:rightBtn];
            }
            // 取消按钮 其他按钮
            else if (otherTitle.length > 0 && otherTitle != nil) {
                // 左侧按钮
                UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, alertHeight, AlertWidth/2, 50)];
                [leftBtn setTitle:cancelTitle forState:UIControlStateNormal];
                [leftBtn setTitleColor:[self colorFromHexRGB:@"404040"] forState:UIControlStateNormal];
                leftBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize weight:UIFontWeightMedium];
                leftBtn.tag = 0;
                [leftBtn addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_alertView addSubview:leftBtn];
                
                // 按钮上面的线条
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame), alertHeight + 0.5, 0.5, leftBtn.frame.size.height - 0.5)];
                line.backgroundColor = [self colorFromHexRGB:@"EEEEEE"];
                [_alertView addSubview:line];
                
                // 右侧按钮
                UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(AlertWidth/2, alertHeight, AlertWidth/2, 50)];
                [rightBtn setTitle:otherTitle forState:UIControlStateNormal];
                [rightBtn setTitleColor:[self colorFromHexRGB:@"4886E0"] forState:UIControlStateNormal];
                rightBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize weight:UIFontWeightMedium];
                rightBtn.tag = 1;
                [rightBtn addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_alertView addSubview:rightBtn];
            } else {
                // 只有取消按钮
                UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, alertHeight, AlertWidth, 50)];
                [leftBtn setTitle:cancelTitle forState:UIControlStateNormal];
                [leftBtn setTitleColor:[self colorFromHexRGB:@"404040"] forState:UIControlStateNormal];
                leftBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize weight:UIFontWeightMedium];
                leftBtn.tag = 0;
                [leftBtn addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [_alertView addSubview:leftBtn];
            }
            
            alertHeight += 50;
        }
        // 只有其他按钮
        if ((!cancelTitle.length || cancelTitle == nil) && (!destructiveTitle.length || destructiveTitle == nil) && (otherTitle.length > 0 && otherTitle != nil)) {
            UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, alertHeight, AlertWidth, 50)];
            [leftBtn setTitle:otherTitle forState:UIControlStateNormal];
            [leftBtn setTitleColor:[self colorFromHexRGB:@"4886E0"] forState:UIControlStateNormal];
            leftBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize weight:UIFontWeightMedium];
            leftBtn.tag = 1;
            [leftBtn addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:leftBtn];
            
            alertHeight += 50;
        }
        // 只有删除按钮
        if ((!cancelTitle.length || cancelTitle == nil) && (!otherTitle.length || otherTitle == nil) && (destructiveTitle.length > 0 && destructiveTitle != nil)) {
            UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, alertHeight, AlertWidth, 50)];
            [leftBtn setTitle:destructiveTitle forState:UIControlStateNormal];
//            [leftBtn setTitleColor:[self colorFromHexRGB:@"4886E0"] forState:UIControlStateNormal];
            [leftBtn setTitleColor:[UIColor colorWithRed:230.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            leftBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize weight:UIFontWeightMedium];
            leftBtn.tag = -1;
            [leftBtn addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:leftBtn];
            
            alertHeight += 50;
        }
        // 其他按钮 删除按钮
        if ((!cancelTitle.length || cancelTitle == nil) && (otherTitle.length > 0 && otherTitle != nil) && (destructiveTitle.length > 0 && destructiveTitle != nil)) {
            // 左侧按钮
            UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, alertHeight, AlertWidth/2, 50)];
            [leftBtn setTitle:otherTitle forState:UIControlStateNormal];
            [leftBtn setTitleColor:[self colorFromHexRGB:@"4886E0"] forState:UIControlStateNormal];
            leftBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize weight:UIFontWeightMedium];
            leftBtn.tag = 1;
            [leftBtn addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:leftBtn];
            
            // 按钮上面的线条
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame), alertHeight + 0.5, 0.5, leftBtn.frame.size.height - 0.5)];
            line.backgroundColor = [self colorFromHexRGB:@"EEEEEE"];
            [_alertView addSubview:line];
            
            // 右侧按钮
            UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(AlertWidth/2, alertHeight, AlertWidth/2, 50)];
            [rightBtn setTitle:destructiveTitle forState:UIControlStateNormal];
            [rightBtn setTitleColor:[UIColor colorWithRed:230.0f/255.0f green:66.0f/255.0f blue:66.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:kButtonTitleFontSize weight:UIFontWeightMedium];
            rightBtn.tag = -1;
            [rightBtn addTarget:self action:@selector(alertBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:rightBtn];
            
            alertHeight += 50;
        }
        
        _alertView.frame = CGRectMake(AlertWidth/2, 0, AlertWidth, alertHeight);
        _alertView.center = self.center;
    }
    return self;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle otherTitle:(NSString *)otherTitle handler:(DistAlertBlock)alertBlock {
    return [[self alloc] initWithTitle:title message:message cancelTitle:cancelTitle destructiveTitle:destructiveTitle otherTitle:otherTitle handler:alertBlock];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle destructiveTitle:(NSString *)destructiveTitle otherTitle:(NSString *)otherTitle handler:(DistAlertBlock)alertBlock {
    DistAlertView *alertView = [self alertWithTitle:title message:message cancelTitle:cancelTitle destructiveTitle:destructiveTitle otherTitle:otherTitle handler:alertBlock];
    [alertView show];
}

- (void)show {
    // 在主线程中处理,否则在viewDidLoad方法中直接调用,会先加本视图,后加控制器的视图到UIWindow上,导致本视图无法显示出来,这样处理后便会优先加控制器的视图到UIWindow上
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                [window addSubview:self];
                break;
            }
        }
        if (self.alertView) {
            self.alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            self.alertView.alpha = 0.0f;
            [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                self.alertView.alpha = 1.0f;
            } completion:nil];
        }
    }];
}

- (void)dismiss {
//    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.backgroundView.alpha = 0.0f;
//        self.alertView.frame = CGRectMake(CGRectGetMinX(self.alertView.frame), self.frame.size.height, _alertView.frame.size.width,_alertView.frame.size.height);
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    [self removeFromSuperview];
}

- (void)alertBtnClicked:(UIButton *)button {
    if (self.alertBlock) {
        self.alertBlock(self, button.tag);
    }
    [self dismiss];
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"DistAlertView dealloc");
#endif
}

#pragma mark - 字体颜色
/*!
 * @method 通过16进制计算颜色
 * @result 颜色对象
 */
- (UIColor *)colorFromHexRGB:(NSString *)inColorString {
    
    NSString *cString = [[inColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if (cString.length < 6)
    {
        return [UIColor blackColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if (cString.length != 6)
    {
        return [UIColor blackColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //   OutLog(@"r=%f,g=%f,b=%f",(float)r,(float)g,(float)b);
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
