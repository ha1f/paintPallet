//
//  DrawableView.swift
//  paintPallet
//
//  Created by 山口智生 on 2015/10/24.
//  Copyright © 2015年 Tomoki Yamaguchi. All rights reserved.
//

import UIKit

protocol DrawableViewDelegate {
    func onUpdateDrawableView()
    func onFinishSave()
}

protocol DrawableViewPart {
    func drawOnContext(context: CGContextRef)
}

class DrawableView: UIView {
    
    class Line: DrawableViewPart {
        var points: [CGPoint]
        var color :CGColorRef
        var width: CGFloat
        
        init(color: CGColorRef, width: CGFloat){
            self.color = color
            self.width = width
            self.points = []
        }
        
        func drawOnContext(context: CGContextRef){
            UIGraphicsPushContext(context)
            
            CGContextSetStrokeColorWithColor(context, self.color)
            CGContextSetLineWidth(context, self.width)
            CGContextSetLineCap(context, CGLineCap.Round)
            
            // 2点以上ないと線描画する必要なし
            if self.points.count > 1 {
                for (index, point) in self.points.enumerate() {
                    if index == 0 {
                        CGContextMoveToPoint(context, point.x, point.y)
                    } else {
                        CGContextAddLineToPoint(context, point.x, point.y)
                    }
                }
            } else {
                Dot(line: self).drawOnContext(context)
            }
            CGContextStrokePath(context)
            
            UIGraphicsPopContext()
        }
        
        // 更新分だけ描画したい時用
        func drawLastlineOnContext(context: CGContextRef) {
            if self.points.count > 1 {
                UIGraphicsPushContext(context)
                CGContextSetStrokeColorWithColor(context, self.color)
                CGContextSetLineWidth(context, self.width)
                CGContextSetLineCap(context, CGLineCap.Round)
                
                let startPoint = self.points[self.points.endIndex-2]
                let endPoint = self.points.last!
                CGContextMoveToPoint(context, startPoint.x, startPoint.y)
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y)
                
                CGContextStrokePath(context)
                UIGraphicsPopContext()
            } else if self.points.count > 0 {
                Dot(line: self).drawOnContext(context)
            }
        }
    }
    
    class Dot: DrawableViewPart {
        var pos: CGPoint
        var radius: CGFloat
        var color: CGColorRef
        
        init(pos: CGPoint, radius: CGFloat, color: CGColorRef) {
            self.radius = radius
            self.pos = pos
            self.color = color
        }
        
        init(line: Line) {
            self.pos = line.points.first!
            self.radius = line.width
            self.color = line.color
        }
        
        func drawOnContext(context: CGContextRef){
            UIGraphicsPushContext(context)
            CGContextSetFillColorWithColor(context, self.color)
            CGContextAddEllipseInRect(context, CGRectMake(pos.x-(radius/2), pos.y-(radius/2), radius, radius));
            CGContextFillPath(context);
            UIGraphicsPopContext()
        }
    }
    
    class Image: DrawableViewPart {
        var image: UIImage
        init(image: UIImage) {
            self.image = image
        }
        func drawOnContext(context: CGContextRef){
            UIGraphicsPushContext(context)
            image.drawInRect(CGRect(origin: CGPointZero, size: image.size))
            UIGraphicsPopContext()
        }
    }
    
    struct DrawableViewSetting {
        var lineColor: CGColorRef = UIColor.redColor().CGColor
        var lineWidth: CGFloat = 5
    }
    
    // DrawableViewParts
    var parts: [DrawableViewPart] = []
    // 描画中のLine
    var currentLine: Line? = nil
    // これまでに描画したimage
    private var currentImage: UIImage? = nil
    // delegate
    var delegate:DrawableViewDelegate? = nil
    
    private var currentSetting = DrawableViewSetting()
    
    func setLineColor(color: CGColorRef) {
        currentSetting.lineColor = color
    }
    
    func setLineWidth(width: CGFloat) {
        currentSetting.lineWidth = width
    }
    
    //初期化
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.parts = [Image(image: UIImage())]
        currentSetting.lineColor = UIColor.redColor().CGColor
        currentSetting.lineWidth = 5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func undo() {
        if !self.parts.isEmpty {
            self.parts.removeLast()
            requireRedraw()
        }
    }
    
    // タッチされた
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self)
        currentLine = Line(color: self.currentSetting.lineColor, width: self.currentSetting.lineWidth)
        currentLine?.points.append(point)
        self.setNeedsDisplay()
    }
    
    // タッチが動いた
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self)
        currentLine?.points.append(point)
        self.setNeedsDisplay()
    }
    
    // タッチが終わった
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 2点以上のlineしか保存する必要なし
        if currentLine?.points.count > 1 {
            parts.append(currentLine!)
        } else {
            self.parts.append(Dot(line: currentLine!))
        }
        
        currentLine = nil
    }
    
    private func requireRedraw() {
        self.currentImage = nil
        self.setNeedsDisplay()
    }
    
    // UIImageとして取得
    func getCurrentImage() -> UIImage {
        // nilだったら再度描画させる
        if self.currentImage == nil {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
            let context = UIGraphicsGetCurrentContext()
            for part in parts {
                part.drawOnContext(context!)
            }
            if let line = currentLine {
                line.drawOnContext(context!)
            }
            self.currentImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return self.currentImage!
    }
    
    func updateCurrentImage() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0)
        // 新しいcontext
        let imageContext = UIGraphicsGetCurrentContext()
        // 今までのimageを取得して描画
        self.getCurrentImage().drawInRect(self.bounds)
        // 追加分を描画
        if let line = currentLine {
            line.drawLastlineOnContext(imageContext!)
        }
        // 更新
        self.currentImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func clear() {
        self.parts = []
        self.requireRedraw()
    }
    
    private func getResizedImage(image: UIImage, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func setBackgroundImage(image: UIImage) {
        let resizedImage = getResizedImage(image, size: CGSizeMake(self.bounds.width, self.bounds.height))
        
        let backgroundImage = Image(image: resizedImage)
        
        if let part = self.parts.first where part is Image {
            self.parts[0] = backgroundImage
        } else {
            self.parts.insert(backgroundImage, atIndex: 0)
        }
        
        self.requireRedraw()
    }
    
    func save() {
        // 念のため再描画
        updateCurrentImage()
        UIImageWriteToSavedPhotosAlbum(self.currentImage!, self, "image:didFinishSavingWithError:contextInfo:", nil)
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
        if error != nil {
            //プライバシー設定不許可など書き込み失敗時は -3310 (ALAssetsLibraryDataUnavailableError)
            print("DrawableView:Error -> " + String(error.code))
        } else {
            delegate?.onFinishSave()
        }
    }
    
    //描画設定
    override func drawRect(rect: CGRect) {
        delegate?.onUpdateDrawableView()
        
        let _ = UIGraphicsGetImageFromCurrentImageContext()
        
        updateCurrentImage()
        self.currentImage?.drawInRect(self.bounds)
    }
}