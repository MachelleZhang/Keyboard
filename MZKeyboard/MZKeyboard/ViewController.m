//
//  ViewController.m
//  MZKeyboard
//
//  Created by zhangle on 15/10/22.
//  Copyright © 2015年 Machelle. All rights reserved.
//
//  参考代码原地址：http://www.cocoachina.com/swift/20151020/13740.html

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册点击事件，点击背景，隐藏键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToClose)];
    [self.view addGestureRecognizer:tapGesture];

    //添加键盘弹出和收回的通知
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

//收到键盘弹出通知后的响应
- (void)keyboardWillShow:(NSNotification *)info {
    //保存info
    NSDictionary *dict = info.userInfo;
    //得到键盘的显示完成后的frame
    CGRect keyboardBounds = [dict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //得到键盘弹出动画的时间
    double duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //坐标系转换
    //由于取出的位置信息是绝对的，所以要将其转换为对应于当前view的位置，否则位置信息会出错！
    CGRect keyboardBoundsRect = [self.view convertRect:keyboardBounds toView:nil];
    //得到键盘的高度，即输入框需要移动的距离
    double offsetY = keyboardBoundsRect.size.height;
    //得到键盘动画的曲线信息，按原作的话说“此处是难点”，stackoverflow网站里找到的
    UIViewAnimationOptions options = [dict[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    //添加动画
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        _textField.transform = CGAffineTransformMakeTranslation(0, -offsetY);
    } completion:nil];
   
}

//隐藏键盘通知的响应
- (void)keyboardWillHide:(NSNotification *)info {
    //输入框回去的时候就不需要高度了，直接取动画时间和曲线还原回去
    NSDictionary *dict = info.userInfo;
    double duration = [dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = [dict[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16;
    //CGAffineTransformIdentity是置位，可将改变的transform还原
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        _textField.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

//点击背景的响应
- (void)tapToClose {
    //输入框失去焦点
    _textField.resignFirstResponder;
}

@end
