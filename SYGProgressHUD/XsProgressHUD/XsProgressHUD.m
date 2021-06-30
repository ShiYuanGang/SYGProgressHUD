//
//  JYBProgressHUD.m
//  JYBProgressHUD
//
//  Created by Fan Li Lin on 2021/4/14.
//

#import "XsProgressHUD.h"
#import "MBProgressHUD.h"
#import <Lottie/LOTAnimationView.h>

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
    if (dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) == dispatch_queue_get_label(dispatch_get_main_queue())) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif

/// 用来专门显示 需要全屏覆盖的loading的界面
static __weak MBProgressHUD *loadHud;

/// 用来专门显示提示消息的
static __weak MBProgressHUD *messageHud;

@interface XsProgressHUD ()

@end

@implementation XsProgressHUD

+ (NSBundle *)resourceBundle
{
    static NSBundle *resourceBundle = nil;
    if (!resourceBundle) {
        NSBundle *mainBundle = [NSBundle bundleForClass:self];
        NSString *resourcePath = [mainBundle pathForResource:@"XsProgressHUD_Resources" ofType:@"bundle"];
        resourceBundle = [NSBundle bundleWithPath:resourcePath] ?: mainBundle;
    }
    return resourceBundle;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(80, 80);
}

+ (void)showHUD
{
    dispatch_main_async_safe(^{
        if (!loadHud || loadHud.finished) {
            MBProgressHUD *hud = [self.class HUDForView:[self.class contentView]];
            loadHud = hud;
        }else {
            UIView *contentView = [self.class contentView];
            if (loadHud.superview != contentView) {
                [contentView addSubview:loadHud];
            }
        }

        /// show
        [loadHud showAnimated:YES];
    });
}

+ (void)hideHUD
{
    dispatch_main_async_safe(^{
        if (loadHud || loadHud.hasFinished == NO) {
            loadHud.removeFromSuperViewOnHide = YES;
            [loadHud hideAnimated:YES];
        }
    })
}

+ (void)showAutoHUD
{
    dispatch_main_async_safe(^{
        [self showHUDAddedTo:[self.class currentViewController].view];
    });
}

+ (void)hideAutoHUD
{
    dispatch_main_async_safe(^{
        [self.class hideHUDForView:[self.class currentViewController].view];
    });
}

+ (void)showHUDAddedTo:(UIView *)view
{
    [self.class showHUDAddedTo:view animated:YES];
}

+ (void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
    if (!view) {
        return;
    }
    dispatch_main_async_safe(^{
        MBProgressHUD *hud = [self.class HUDForView:view];
        [hud showAnimated:animated];
    });
}

+ (MBProgressHUD *)HUDForView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud || hud.tag != 500003) {
        hud = [[MBProgressHUD alloc] initWithView:view];
        hud.tag = 500003;
        hud.backgroundView.color = [UIColor clearColor];
        hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor clearColor];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        
        UIView *contentView = [XsProgressHUD new];
        contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        contentView.layer.cornerRadius = 10;
        hud.customView = contentView;
    
        NSURL *url = [[XsProgressHUD resourceBundle] URLForResource:@"XsProgressHUD" withExtension:@"bundle"];
        
        LOTAnimationView *animation = [LOTAnimationView animationNamed:@"loading_2" inBundle:[NSBundle bundleWithURL:url]];
        animation.backgroundColor = [UIColor clearColor];
        animation.frame = CGRectMake(0, 0, 50, 50);
        animation.center = CGPointMake(contentView.intrinsicContentSize.width * 0.5, contentView.intrinsicContentSize.height * 0.5);
        animation.loopAnimation = YES;
        [contentView addSubview:animation];
        [animation play];
    }
    
    if (!hud.superview) {
        [view addSubview:hud];
    }else {
        [view bringSubviewToFront:hud];
    }
    return hud;
}

+ (void)hideHUDForView:(UIView *)view
{
    [self.class hideHUDForView:view animated:YES];
}

+ (void)hideHUDForView:(UIView *)view animated:(BOOL)animated
{
    if (!view) {
        return;
    }
    dispatch_main_async_safe(^{
        [MBProgressHUD hideHUDForView:view animated:animated];
    });
}

+ (void)showMessage:(NSString *)string
{
    [self.class showMessage:string position:XsProgressHUDPositionCenter];
}

+ (void)showTopMessage:(NSString *)string
{
    [self.class showMessage:string position:XsProgressHUDPositionTop];
}

+ (void)showBottomMessage:(NSString *)string
{
    [self.class showMessage:string position:XsProgressHUDPositionBottom];
}

+ (void)showMessage:(NSString *)string position:(XsProgressHUDPosition)position
{
    [self.class showMessage:string position:position dismissWithDelay:1.2f];;
}

+ (void)showMessage:(NSString *)string position:(XsProgressHUDPosition)position dismissWithDelay:(NSTimeInterval)delay
{
    dispatch_main_async_safe(^{
        if (!messageHud || messageHud.hasFinished) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[self.class contentView] animated:YES];
            hud.userInteractionEnabled = NO;
            hud.mode = MBProgressHUDModeText;
            hud.label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
            hud.label.numberOfLines = 0;
            hud.label.textColor = UIColor.whiteColor;
            hud.backgroundView.color = [UIColor clearColor];
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            hud.margin = 20;
            hud.verticalMargin = 12;
            messageHud = hud;
        }
        messageHud.label.text = string;
        switch (position) {
            case XsProgressHUDPositionCenter:
                messageHud.offset = CGPointMake(0.f, 0.f);
                break;
            case XsProgressHUDPositionTop:
                messageHud.offset = CGPointMake(0.f, -MBProgressMaxOffset);
                break;
            case XsProgressHUDPositionBottom:
                messageHud.offset = CGPointMake(0.f, 250);
                break;
            default:
                break;
        }
        [messageHud hideAnimated:YES afterDelay:delay];
    });
}

#pragma mark - other

+ (UIView *)contentView
{
    UIView *view;
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            view = window;
            break;
        }
    }
    return view;
}

+ (UIViewController *)currentViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self currentViewControllerFrom:rootViewController];
}

+ (UIViewController *)currentViewControllerFrom:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    } else if(viewController.presentedViewController != nil) {
        return [self currentViewControllerFrom:viewController.presentedViewController];
    } else {
        return viewController;
    }
}

@end


@implementation XsProgressHUD (Deprecated)

+ (void)showSuccessWithStatus:(NSString *)status
{
    [XsProgressHUD showMessage:status];
}

+ (void)showSuccessWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay
{
    [XsProgressHUD showMessage:status];
}

+ (void)showErrorWithStatus:(NSString *)status
{
    [XsProgressHUD showMessage:status];
}

+ (void)showErrorWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay
{
    [XsProgressHUD showMessage:status];
}

+ (void)showWithStatus:(NSString *)status
{
    [XsProgressHUD showMessage:status];
}

+ (void)showWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay
{
    [XsProgressHUD showMessage:status];
}

+ (void)showInfoWithStatus:(NSString *)status
{
    [XsProgressHUD showMessage:status];
}

+ (void)showInfoWithStatus:(NSString*)status dismissWithDelay:(NSTimeInterval)delay
{
    [XsProgressHUD showMessage:status];
}

@end
