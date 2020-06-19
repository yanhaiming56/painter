//
//  ParamView.m
//  paint
//
//  Created by yhs on 2020/5/21.
//  Copyright © 2020 yhs. All rights reserved.
//

#import "ParamView.h"
#import "Utility.hpp"

@interface ParamView ()

enum COLOR {
    RED = 0,
    GREEN,
    BLUE,
    ALPHA
};

@property(nonatomic, strong)UISlider* sldRed;
@property(nonatomic, strong)UISlider* sldGreen;
@property(nonatomic, strong)UISlider* sldBlue;
@property(nonatomic, strong)UISlider* sldAlpha;
@property(nonatomic, strong)UITextField* txtLineWidth;
@property(nonatomic, strong)UISwitch* swtFill;
@property(nonatomic, strong)UISwitch* swtClose;
@property(nonatomic, strong)UILabel* lbColor;

@end

@implementation ParamView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self deployView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self deployView];
    }
    return self;
}

-(BOOL)deployView {
    CGSize pvSize = self.frame.size;
    self.sldRed = [[UISlider alloc] init];
    [self designSlider:self.sldRed Size:CGRectMake(70, pvSize.height*4/30, pvSize.width - 90, 15) Color:RED];
    
    self.sldGreen = [[UISlider alloc] init];
    [self designSlider:self.sldGreen Size:CGRectMake(70, pvSize.height*8/30, pvSize.width - 90, 15) Color:GREEN];

    self.sldBlue = [[UISlider alloc] init];
    [self designSlider:self.sldBlue Size:CGRectMake(70, pvSize.height*12/30, pvSize.width - 90, 15) Color:BLUE];
    
    self.sldAlpha = [[UISlider alloc] init];
    [self designSlider:self.sldAlpha Size:CGRectMake(70, pvSize.height*16/30, pvSize.width - 90, 15) Color:ALPHA];
    
    self.txtLineWidth = [[UITextField alloc] initWithFrame:CGRectMake(70, pvSize.height*20/30 - 5, 50, 25)];
    self.txtLineWidth.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    self.txtLineWidth.borderStyle = UITextBorderStyleRoundedRect;
    self.txtLineWidth.text = @"1";
    [self addSubview:self.txtLineWidth];
    UILabel* labelLineWidth= [[UILabel alloc] initWithFrame:CGRectMake(20, pvSize.height*20/30, 50, 15)];
    [labelLineWidth setText:@"线宽："];
    [self addSubview:labelLineWidth];
    
    self.swtFill = [[UISwitch alloc] initWithFrame:CGRectMake(170, pvSize.height*20/30 - 10, 30, 5)];
    //self.tintColor = [UIColor grayColor];
    [self addSubview:self.swtFill];
    UILabel* labelFill= [[UILabel alloc] initWithFrame:CGRectMake(130, pvSize.height*20/30, 50, 15)];
    [labelFill setText:@"填充"];
    [self addSubview:labelFill];
    
    self.swtClose = [[UISwitch alloc] initWithFrame:CGRectMake(270, pvSize.height*20/30 - 10, 30, 5)];
    //self.Close.tintColor = [UIColor grayColor];
    [self.swtClose addTarget:self action:@selector(closeValueChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.swtClose];
    UILabel* labelClose= [[UILabel alloc] initWithFrame:CGRectMake(230, pvSize.height*20/30, 50, 15)];
    [labelClose setText:@"闭合"];
    [self addSubview:labelClose];
    
    self.lbColor = [[UILabel alloc] initWithFrame:CGRectMake(pvSize.width-70, pvSize.height*20/30 - 20, 50, 50)];
    self.lbColor.layer.borderWidth = 1;
    self.lbColor.layer.borderColor = [UIColor blackColor].CGColor;
    self.lbColor.layer.cornerRadius = 5;
    self.lbColor.layer.masksToBounds = YES;
    self.lbColor.layer.backgroundColor = [[UIColor alloc] initWithRed:self.sldRed.value/255. green:self.sldGreen.value/255. blue:self.sldBlue.value/255. alpha:self.sldAlpha.value/255.].CGColor;
    [self addSubview:self.lbColor ];

    //分割线
    UIView *deView = [[UIView alloc]initWithFrame:CGRectMake(0, pvSize.height*4/5, pvSize.width, 1)];
    deView.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
    [self addSubview:deView];
    
    //确定按钮
    UIButton* btnOK = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    btnOK.frame = CGRectMake(pvSize.width - 130, pvSize.height*4/5, 60, 30);
    [self addSubview:btnOK];
    [btnOK addTarget:self action:@selector(btnOKAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消按钮
    UIButton* btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnCancel.frame = CGRectMake(pvSize.width - 80, pvSize.height*4/5, 60, 30);
    [self addSubview:btnCancel];
    [btnCancel addTarget:self action:@selector(btnCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];//键盘的弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil]; //键盘的消失

    return YES;
}

-(void)closeValueChange:(id)sender {
    if(self.swtClose.on)
        self.swtFill.on = YES;
}

-(void)designSlider:(UISlider*)slider Size:(CGRect)frame Color:(COLOR)color {
    if(slider == nil)
        slider = [[UISlider alloc] initWithFrame:frame];
    else
        slider.frame = frame;
    
    slider.minimumValue = 0.;
    slider.maximumValue = 255.;
    slider.continuous = YES;
    slider.maximumTrackTintColor = [UIColor whiteColor];
    [slider addTarget:self action:@selector(colorValueChange:) forControlEvents:UIControlEventValueChanged];
    
    switch (color) {
        case RED: {
            slider.minimumTrackTintColor = [UIColor redColor];
            UILabel* labelRed = [[UILabel alloc] initWithFrame:CGRectMake(20, frame.origin.y, 50, 15)];
            [labelRed setText:@"红色："];
            [self addSubview:labelRed];
        }
            break;
        case GREEN: {
            slider.minimumTrackTintColor = [UIColor greenColor];
            UILabel* labelGreen = [[UILabel alloc] initWithFrame:CGRectMake(20, frame.origin.y, 50, 15)];
            [labelGreen setText:@"绿色："];
            [self addSubview:labelGreen];
        }
            break;
        case BLUE: {
            slider.minimumTrackTintColor = [UIColor blueColor];
            UILabel* labelBlue= [[UILabel alloc] initWithFrame:CGRectMake(20, frame.origin.y, 50, 15)];
            [labelBlue setText:@"蓝色："];
            [self addSubview:labelBlue];
        }
            break;
        case ALPHA: {
            slider.value = slider.maximumValue;
            slider.minimumTrackTintColor = [UIColor clearColor];
            slider.maximumTrackTintColor = [UIColor clearColor];
            NSArray* colors = @[[UIColor whiteColor], [UIColor blackColor]];
            UIImage* img = gradientImageWithBounds(slider.bounds, colors, HORIZON);
            [slider setMinimumTrackImage:img forState:UIControlStateNormal] ;
            UILabel* labelBlue= [[UILabel alloc] initWithFrame:CGRectMake(20, frame.origin.y, 50, 15)];
            [labelBlue setText:@"透明："];
            [self addSubview:labelBlue];
        }
            break;
        default:
            break;
    }
    
    [self addSubview:slider];
}

//确定按钮
- (void)btnOKAction:(id)sender {
    NSDictionary* dic = @{
        @"color":[UIColor colorWithRed:self.sldRed.value/255. green:self.sldGreen.value/255. blue:self.sldBlue.value/255. alpha:self.sldAlpha.value/255.],
        @"lineWidth":[NSNumber numberWithFloat:[self.txtLineWidth.text floatValue]],
        @"Fill":[NSNumber numberWithBool:self.swtFill.on],
        @"Close":[NSNumber numberWithBool:self.swtClose.on],
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ok" object:nil userInfo:dic];
}

//返回按钮
- (void)btnCancelAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancel" object:nil];
}

- (void)colorValueChange:(id)sender {
    self.lbColor.layer.backgroundColor = [UIColor colorWithRed:self.sldRed.value/255. green:self.sldGreen.value/255. blue:self.sldBlue.value/255. alpha:self.sldAlpha.value/255.].CGColor;
    [self.lbColor setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.txtLineWidth endEditing:YES];
}

-(void)transformView:(NSNotification*)notification {
    //获取键盘弹出前的Rect
    NSValue* keyBoardBeginBounds=[[notification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyBoardBeginBounds CGRectValue];
    
    //获取键盘弹出后的Rect
    NSValue*keyBoardEndBounds=[[notification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endRect=[keyBoardEndBounds CGRectValue];
    
    //获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    //NSLog(@"看看这个变化的Y值:%f",deltaY);
    
    //在0.25s内完成view的Frame的变化，等于是给view添加一个向上移动deltaY的动画
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+deltaY, self.frame.size.width, self.frame.size.height);
    }];
    
}

-(void)keyboardWillHide:(NSNotification*)notification {
}

@end
