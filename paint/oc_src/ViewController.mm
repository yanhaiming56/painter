//
//  ViewController.m
//  paint
//
//  Created by yhs on 2020/5/14.
//  Copyright © 2020 yhs. All rights reserved.
//

#import <string.h>
#import "ViewController.h"
#import "Utility.hpp"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)CanvasView* Canvas;
@property(nonatomic, strong)DrawThread* MainThread;

@property(nonatomic, strong)UIButton* BtnGraphic;
@property(nonatomic, strong)UIButton* BtnCrop;
@property(nonatomic, strong)UITableView* TableGraphicType;

@property(nonatomic, strong)NSArray* ListGraphicType;

@property(nonatomic, strong)UIImage* NormalImage;
@property(nonatomic, strong)UIImage* HightLightImage;
@property(nonatomic, strong)UIImage* SelectImage;

@property(nonatomic, strong)ParamViewController* paramVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.MainThread = [[DrawThread alloc] init];
    
    if(self.Canvas == nil) {
        CGRect mainFrame = [UIScreen mainScreen].bounds;
        CGRect frame = CGRectMake(mainFrame.origin.x, mainFrame.origin.y + 120, mainFrame.size.width, mainFrame.size.height - 150);
        self.Canvas = [[CanvasView alloc] initWithFrame:frame];
        self.Canvas.backgroundColor = [UIColor colorWithRed:205/255. green:230/255. blue:199/255. alpha:0.5];
    }
    [self.view addSubview:self.Canvas];
    
    [self designImagesWithRect:CGRectMake(0, 0, 60, 30)];
    
    self.BtnGraphic = [[UIButton alloc] init];
    [self designBtn:self.BtnGraphic Frame:CGRectMake(50, 70, 60, 30) Title:@"画线" BgColor:nil Action:@selector(btnGraphicAction:)];
    self.BtnGraphic.selected = YES;
    
    self.BtnCrop = [[UIButton alloc] init];
    [self designBtn:self.BtnCrop Frame:CGRectMake(130, 70, 60, 30) Title:@"截取" BgColor:nil Action:@selector(btnCropAction:)];
    
    [self designBtn:nil Frame:CGRectMake(220, 70, 60, 30) Title:@"擦除" BgColor:nil Action:@selector(btnEraserAction:)];
    [self designBtn:nil Frame:CGRectMake(300, 70, 60, 30) Title:@"参数" BgColor:nil Action:@selector(btnParamAction:)];
    
    CGRect btnGraphicRect = self.BtnGraphic.frame;
    self.TableGraphicType = [[UITableView alloc] initWithFrame:CGRectMake(btnGraphicRect.origin.x, btnGraphicRect.origin.y+btnGraphicRect.size.height, btnGraphicRect.size.width, 0) style:UITableViewStylePlain];
    self.TableGraphicType.delegate = self;
    self.TableGraphicType.dataSource = self;
    [self.view addSubview:self.TableGraphicType];
    [self.TableGraphicType selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    self.ListGraphicType = @[@"画线", @"画圆"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateParam:) name:@"updateParam" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) designImagesWithRect:(CGRect)rect {
    NSMutableArray* colors = [[NSMutableArray alloc] initWithCapacity:3];
    [colors addObject:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]];
    [colors addObject:[UIColor colorWithRed:161/255.0 green:193/255.0 blue:268/255.0 alpha:1]];
    self.NormalImage = gradientImageWithBounds(rect, colors, VERTICAL);
    
    [colors removeAllObjects];
    [colors addObject:[UIColor colorWithRed:161/255.0 green:193/255.0 blue:268/255.0 alpha:1]];
    [colors addObject:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]];
    self.HightLightImage = gradientImageWithBounds(rect, colors, VERTICAL);
    
    [colors removeAllObjects];
    [colors addObject:[UIColor colorWithRed:83/255.0 green:178/255.0 blue:253/255.0 alpha:1]];
    [colors addObject:[UIColor colorWithRed:41/255.0 green:123/255.0 blue:251/255.0 alpha:1]];
    self.SelectImage = gradientImageWithBounds(rect, colors, VERTICAL);
}

- (void) designBtn:(UIButton*) btn Frame:(CGRect)frame Title:(NSString*)title BgColor:(UIColor*)color Action:(SEL)action {
    if(btn == nil)
        btn = [[UIButton alloc] initWithFrame:frame];
    else
        btn.frame = frame;
    
    [btn setBackgroundImage:self.SelectImage forState:UIControlStateNormal];
    [btn setBackgroundImage:self.HightLightImage forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:6];
    
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)btnGraphicAction:(id)sender {
    UIButton* btn = (UIButton*)sender;
    btn.selected = !btn.selected;
    CGRect rect = btn.frame;
    if(self.BtnGraphic.selected)
        [UIView animateWithDuration:0.3 animations:^{
            self.TableGraphicType.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 0);
        } completion:^(BOOL finished) {
            
        }];
    else
        [UIView animateWithDuration:0.3 animations:^{
            self.TableGraphicType.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, rect.size.height*self.ListGraphicType.count);
        } completion:^(BOOL finished) {

        }];
    self.Canvas.bCrop = NO;
}

- (void)btnCropAction:(id)sender {
    self.Canvas.bCrop = YES;
}

- (void)btnEraserAction:(id)sender {
    self.Canvas.CurGraphicType = ERASER;
    self.Canvas.bCrop = NO;
}

- (void)btnParamAction:(id)sender {
    if(self.paramVC == nil) {
        self.paramVC = [[ParamViewController alloc] init];
        self.paramVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    [self presentViewController:self.paramVC animated:YES completion:nil];
    self.Canvas.bCrop = NO;
}

-(void)updateParam :(NSNotification*)notification {
    self.Canvas.CurParam = notification.userInfo;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.ListGraphicType.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0: {
            self.Canvas.CurGraphicType = POLYGON;
        }
            break;
        case 1: {
            self.Canvas.CurGraphicType = CIRCLE;
        }
            break;
        default:
            break;
    }
    [self.BtnGraphic setTitle:self.ListGraphicType[indexPath.section] forState:UIControlStateNormal];
    CGRect rect = self.BtnGraphic.frame;
    self.TableGraphicType.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 0);
    self.BtnGraphic.selected = !self.BtnGraphic.selected;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    NSString* CellIdentifier = @"DropDownCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = self.ListGraphicType[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = self.BtnGraphic.frame;
    return rect.size.height;
}
@end
