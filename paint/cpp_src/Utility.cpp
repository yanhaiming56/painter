//
//  Utility.cpp
//  paint
//
//  Created by yhs on 2020/5/18.
//  Copyright © 2020 yhs. All rights reserved.
//

#include <cmath>

#include "Point.hpp"
#include "Circle.hpp"
#include "Line.hpp"
#include "Polygon.hpp"

#include "Utility.hpp"

QColor& QColor::operator = (const QColor& color) {
    red = color.red;
    green = color.green;
    blue = color.blue;
    alpha = color.alpha;
    return *this;
}

UIImage* gradientImageWithBounds(CGRect bound, NSArray* colors, GARIENTCOLORTYPE gradientType) {
    NSMutableArray *CGColors = [NSMutableArray array];
    
    for(UIColor *color in colors) {
        [CGColors addObject:(id)color.CGColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(bound.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace((CGColorRef)[CGColors lastObject]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)CGColors, NULL);
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(0.0, 0.0);
    
    switch (gradientType) {
        case VERTICAL:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, bound.size.height);
            break;
        case HORIZON:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(bound.size.width, 0.0);
            break;
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(context);
    
    UIGraphicsEndImageContext();
    
    return image;
}

float distanceBetweenTwoPoint(const QPoint& point1, const QPoint& point2)
{
    return sqrt(pow(point1.x - point2.x, 2)+pow(point1.y - point2.y, 2));
}

bool pointInCircle(const QPoint& point, const QCircle& circle)
{
    QPoint center = circle.getCenter();
    float distance = distanceBetweenTwoPoint(center, point);
    if (distance < circle.getRadius()) {
        return true;
    }
    return false;
}

bool pointInPolygon(const QPoint &point, const QPolygon &polygon)
{
    //以查询点为起点向y轴做垂线即水平线射线，如果该水平射线与多边形所有边的交点个数为奇数则在多变形内，为偶数则点不在多变形内
    size_t cross_count = 0;
    for (size_t i = 0, j = polygon.getPointCount() - 1; i < polygon.getPointCount(); j = i++)
    {
        auto pt1 = polygon.getPoint(i);
        auto pt2 = polygon.getPoint(j);
        
        QPoint* start = &pt1;
        QPoint* end = &pt2;
        
        
        if(fabs(end->y - start->y) < DEVIATION //水平线不考虑
           || point.y < min(start->y, end->y) || point.y > max(start->y, end->y) //点不在线段区域内
           || fabs(point.y - min(start->y, end->y)) < DEVIATION //过点的水平射线与线段y值小的端点相交
           )
            continue;
        
        //点不在线段区域内
        if (point.y < min(start->y, end->y) || point.y > max(start->y, end->y))
            continue;
        
        //垂直线特殊处理
        if(fabs(end->x - start->x) < DEVIATION)
        {
            //点在线段上
            if(fabs(point.x - start->x) < DEVIATION)
                return true;
            
            //点在线段右侧，水平射线必与垂线段相交
            if (point.x > start->x)
                ++cross_count;
        }
        else
        {
            float dx = end->x - start->x;
            float dy = end->y - start->y;
            
            //点在线段上
            if(fabs(dy * (point.x - start->x) - dx * (point.y - start->y)) < DEVIATION)
                return true;
            
            float x = dx/dy * (point.y - start->y) + start->x;
            //点在线右侧，过点的水平射线与当前线段一定相交
            if(x < point.x)
                ++cross_count;
        }
        
    }
    return cross_count % 2 == 0 ? false : true;
}

bool lineInPolygon(const QLine& line, const QPolygon& polygon)
{
    if (polygon.getPointCount() <= 0)
        return false;
    
    QPoint start = line.getStart();
    QPoint end = line.getEnd();
    
    //待测线段两端点有一个在多边形内则线段与多边形相交
    if (pointInPolygon(start, polygon) || pointInPolygon(end, polygon))
        return true;
    
    //待测线段两端点均不在多边形内，验证待测线段与多边形的任意一边是否相交
    for (size_t i = 0, j = polygon.getPointCount() - 1; i < polygon.getPointCount(); j = i++)
    {
        auto crop1 = polygon.getPoint(i);
        auto crop2 = polygon.getPoint(j);
        
        QPoint* crop_start = &crop1;
        QPoint* crop_end = &crop2;
        
        Vector2D line{end.x - start.x, end.y - start.y}; //待测线段的向量表示
        Vector2D vec1{crop_start->x-start.x, crop_start->y - start.y}; //待测线段起点到多边形边的起点的向量
        Vector2D vec2{crop_end->x - start.x, crop_end->y - start.y}; //待测线段起点到多边形边的终点的向量
        
        float cm1 = vectorCrossMultiply(vec1, line);
        float cm2 = vectorCrossMultiply(vec2, line);
        
        //多边形边的两端点在待测线段两侧
        if (cm1*cm2 < 0) {
            Vector2D _line = {crop_end->x - crop_start->x, crop_end->y - crop_start->y};
            Vector2D _vec1 = {start.x - crop_start->x, start.y - crop_start->y};
            Vector2D _vec2 = {end.x - crop_start->x, end.y - crop_start->y};
            
            float _cm1 = vectorCrossMultiply(_vec1, _line);
            float _cm2 = vectorCrossMultiply(_vec2, _line);
            
            //输入线段两端点在当前线段两侧
            if(_cm1*_cm2 < 0)
                return true;
        }
    }
    
    return false;
}

float vectorCrossMultiply(const Vector2D &vec1, const Vector2D &vec2)
{
    return vec1.x * vec2.y - vec1.y * vec2.x;
}

float vectorDotMultiply(const Vector2D &vec1, const Vector2D &vec2)
{
    return vec1.x * vec2.x + vec1.y * vec2.y;
}
