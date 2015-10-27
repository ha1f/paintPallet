//
//  DrawableView.swift
//  paintPallet
//
//  Created by 山口智生 on 2015/10/24.
//  Copyright © 2015年 Tomoki Yamaguchi. All rights reserved.
//

import UIKit

class DrawableView: UIView {
    
    var lines: [Path] = []
    var lastPoint: CGPoint?
    var drawColor = UIColor.redColor()
    var currentLine: Path! = nil
    
    
    //初期化
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // タッチに反応
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self)
        currentLine = Path(color: UIColor.redColor())
        currentLine.points.append(point)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let newPoint = touch.locationInView(self)
        
        
        //lines.append(Line(start: lastPoint , end: newPoint, color: drawColor))
        currentLine.points.append(newPoint)
        lastPoint = newPoint
        
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lines.append(currentLine)
        lastPoint = nil
        print(lines)
        self.setNeedsDisplay()
    }
    
    func drawPath(line: Path) {
        let context = UIGraphicsGetCurrentContext()
        
        UIGraphicsPushContext( context! );
        
        let path = UIBezierPath()
        
        // 起点
        path.moveToPoint(line.points.first!)
        
        for point in line.points {
            path.addLineToPoint(point)
        }
        
        line.color.setStroke()
        
        // ライン幅
        path.lineWidth = 2
        
        // 描画
        path.stroke()
        
        UIGraphicsPopContext()
    }
    
    //描画設定
    override func drawRect(rect: CGRect) {
        for line in lines {
            drawPath(line)
        }
        
        if currentLine != nil {
            drawPath(currentLine)
        }
    }
    
}