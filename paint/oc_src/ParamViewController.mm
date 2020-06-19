//
//  ParamControllerViewController.m
//  paint
//
//  Created by yhs on 2020/5/21.
//  Copyright © 2020 yhs. All rights reserved.
//

#import "ParamViewController.h"


#define bigWid [UIScreen mainScreen].bounds.size.width
#define bigHei [UIScreen mainScreen].bounds.size.height

@interface ParamViewController ()

@property(nonatomic, strong)ParamView* paramView;

@end

@implementation ParamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //为了弹出框效果,要把背景透明
    self.view.backgroundColor = [UIColor clearColor];
    
    //这里开始都是布局代码  义了两个宏一个bigWid 一个bigHei 分别是屏幕的宽和高
    self.paramView = [[ParamView alloc] initWithFrame:CGRectMake(0, bigHei * 2/3. - 30, bigWid, bigHei/3. + 30)];
    self.paramView.backgroundColor = [UIColor whiteColor];
    self.paramView.layer.cornerRadius = 5;
    [self.view addSubview:self.paramView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeParamView:) name:@"cancel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateParam:) name:@"ok" object:nil];

}

-(void)closeParamView :(NSNotification*)notification {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateParam :(NSNotification*)notification {
    NSDictionary* param = notification.userInfo;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateParam" object:nil userInfo:param];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
