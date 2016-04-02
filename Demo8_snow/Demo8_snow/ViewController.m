//
//  ViewController.m
//  Demo8_snow
//
//  Created by  江苏 on 16/3/3.
//  Copyright © 2016年 jiangsu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic) NSInteger count;
@end

#define FPS 30.0
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:1.0/FPS target:self selector:@selector(snowAnimate:) userInfo:nil repeats:YES];
}
//下一片雪
#define MAX_SIZE 10
#define MAX_DURATION 10
#define MAX_OFFSET 100
- (void)snowAnimate:(NSTimer *)timer {
    NSLog(@"snow count:%lu", (unsigned long)self.view.subviews.count);
    //1. 创建一片雪花,随机生成位置和大小
    UIImageView *snow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snow"]];
    int viewWidth = self.view.bounds.size.width;
    CGFloat size = arc4random() % MAX_SIZE + MAX_SIZE;
    snow.frame = CGRectMake(arc4random()%viewWidth, 0, size, size);
    [self.view addSubview:snow];
    self.count++;//计数器加1
    //拿到雪花的tag值
    snow.tag = self.count;
    
    //2. 让雪花落地(动画)
    //2.1 开始一个动画, 给动画起个名字
    [UIView beginAnimations:[NSString stringWithFormat:@"%ld", (long)self.count] context:nil];
    //2.2 设置动画的相关属性
    [UIView setAnimationDuration:arc4random() % MAX_DURATION + 2];//动画时长
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];//变速，越来越快
    //2.3 设置动画结束的状态
    int offsetX = arc4random() % MAX_OFFSET - 50;
    snow.center = CGPointMake(snow.center.x + offsetX, self.view.bounds.size.height-30);
    //2.4 设置动画的委托
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(snowDisappear:)];
    //2.5. 提交动画
    [UIView commitAnimations];
}

#define DISAPPEAR_DURATION 2
- (void)snowDisappear:(NSString *)animatedID
{
    //雪花消失的动画
    [UIView beginAnimations:animatedID context:nil];
    [UIView setAnimationDuration:arc4random()%DISAPPEAR_DURATION + 2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //找到落在地上的雪花对象
    UIView *snow = [self.view viewWithTag:[animatedID intValue]];
    snow.alpha = 0.0;
    //2.4 设置动画的委托
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(snowRemove:)];
    [UIView commitAnimations];
}

- (void)snowRemove:(NSString *)animatedID
{
    UIView *snow = [self.view viewWithTag:[animatedID intValue]];
    [snow removeFromSuperview];
}





@end
