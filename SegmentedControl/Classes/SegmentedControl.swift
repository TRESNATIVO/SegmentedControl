//
//  STUSegmentedControl.swift
//  SubeloTu
//
//  Created by Benny Franco Dennis on 22/08/16.
//  Copyright © 2016 Sandcode Software S.A. de C.V. All rights reserved.
//

import UIKit

@IBDesignable class SegmentedControl: UIControl {
    
    private var labels = [UILabel]()
    
    var items: [String] = ["Registro", "Iniciar Sesión"] {
        didSet {
            setupLabels()
        }
    }
    
    @IBInspectable var selectedIndex : Int = 1 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    @IBInspectable var selectedLabelColor : UIColor = UIColor.blackColor() {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedLabelColor : UIColor = UIColor.whiteColor() {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var thumbColor : UIColor = UIColor.whiteColor() {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.whiteColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var font : UIFont! = UIFont.systemFontOfSize(12) {
        didSet {
            setFont()
        }
    }
    
    var thumbView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(){
        
        //layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        layer.borderWidth = 2
        
        backgroundColor = UIColor.clearColor()
        
        setupLabels()
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
        insertSubview(thumbView, atIndex: 0)
    }
    
    func setupLabels(){
        
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepCapacity: true)
        
        for index in 1...items.count {
            
            let label = UILabel(frame: CGRectMake(0, 0, 70, 40))
            
            label.text = items[index - 1]
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Center
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = CGRectGetWidth(selectFrame) / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        
        displayNewSelectedIndex()
        
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        
        let location = touch.locationInView(self)
        
        var calculatedIndex : Int?
        for (index, item) in labels.enumerate() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActionsForControlEvents(.ValueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex(){
        for (item) in labels{
            item.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        
        if(selectedIndex == 0){
            let mask = CAShapeLayer()
            mask.frame = thumbView.layer.bounds
            
            let width = thumbView.layer.frame.size.width
            let height = thumbView.layer.frame.size.height
            
            let path = CGPathCreateMutable()
            
            CGPathMoveToPoint(path, nil, 0, 0)
            CGPathAddLineToPoint(path, nil, width, 0)
            CGPathAddLineToPoint(path, nil, width-20, height)
            CGPathAddLineToPoint(path, nil, 0, height)
            
            mask.path = path
            
            thumbView.layer.mask = mask
            
            let shape = CAShapeLayer()
            shape.frame = thumbView.bounds
            shape.path = path
            shape.lineWidth = 3.0
            shape.fillColor = UIColor.redColor().CGColor
            
            thumbView.layer.insertSublayer(shape, atIndex: 0)
        }else{
            let mask = CAShapeLayer()
            mask.frame = thumbView.layer.bounds
            
            let width = thumbView.layer.frame.size.width
            let height = thumbView.layer.frame.size.height
            
            let path = CGPathCreateMutable()
            
            CGPathMoveToPoint(path, nil, 20, 0)
            CGPathAddLineToPoint(path, nil, width, 0)
            CGPathAddLineToPoint(path, nil, width, height)
            CGPathAddLineToPoint(path, nil, 0, height)
            
            mask.path = path
            
            thumbView.layer.mask = mask
            
            let shape = CAShapeLayer()
            shape.frame = thumbView.bounds
            shape.path = path
            shape.lineWidth = 3.0
            shape.fillColor = UIColor.redColor().CGColor
            
            thumbView.layer.insertSublayer(shape, atIndex: 0)
        }
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            
            self.thumbView.frame = label.frame
            
            }, completion: nil)
    }
    
    func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        
        for (index, button) in items.enumerate() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == items.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -padding)
                
            }else{
                
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: nextButton, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: -padding)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: mainView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: padding)
                
            }else{
                
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: prevButton, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: NSLayoutRelation.Equal, toItem: firstItem, attribute: .Width, multiplier: 1.0  , constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func setSelectedColors(){
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor = thumbColor
    }
    
    func setFont(){
        for item in labels {
            item.font = font
        }
    }
}
