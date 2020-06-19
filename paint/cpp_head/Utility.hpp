//
//  Utility.hpp
//  paint
//
//  Created by yhs on 2020/5/18.
//  Copyright © 2020 yhs. All rights reserved.
//

#ifndef Utility_hpp
#define Utility_hpp

#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#import <UIKit/UIKit.h>

#define DEVIATION 1e-4

class QPoint;
class QCircle;
class QPolygon;
class QLine;

typedef QPoint Vector2D;

typedef struct QColor
{
public:
    float red = 0.;
    float green = 0.;
    float blue = 0.;
    float alpha = 1.;
    
public:
    QColor() = default;
    QColor(const float& red, const float& green = 0, const float& blue = 0, const float& alpha = 1)
    : red(red), green(green), blue(blue), alpha(alpha) {}
    
    QColor(const QColor& color)
    : red(color.red), green(color.green), blue(color.blue), alpha(color.alpha) {}
    
public:
    QColor& operator = (const QColor& color);
    
} QColor, *ColorRef;

typedef enum : NSInteger {
    HORIZON,
    VERTICAL,
} GARIENTCOLORTYPE;

UIImage* gradientImageWithBounds(CGRect bound, NSArray* colors, GARIENTCOLORTYPE gradientType);

float distanceBetweenTwoPoint(const QPoint& point1, const QPoint& point2);
bool pointInCircle(const QPoint& point, const QCircle& circle);
bool pointInPolygon(const QPoint &point, const QPolygon &polygon);
bool lineInPolygon(const QLine& line, const QPolygon& polygon);

float vectorCrossMultiply(const Vector2D &vec1, const Vector2D &vec2);
float vectorDotMultiply(const Vector2D &vec1, const Vector2D &vec2);

#endif /* Utility_hpp */
