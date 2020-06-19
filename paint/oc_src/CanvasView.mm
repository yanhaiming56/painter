//
//  CanvasView.m
//  paint
//
//  Created by yhs on 2020/5/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#include <cmath>

#import "CanvasView.h"
#import "Polygon.hpp"
#import "Circle.hpp"
#import "Line.hpp"
#include "Utility.hpp"

@interface CanvasView() {
    BOOL isNew;
    BOOL isMove;
}

@property(nonatomic, assign)std::vector<Graphic*>* _Nullable CropGraphics;

@end

@implementation CanvasView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    if(self.Draw) {
        self.Draw->drawGraphics(*self.Graphics);
        
        if (self.CurGraphicType == ERASER) {
            if(self.CurGraphic == nullptr)
                return;
            vector<Graphic*> graphics(1, self.CurGraphic);
            self.Draw->drawGraphics(graphics);
        }
        
        if (self.bCrop) {
            if(self.CurGraphic == nullptr)
                return;
            vector<Graphic*> graphics(1, self.CurGraphic);
            self.Draw->drawGraphics(graphics);
        }
    }
}

#pragma mark - 初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.Draw = new CDraw();
        self.CurGraphic = nullptr;
        self.Graphics = new std::vector<Graphic*>();
        self.CropGraphics = new std::vector<Graphic*>();
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.Draw = new CDraw();
        self.CurGraphic = nullptr;
        self.Graphics = new std::vector<Graphic*>();
        self.CropGraphics = new std::vector<Graphic*>();
    }
    return self;
}

- (void)dealloc
{
    if (self.Draw) {
        delete self.Draw;
        self.Draw = nullptr;
    }
    
    if(self.Graphics) {
        for (auto&& graphic : *self.Graphics) {
            delete graphic;
            graphic = nullptr;
        }
        self.Graphics->clear();
        delete self.Graphics;
        self.Graphics = nullptr;
    }
    
    if(self.CropGraphics) {
        for (auto&& graphic : *self.CropGraphics) {
            delete graphic;
            graphic = nullptr;
        }
        self.CropGraphics->clear();
        delete self.CropGraphics;
        self.CropGraphics = nullptr;
    }
    
    if(self.CurGraphic) {
        delete self.CurGraphic;
        self.CurGraphic = nullptr;
    }
}

#pragma mark - 私有方法

- (void)setGraphicParam {
    if(self.CurGraphic && self.CurParam) {
        UIColor* color = self.CurParam[@"color"];
        const CGFloat* rgb = CGColorGetComponents(color.CGColor);
        self.CurGraphic->setLineColor(QColor(rgb[0], rgb[1], rgb[2], rgb[3]));
        
        NSNumber* lineWidth = self.CurParam[@"lineWidth"];
        self.CurGraphic->setLineWidth(lineWidth.floatValue);
        
        NSNumber* Fill = self.CurParam[@"Fill"];
        if (Fill.boolValue)
            self.CurGraphic->setFillColor(QColor(rgb[0], rgb[1], rgb[2], rgb[3]));
    }
}

#pragma mark - 触摸事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    isNew = YES;
    UITouch* touch = [[touches allObjects] objectAtIndex:0];
    self.StartPoint = [touch locationInView:self];
    
    if (self.bCrop) {
        if(self.CurGraphic == nullptr) {
            self.CurGraphic = new QPolygon(5, QColor(1.));
            self.CurGraphic->setClose(true);
            QPolygon* cropPolygon = dynamic_cast<QPolygon*>(self.CurGraphic);
            cropPolygon->addPoint(self.StartPoint);
            cropPolygon->setCrop(true);
        }
        else {
            QPolygon* cropPolygon = dynamic_cast<QPolygon*>(self.CurGraphic);
            if(pointInPolygon(self.StartPoint, *cropPolygon)) {
                isMove = YES;
                cropPolygon->setFill(true);
                cropPolygon->setFillColor(QColor(211/255.,215/255.,212/255.,0.5));
            }
        }
    }
    else {
        self.CurGraphic = nullptr;
        [self setNeedsDisplay];
        
        switch (self.CurGraphicType) {
            case LINE:
                break;
            case POLYGON: {
                if(self.CurGraphic == nullptr) {
                    self.CurGraphic = new QPolygon();
                    [self setGraphicParam];
                    
                    QPolygon* polygon = dynamic_cast<QPolygon*>(self.CurGraphic);
                    polygon->addPoint(QPoint(self.StartPoint));
                    
                    if(self.CurParam) {
                        NSNumber* bFill = self.CurParam[@"Fill"];
                        NSNumber* bClose = self.CurParam[@"Close"];
                        polygon->setFill(bFill.boolValue);
                        polygon->setClose(bClose.boolValue);
                    }
                }
            }
                break;
            case CIRCLE: {
                if (self.CurGraphic == nullptr) {
                    self.CurGraphic = new QCircle(0);
                    [self setGraphicParam];
                    
                    QCircle* circle = dynamic_cast<QCircle*>(self.CurGraphic);
                    circle->setCenter(QPoint(self.StartPoint));
                    
                    if(self.CurParam) {
                        NSNumber* bFill = self.CurParam[@"Fill"];
                        NSNumber* bClose = self.CurParam[@"Close"];
                        circle->setFill(bFill.boolValue);
                        circle->setClose(bClose);
                    }
                }
            }
                break;
            case ERASER: {
                if (self.CurGraphic == nullptr) {
                    self.CurGraphic = new QEraser();
                    QEraser* eraser = dynamic_cast<QEraser*>(self.CurGraphic);
                    eraser->setCenter(QPoint(self.StartPoint));
                    
                }
            }
                break;
            default:
                break;
        }
        if (self.CurGraphic && self.CurGraphicType != ERASER)
            self.Graphics->push_back(self.CurGraphic);
    }
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [[touches allObjects] objectAtIndex:0];
    QPoint point = [touch locationInView:self];
    if (self.bCrop) {
        if (!isMove) {
            QPolygon* polygon = dynamic_cast<QPolygon*>(self.CurGraphic);
            polygon->addPoint(point);
        }
        else {
            [self modifyCropGraphicsLocation:touch];
        }
    }
    else {
        switch (self.CurGraphicType) {
            case LINE:
                break;
            case POLYGON: {
                QPolygon* polygon = dynamic_cast<QPolygon*>(self.CurGraphic);
                polygon->addPoint(point);
            }
                break;
            case CIRCLE: {
                QCircle* circle = dynamic_cast<QCircle*>(self.CurGraphic);
                QPoint center = circle->getCenter();
                float radius = sqrt(pow(point.x - center.x, 2) + pow(point.y - center.y, 2));
                circle->setRadius(radius);
            }
                break;
            case ERASER: {
                QEraser* eraser = dynamic_cast<QEraser*>(self.CurGraphic);
                eraser->setCenter(QPoint(point));
            }
                break;
            default:
                break;
        }
    }
    [self setNeedsDisplay];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    isNew = NO;
    UITouch* touch = [[touches allObjects] objectAtIndex:0];
    self.EndPoint = [touch locationInView:self];
    if (self.bCrop) {
        if(!isMove) {
            QPolygon* polygon = dynamic_cast<QPolygon*>(self.CurGraphic);
            polygon->addPoint(self.EndPoint);
        }
    }
    else {
        switch (self.CurGraphicType) {
            case LINE:
                break;
            case POLYGON: {
                QPolygon* polygon = dynamic_cast<QPolygon*>(self.CurGraphic);
                polygon->addPoint(self.EndPoint);
            }
                break;
            case CIRCLE:{
                QCircle* circle = dynamic_cast<QCircle*>(self.CurGraphic);
                QPoint center = circle->getCenter();
                float radius = sqrt(pow(self.EndPoint.x - center.x, 2) + pow(self.EndPoint.y - center.y, 2));
                circle->setRadius(radius);
            }
                break;
            case ERASER:
                break;
            default:
                break;
        }
        self.CurGraphic = nullptr;
    }
    if(!isMove)
        [self getCropGraphics];
    else {
        isMove = NO;
        QPolygon* cropPoly = dynamic_cast<QPolygon*>(self.CurGraphic);
        cropPoly->setFill(false);
        cropPoly->setFillColor(QColor());
    }
    
    [self setNeedsDisplay];
}

- (void)getCropGraphics {
    if(!self.bCrop) {
        self.CropGraphics->clear();
        return;
    }
    
    QPolygon* cropPoly = dynamic_cast<QPolygon*>(self.CurGraphic);
    for (auto&& graphic : *self.Graphics) {
        switch (graphic->getGraphicType()) {
            case LINE:{
                
            }
                break;
            case POLYGON:{
                QPolygon* polygon = dynamic_cast<QPolygon*>(graphic);
                for (int i = 1; i < polygon->getPointCount(); ++i) {
                    auto start = polygon->getPoint(i-1);
                    auto end = polygon->getPoint(i);
                    if (lineInPolygon(QLine(start, end), *cropPoly)) {
                        polygon->setLineColor(QColor(0,1,0));
                        self.CropGraphics->push_back(polygon);
                        break;
                    }
                }
                
            }
                break;
            case CIRCLE:{
                
            }
                break;
            default:
                break;
        }
    }
}

- (void)modifyCropGraphicsLocation:(UITouch*)touch {
    QPoint point = [touch locationInView:self];
    float dx = point.x - self.StartPoint.x;
    float dy = point.y - self.StartPoint.y;
    for (auto&& graphic : *self.CropGraphics) {
        switch (graphic->getGraphicType()) {
            case LINE:{
                
            }
                break;
            case POLYGON:{
                QPolygon* polygon = dynamic_cast<QPolygon*>(graphic);
                for (int i = 0; i < polygon->getPointCount(); ++i) {
                    QPoint pt = polygon->getPoint(i);
                    pt.x += dx;
                    pt.y += dy;
                    polygon->modifyPoint(pt, i);
                }
            }
                break;
            case CIRCLE:{
                
            }
                break;
                
            default:
                break;
        }
    }
    if(self.CurGraphic) {
        QPolygon* cropPoly = dynamic_cast<QPolygon*>(self.CurGraphic);
        for (int i = 0; i < cropPoly->getPointCount(); ++i) {
            QPoint pt = cropPoly->getPoint(i);
            pt.x += dx;
            pt.y += dy;
            cropPoly->modifyPoint(pt, i);
        }
    }
    self.StartPoint = point;
}

@end
