//
//  ViewController.swift
//  paintPallet
//
//  Created by 山口智生 on 2015/10/24.
//  Copyright © 2015年 Tomoki Yamaguchi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DrawableViewDelegate {
    
    var drawableView: DrawableView! = nil
    
    var undoButton: UIButton! = nil
    var saveButton: UIButton! = nil
    //var loadButton: UIButton! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        let buttonWidth = self.view.bounds.width/3
        
        if drawableView == nil {
            drawableView = DrawableView(frame: CGRectMake(0, 100, self.view.bounds.width, self.view.bounds.width))
            drawableView.backgroundColor = UIColor.whiteColor()
            drawableView.delegate = self
            self.view.addSubview(drawableView)
        }
        
        if undoButton == nil {
            undoButton = UIButton(frame: CGRectMake(0, 0, buttonWidth, 100))
            undoButton.backgroundColor = UIColor.yellowColor()
            undoButton.setTitle("undo", forState: .Normal)
            undoButton.setTitleColor(UIColor.brownColor(), forState: .Normal)
            undoButton.addTarget(drawableView, action: "undo", forControlEvents: .TouchUpInside)
            self.view.addSubview(undoButton)
        }
        
        if saveButton == nil {
            saveButton = UIButton(frame: CGRectMake(buttonWidth, 0, buttonWidth, 100))
            saveButton.backgroundColor = UIColor.greenColor()
            saveButton.setTitle("save", forState: .Normal)
            saveButton.setTitleColor(UIColor.brownColor(), forState: .Normal)
            saveButton.addTarget(drawableView, action: "save", forControlEvents: .TouchUpInside)
            self.view.addSubview(saveButton)
        }
        
        /*if loadButton == nil {
            loadButton = UIButton(frame: CGRectMake(buttonWidth*2, 0, buttonWidth, 100))
            loadButton.backgroundColor = UIColor.greenColor()
            loadButton.setTitle("clear", forState: .Normal)
            loadButton.setTitleColor(UIColor.brownColor(), forState: .Normal)
            loadButton.addTarget(drawableView, action: "clear", forControlEvents: .TouchUpInside)
            self.view.addSubview(loadButton)
        }*/
        
    }
    
    func onUpdateDrawableView() {
        
    }
    
    func onFinishSave() {
        let alertController = UIAlertController(title: "Saved!", message: "saved to camera roll.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

