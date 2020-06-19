//
//  Point.cpp
//  paint
//
//  Created by yhs on 2020/5/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#include "Geometry/Point.hpp"

QPoint::QPoint(const QPoint& point) : IPoint(point.x, point.y)
{
}

QPoint& QPoint::operator = (const QPoint& point)
{
    this->x = point.x;
    this->y = point.y;
    return *this;
}

QPoint& QPoint::operator = (const CGPoint& cgPoint)
{
    this->x = cgPoint.x;
    this->y = cgPoint.y;
    return *this;
}

QPoint::operator CGPoint()
{
    CGPoint point = {this->x, this->y};
    return point;
}
