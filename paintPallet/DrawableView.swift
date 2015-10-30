//
//  DrawableView.swift
//  paintPallet
//
//  Created by 山口智生 on 2015/10/24.
//  Copyright © 2015年 Tomoki Yamaguchi. All rights reserved.
//

import UIKit

class DrawableView: UIView {
    
    class Line {
        var points: [CGPoint]
        var color :UIColor
        var width: CGFloat
        
        init(color: UIColor, width: CGFloat){
            self.color = color
            self.width = width
            self.points = []
        }
        
        func configurePath(path: UIBezierPath) {
            path.lineCapStyle = CGLineCap.Round
            
            // 2点以上ないと線描画する必要なし
            if self.points.count > 1 {
                // 起点
                path.moveToPoint(self.points.first!)
                for point in self.points[1...(self.points.count-1)] {
                    path.addLineToPoint(point)
                }
            }
            path.lineWidth = self.width// ライン幅
        }
        
        // BezierPathを生成
        func getBezierPath() -> UIBezierPath {
            let path = UIBezierPath()
            path.lineCapStyle = CGLineCap.Round
            
            // 2点以上ないと線描画する必要なし
            if self.points.count > 1 {
                // 起点
                path.moveToPoint(self.points.first!)
                for point in self.points[1...(self.points.count-1)] {
                    path.addLineToPoint(point)
                }
            }
            path.lineWidth = self.width// ライン幅
            
            //configurePath(path)
            
            return path
        }
        
        func drawOnContext(context: CGContextRef) {
            UIGraphicsPushContext(context)
            let path = self.getBezierPath()
            
            self.color.setStroke()// 色設定
            path.stroke()// 描画
            
            UIGraphicsPopContext()
        }
        
        func getImage(maxSize: CGSize) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(maxSize, false, 0)
            let context = UIGraphicsGetCurrentContext()
            self.drawOnContext(context!)
            
            let currentImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return currentImage
        }
    }
    
    struct DrawableViewSetting {
        var lineColor: UIColor = UIColor.redColor()
        var lineWidth: CGFloat = 5
        
        init() {
        }
    }
    
    var undoQue: [UIImageView] = []
    var currentLine: Line? = nil
    var currentPath: UIBezierPath! = UIBezierPath()
    
    var currentSetting = DrawableViewSetting()
    
    //初期化
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        currentSetting.lineColor = UIColor.redColor()
        currentSetting.lineWidth = 5
        
        let button = UIButton(frame: CGRectMake(0, 0, 100, 100))
        self.addSubview(button)
        button.backgroundColor = UIColor.yellowColor()
        button.addTarget(self, action: "undo", forControlEvents: .TouchUpInside)
    }
    
    func undo() {
        if self.undoQue.count > 0 {
            let imageView = self.undoQue.removeLast()
            imageView.removeFromSuperview()
        }
    }
    
    // タッチされた
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self)
        currentLine = Line(color: currentSetting.lineColor, width: currentSetting.lineWidth)
        currentLine?.points.append(point)
    }
    
    // タッチが動いた
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self)
        currentLine?.points.append(point)
        self.setNeedsDisplay()
    }
    
    // タッチが終わった
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // imageViewにはめて、undoQueに追加する
        let imageView = UIImageView(frame: self.bounds)
        imageView.backgroundColor = UIColor.clearColor()
        imageView.image = currentLine?.getImage(self.bounds.size)
        undoQue.append(imageView)
        self.addSubview(imageView)
        
        currentLine = nil
    
        self.setNeedsDisplay()
    }
    
    //描画設定
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        if let line = currentLine {
            line.configurePath(self.currentPath)
            line.color.setStroke()// 色設定
            self.currentPath.stroke()
            //line.drawOnContext(context!)
        } else {
            //CGContextSetFillColorWithColor(context, UIColor.brownColor().CGColor)
            //CGContextFillRect(context, self.bounds)
            CGContextClearRect(context, self.bounds)
            print("clear context")
        }
    }
}