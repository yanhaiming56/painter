//
//  Polygon.cpp
//  paint
//
//  Created by yhs on 2020/5/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#include "Polygon.hpp"

bool QPolygon::addPoint(const QPoint& point)
{
    if(points) {
        points->push_back(point);
        return true;
    }
    return false;
}

QPoint QPolygon::getPoint(const size_t& index) const
{
    if(points) {
        QPoint point = points->at(index);
        return point;
    }
    return QPoint();
}

bool QPolygon::modifyPoint(const QPoint& point, const size_t& index)
{
    if(points && index < points->size()) {
        (*points)[index] = point;
        return true;
    }
    return false;
}
