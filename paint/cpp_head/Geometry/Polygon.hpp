//
//  Polygon.hpp
//  paint
//
//  Created by yhs on 2020/5/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#ifndef Polygon_hpp
#define Polygon_hpp

#include <vector>

#include "Utility.hpp"
#include "Graphic.hpp"
#include "Point.hpp"

using namespace std;

class QPolygon : public Graphic
{
private:
    bool crop = false;
    vector<QPoint>* points = new vector<QPoint>();
    
public:
    QPolygon() : Graphic(POLYGON) {}
    QPolygon(const float& width, const QColor& lineColor = QColor(), const QColor& fillColor = QColor())
    : Graphic(POLYGON, width, lineColor, fillColor), points(new vector<QPoint>()) {}
    virtual ~QPolygon() {
        if(points)
            delete points;
    }
public:
    QPoint getPoint(const size_t& index) const;
    bool addPoint(const QPoint& point);
    bool modifyPoint(const QPoint& point, const size_t& index);
    
    bool getCrop() const {
        return crop;
    }
    void setCrop(const bool& crop) {
        this->crop = crop;
    }
    
    uint getPointCount() const {
        return points->size();
    }
    
};

#endif /* Polygon_hpp */
