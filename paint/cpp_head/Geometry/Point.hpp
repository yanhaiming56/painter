//
//  Point.hpp
//  paint
//
//  Created by yhs on 2020/5/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#ifndef Point_hpp
#define Point_hpp

#include <stdio.h>
#include <UIKit/UIKit.h>

class IPoint
{
public:
    float x = 0.;
    float y = 0.;
public:
    IPoint() = default;
    IPoint(const float& x, const float& y = 0.) : x(x), y(y) {}
    virtual ~IPoint() = default;
};

class QPoint : public IPoint
{
public:
    QPoint() = default;
    QPoint(const float& x, const float& y = 0.) : IPoint(x, y) {}
    QPoint(const QPoint& point);
    QPoint(const CGPoint& cgPoint) : IPoint(cgPoint.x, cgPoint.y) {}
    
    ~QPoint() = default;
    
public:
    QPoint& operator = (const QPoint& point);
    QPoint& operator = (const CGPoint& cgPoint);
    operator CGPoint();
    
};

#endif /* Point_hpp */
