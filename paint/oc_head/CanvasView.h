//
//  CanvasView.h
//  paint
//
//  Created by yhs on 2020/5/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <vector>

#import "Graphic.hpp"
#import "Draw.hpp"

NS_ASSUME_NONNULL_BEGIN

@interface CanvasView : UIView

@property(nonatomic, assign)BOOL bCrop;
@property(nonatomic, assign)QPoint StartPoint;
@property(nonatomic, assign)QPoint EndPoint;
@property(nonatomic, assign)GraphicType CurGraphicType;
@property(nonatomic, assign)CDraw* _Nullable Draw;
@property(nonatomic, assign)Graphic* _Nullable CurGraphic;
@property(nonatomic, assign)std::vector<Graphic*>* _Nullable Graphics;
@property(nonatomic, strong)NSDictionary* _Nullable CurParam;

@end

NS_ASSUME_NONNULL_END
