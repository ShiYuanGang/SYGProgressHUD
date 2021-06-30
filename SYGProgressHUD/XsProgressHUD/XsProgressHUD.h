//
//  XsProgressHUD.h
//  XsProgressHUD
//
//  Created by Shi Yuan Gang on 2021/4/14.
//  Copyright © 2021 dtx. All rights reserved.
//  统一以后的loading和消息提示,方便后期定制化统一修改（后期修改只需要修改内核代码就行了）
//  建议在业务层调用(即需不需要显示和消失时机由自己控制)
//  如有特殊样式和提示在本类扩展

#import <UIKit/UIKit.h>

/**
 hud 显示位置
 */
typedef NS_ENUM(NSUInteger, XsProgressHUDPosition) {
    /// 中间
    XsProgressHUDPositionCenter,
    /// 顶部
    XsProgressHUDPositionTop,
    /// 底部
    XsProgressHUDPositionBottom
};

@interface XsProgressHUD : UIView

///------------
/// 全屏loading
///------------

+ (void)showHUD;
+ (void)hideHUD;

///------------
/// 建议用如下两个方法，自己管理（不过就是多写两处代码，但是能保证之前创建的网络请求因为“延时”回调不会影响当前页面的 loading ；因为获取到的 weakSelf = nil）
///------------

/// 在指定的view上显示loading hud
/// @param view 指定的view
+ (void)showHUDAddedTo:(UIView *)view;

/// 隐藏loading hud
/// @param view 指定的view上
+ (void)hideHUDForView:(UIView *)view;

///------------
/// 新提示
///------------

///  显示一个提示消息，居中显示，1.2s消失
/// @param string 需要显示的message
+ (void)showMessage:(NSString *)string;

/// 显示一个提示消息，顶部显示，1.2s消失
/// @param string 需要显示的message
+ (void)showTopMessage:(NSString *)string;

/// 显示一个提示消息，底部显示，1.2s消失
/// @param string 需要显示的message
+ (void)showBottomMessage:(NSString *)string;

/// 显示一个提示消息，1.2s消失
/// @param string 需要显示的message
/// @param position 显示的位置
+ (void)showMessage:(NSString *)string position:(JYBProgressHUDPosition)position;

/// 显示一个提示消息
/// @param string 需要显示的message
/// @param position 显示的位置
/// @param delay 消失时间
+ (void)showMessage:(NSString *)string position:(JYBProgressHUDPosition)position dismissWithDelay:(NSTimeInterval)delay;

///------------
/// 懒人用法（如果网络请求不用中间层过渡，直接在 “ViewController” 创建用block回调；就算ViewController释放了，创建的block依然会执行回调，这时候调用 “hideAutoHUD” 可能会影响到当前页面的 loading ）
///------------
 
/// 注意一定要在当前的ViewController 显示出来才调用；否者还是使用上面的方法
/// 自动显示在当前的 ViewController 上；如当前的ViewController包含”导航栏“ 不会影响返回
+ (void)showAutoHUD DEPRECATED_MSG_ATTRIBUTE("Please use the showHUDAddedTo: instead");

/// 隐藏loading hud，注意：在使用 `hideAutoHUD` 出现问题后请开发者用 `hideHUDForView` 传自己的当前ViewController的view，如继续通过全局获取当前ViewController.view 还是会出现之前的问题，这里强烈建议大家把 loading 的调用写在业务层 ViewController，不要耦合在 `model` 或者 `viewModel` 里面
+ (void)hideAutoHUD DEPRECATED_MSG_ATTRIBUTE("Please use the hideHUDForView: instead");

@end


///------------
/// 废弃的方法 现在只做提示用（提示请调用新方法）
///------------

@interface XsProgressHUD (Deprecated)

/// 成功状态的提示
/// @param status message
+ (void)showSuccessWithStatus:(NSString *)status DEPRECATED_MSG_ATTRIBUTE("Please use the showMessage: instead");
+ (void)showSuccessWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay DEPRECATED_MSG_ATTRIBUTE("Please use the showMessage: instead");

/// 错误状态提示
/// @param status message
+ (void)showErrorWithStatus:(NSString *)status DEPRECATED_MSG_ATTRIBUTE("Please use the showMessage: instead");
+ (void)showErrorWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay DEPRECATED_MSG_ATTRIBUTE("Please use the showMessage: instead");

+ (void)showWithStatus:(NSString *)status DEPRECATED_MSG_ATTRIBUTE("Please use the showMessage: instead");
+ (void)showWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay DEPRECATED_MSG_ATTRIBUTE("Please use the showMessage: instead");

+ (void)showInfoWithStatus:(NSString*)status DEPRECATED_MSG_ATTRIBUTE("Please use the showMessage: instead");
+ (void)showInfoWithStatus:(NSString*)status dismissWithDelay:(NSTimeInterval)delay DEPRECATED_MSG_ATTRIBUTE("Please use the showMessage: instead");

@end
