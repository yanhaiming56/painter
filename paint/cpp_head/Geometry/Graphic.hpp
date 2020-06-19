//
//  Graphic.hpp
//  paint
//
//  Created by yhs on 2020/5/18.
//  Copyright © 2020 yhs. All rights reserved.
//

#ifndef Graphic_hpp
#define Graphic_hpp

#include "Utility.hpp"

typedef enum : NSInteger {
    NONE = 0,
    LINE,
    POLYGON,
    CIRCLE,
    ERASER
} GraphicType;

class Graphic {
protected:
    GraphicType type = NONE;
    bool fill = false;
    bool close = false;
    float lineWidth = 1.;
    QColor lineColor;
    QColor fillColor;
    
public:
    Graphic() = default;
    Graphic(const GraphicType& type, const float& width = 1, const QColor& lineColor = QColor(), const QColor& fillColor = QColor())
    : type(type), lineWidth(width), lineColor(lineColor), fillColor(fillColor) {}
    virtual ~Graphic() = default;
    
public:
    
    virtual bool getFill() const {
        return fill;
    }
    virtual void setFill(const bool& fill) {
        this->fill = fill;
    }
    
    virtual bool getClose() const {
        return close;
    }
    virtual void setClose(const bool& close) {
        this->close = close;
    }
    
    virtual GraphicType getGraphicType() const {
        return type;
    }
    virtual void setGraphicType(const GraphicType& graphicType) {
        type = graphicType;
    }
    virtual float getLineWidth() const {
        return lineWidth;
    }
    virtual void setLineWidth(const float& width) {
        lineWidth = width;
    }
    virtual QColor getLineColor() const {
        return lineColor;
    }
    virtual void setLineColor(const QColor& color) {
        lineColor = color;
    }
    
    virtual QColor getFillColor() const {
        return fillColor;
    }
    virtual void setFillColor(const QColor& color) {
        fillColor = color;
    }
};

#endif /* Graphic_hpp */
