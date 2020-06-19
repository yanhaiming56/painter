//
//  Circle.hpp
//  paint
//
//  Created by yhs on 2020/6/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#ifndef Circle_hpp
#define Circle_hpp

#include <stdio.h>
#include "Graphic.hpp"
#include "Point.hpp"

class QCircle : public Graphic {
protected:
    float radius = 0.;
    QPoint center;
    
public:
    QCircle(const float& radius):Graphic(CIRCLE), radius(radius) {}
    QCircle(const float& radius, const float& width, const QColor& lineColor = QColor(), const QColor& fillColor = QColor())
    : Graphic(CIRCLE, width, lineColor, fillColor), radius(radius) {}
    
public:
    virtual QPoint getCenter() const {
        return center;
    }
    virtual void setCenter(const QPoint center) {
        this->center = center;
    }
    
    virtual float getRadius() const {
        return radius;
    }
    virtual void setRadius(const float& radius) {
        this->radius = radius;
    }
    
};

class QEraser : public QCircle {
private:
    
public:
    QEraser(const float& radius = 10.):QCircle(radius, 1., QColor(211/255.,215/255.,212/255.,0.5), QColor(211/255.,215/255.,212/255.,0.5)) {
        this->fill = true;
        this->close = true;
        this->type = ERASER;
        
    }
    QEraser(const float& radius, const float& width = 1., const QColor& lineColor = QColor(211/255.,215/255.,212/255.,0.5), const QColor& fillColor = QColor(211/255.,215/255.,212/255.,0.5))
    : QCircle(radius, width, lineColor, fillColor) {
        this->fill = true;
        this->close = true;
        this->type = ERASER;
    }
    
public:
    
};

#endif /* Circle_hpp */
