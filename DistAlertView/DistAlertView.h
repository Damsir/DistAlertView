/*
 作者：  吴定如 <75081647@qq.com>
 文件：  DistAlertView.h
 版本：  1.0.1
 地址：  https://github.com/Damsir/DistAlertView
 描述：  自定义弹框alert
 更新：  自适应
 */

#import <UIKit/UIKit.h>

@class DistAlertView;

/**
 * block回调
 *
 * @param alert       DistAlertView对象自身
 * @param index       被点击按钮标识,取消: 0, 删除: -1, 其他: 1
 */
typedef void (^DistAlertBlock)(DistAlertView *alert, NSInteger index);


@interface DistAlertView : UIView


/**
 * 创建DistAlertView对象
 *
 * @param title                  标题
 * @param message                提示文本
 * @param cancelTitle            取消按钮文本
 * @param destructiveTitle       删除按钮文本
 * @param otherTitle             其他按钮文本
 * @param alertBlock             block回调
 *
 * @return DistAlertView对象
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle
             destructiveTitle:(NSString *)destructiveTitle
                   otherTitle:(NSString *)otherTitle
                      handler:(DistAlertBlock)alertBlock NS_DESIGNATED_INITIALIZER;

/**
 * 创建DistAlertView对象(便利构造器)
 *
 * @param title                  标题
 * @param message                提示文本
 * @param cancelTitle            取消按钮文本
 * @param destructiveTitle       删除按钮文本
 * @param otherTitle             其他按钮文本
 * @param alertBlock             block回调
 *
 * @return DistAlertView对象
 */
+ (instancetype)alertWithTitle:(NSString *)title
                        message:(NSString *)message
                    cancelTitle:(NSString *)cancelTitle
               destructiveTitle:(NSString *)destructiveTitle
                     otherTitle:(NSString *)otherTitle
                        handler:(DistAlertBlock)alertBlock;

/**
 * 弹出DistAlertView视图
 *
 * @param title                  标题
 * @param message                提示文本
 * @param cancelTitle            取消按钮文本
 * @param destructiveTitle       删除按钮文本
 * @param otherTitle             其他按钮文本
 * @param alertBlock             block回调
 *
 */
+ (void)showAlertWithTitle:(NSString *)title
                        message:(NSString *)message
                    cancelTitle:(NSString *)cancelTitle
               destructiveTitle:(NSString *)destructiveTitle
                     otherTitle:(NSString *)otherTitle
                        handler:(DistAlertBlock)alertBlock;

/**
 * 弹出视图
 */
- (void)show;

/**
 * 收起视图
 */
- (void)dismiss;

@end
