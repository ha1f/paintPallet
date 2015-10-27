//
//  Line.swift
//  paintPallet
//
//  Created by 山口智生 on 2015/10/24.
//  Copyright © 2015年 Tomoki Yamaguchi. All rights reserved.
//

import Foundation
import UIKit

class Line {
    var start: CGPoint
    var end: CGPoint
    var color :UIColor
    
    var stratX:CGFloat {
        get {
            return start.x
        }
    }
    
    var stratY:CGFloat {
        get {
            return start.y
        }
    }
    
    var endX:CGFloat {
        get {
            return end.x
        }
    }
    
    var endY:CGFloat {
        get {
            return end.y
        }
    }
    
    
    init(start _start: CGPoint, end _end:CGPoint,color _color:UIColor){
        self.start = _start
        self.end = _end
        self.color = _color
    }
}