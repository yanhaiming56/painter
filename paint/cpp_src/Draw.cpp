//
//  Draw.cpp
//  paint
//
//  Created by yhs on 2020/5/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#include "Draw.hpp"

bool CDraw::drawGraphics(const vector<Graphic *> &graphics) {
    if(graphics.empty())
        return false;
    
    for (auto&& graphic : graphics) {
        switch (graphic->getGraphicType()) {
            case LINE:
                
                break;
            case POLYGON: {
                QPolygon* polygon = dynamic_cast<QPolygon*>(graphic);
                drawPolygon(*polygon);
            }
                break;
            case CIRCLE: {
                QCircle* circle = dynamic_cast<QCircle*>(graphic);
                drawCircle(*circle);
            }
                break;
            case ERASER: {
                QEraser* eraser = dynamic_cast<QEraser*>(graphic);
                drawEraser(*eraser);
            }
                break;
            default:
                break;
        }
    }
    return true;
}

bool CDraw::drawPolygon(const QPolygon &polygon) {
    if (polygon.getPointCount() <= 0)
        return false;

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, polygon.getPoint(0).x, polygon.getPoint(0).y);
    
    if(!polygon.getFill() && !polygon.getClose())
        for (int i = 2; i < polygon.getPointCount(); i += 2) {
            CGPathAddQuadCurveToPoint(path, nil, polygon.getPoint(i-1).x, polygon.getPoint(i-1).y, polygon.getPoint(i).x, polygon.getPoint(i).y);
            CGPathMoveToPoint(path, nil, polygon.getPoint(i).x, polygon.getPoint(i).y);
        }
    else {
        for (int i = 1; i < polygon.getPointCount(); ++i) {
            CGPathAddLineToPoint(path, nil, polygon.getPoint(i).x, polygon.getPoint(i).y);
        }
        if(polygon.getCrop())
            CGPathCloseSubpath(path);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineWidth(context, polygon.getLineWidth());
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetRGBStrokeColor(context, polygon.getLineColor().red, polygon.getLineColor().green, polygon.getLineColor().blue, polygon.getLineColor().alpha);

    if (polygon.getCrop()) {
        CGFloat lengths[] = {10,10};
        CGContextSetLineDash(context, 0, lengths, 2);
    }
    
    if(polygon.getFill())
    {
        CGContextSetRGBFillColor(context, polygon.getFillColor().red, polygon.getFillColor().green, polygon.getFillColor().blue, polygon.getFillColor().alpha);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    else
    {
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    CGPathRelease(path);
    
    return true;
}

bool CDraw::drawPolygons(const vector<QPolygon *> &polygons) {
    for (auto&& polygon : polygons) {
        drawPolygon(*polygon);
    }
    return true;
}

bool CDraw::drawCircle(const QCircle& circle) {
    QPoint center = circle.getCenter();
    float radius = circle.getRadius();
    CGRect rect = CGRectMake(center.x - radius, center.y - radius, radius*2, radius*2);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, nil, rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    
    CGContextSetRGBStrokeColor(context, circle.getLineColor().red, circle.getLineColor().green, circle.getLineColor().blue, circle.getFillColor().alpha);
    if (circle.getFill()) {
        CGContextSetRGBFillColor(context, circle.getFillColor().red, circle.getFillColor().green, circle.getFillColor().blue, circle.getFillColor().alpha);
        CGContextDrawPath(context, kCGPathFill);
    }
    else
        CGContextDrawPath(context, kCGPathStroke);
    
    CGPathRelease(path);
    
    return true;
}

bool CDraw::drawEraser(const QEraser& eraser) {
    QPoint center = eraser.getCenter();
    CGRect rect = CGRectMake(center.x - 15, center.y - 15, 30, 30);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, nil, rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    
    CGContextSetRGBStrokeColor(context, eraser.getLineColor().red, eraser.getLineColor().green, eraser.getLineColor().blue, eraser.getFillColor().alpha);
    CGContextSetRGBFillColor(context, eraser.getFillColor().red, eraser.getFillColor().green, eraser.getFillColor().blue, eraser.getFillColor().alpha);
    CGContextDrawPath(context, kCGPathFill);
    
    CGPathRelease(path);
    
    return true;
}




