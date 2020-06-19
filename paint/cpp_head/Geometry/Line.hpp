//
//  Line.hpp
//  paint
//
//  Created by yhs on 2020/6/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#ifndef Line_hpp
#define Line_hpp

#include <stdio.h>

#include "Graphic.hpp"
#include "Point.hpp"

class QLine : public Graphic {
private:
    QPoint start;
    QPoint end;
    
public:
    QLine() : Graphic(LINE) {}
    QLine(const QPoint& start, const QPoint& end) : start(start), end(end) {}
    QLine(const float& width, const QColor& lineColor = QColor(), const QColor& fillColor = QColor())
    : Graphic(LINE, width, lineColor, fillColor) {}
    
public:
    QPoint getStart() const {
        return start;
    }
    void setStart(const QPoint& start) {
        this->start = start;
    }
    
    QPoint getEnd() const {
        return end;
    }
    void setEnd(const QPoint& end) {
        this->end = end;
    }
};

#endif /* Line_hpp */
