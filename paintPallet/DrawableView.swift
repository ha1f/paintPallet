//
//  DrawableView.swift
//  paintPallet
//
//  Created by 山口智生 on 2015/10/24.
//  Copyright © 2015年 Tomoki Yamaguchi. All rights reserved.
//

import UIKit

class DrawableView: UIView {
    
    var lines: [Line] = []
    var lastPoint: CGPoint!
    var drawColor = UIColor.redColor()
    
    
    //初期化
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // タッチに反応
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        lastPoint = touches.first!.locationInView(self)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let newPoint = touch.locationInView(self)
        
        
        lines.append(Line(start: lastPoint , end: newPoint, color: drawColor))
        lastPoint = newPoint
        
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //
    }
    
    func drawLine(line: Line) {
        let path = UIBezierPath();
        
        // 起点
        path.moveToPoint(line.start);
        
        // 帰着点
        path.addLineToPoint(line.end);
        
        // 色の設定
        line.color.setStroke()
        
        // ライン幅
        path.lineWidth = 2
        
        // 描画
        path.stroke();
    }
    
    //描画設定
    override func drawRect(rect: CGRect) {
        for line in lines {
            drawLine(line)
        }
    }
    
}