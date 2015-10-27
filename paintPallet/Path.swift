//
//  Path.swift
//  paintPallet
//
//  Created by 山口智生 on 2015/10/24.
//  Copyright © 2015年 Tomoki Yamaguchi. All rights reserved.
//

import Foundation
import UIKit

class Path {
    var points: [CGPoint]
    var color :UIColor
    
    init(color _color:UIColor){
        self.color = _color
        self.points = []
    }
}