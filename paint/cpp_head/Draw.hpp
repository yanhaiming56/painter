//
//  Draw.hpp
//  paint
//
//  Created by yhs on 2020/5/15.
//  Copyright © 2020 yhs. All rights reserved.
//

#ifndef Draw_hpp
#define Draw_hpp

#include <stdio.h>
#include <iostream>

#include "Utility.hpp"
#include "Polygon.hpp"
#include "Circle.hpp"

using namespace std;

class CDraw
{
private:
    
public:
    CDraw() = default;
    ~CDraw() = default;
    
public:
    bool drawGraphics(const vector<Graphic*>& graphics);
    
private:
    bool drawPolygon(const QPolygon& polygon);
    bool drawPolygons(const vector<QPolygon*>& polygons);
    
    bool drawCircle(const QCircle& circle);
    
    bool drawEraser(const QEraser& eraser);
    
};

#endif /* Draw_hpp */
