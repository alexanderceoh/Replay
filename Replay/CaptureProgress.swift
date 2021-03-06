//
//  CaptureProgress.swift
//  Replay
//
//  Created by alex oh on 11/12/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit

@IBDesignable class CaptureProgress: UIView {
    
    @IBOutlet weak var secondsLabel: UILabel!
    
    @IBInspectable var progressAmount: CGFloat = 0 {
        
        didSet {
            
            setNeedsDisplay()
            secondsLabel?.text = "\(Int(progressAmount / 10))"
            
        }
        
    }
    
    @IBInspectable var progressColor: UIColor = UIColor.redColor()
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, 4)
        CGContextSetLineCap(context, .Round)
        
        // back middle circle
        
        UIColor(white: 0, alpha: 0.4).set()

        CGContextStrokeEllipseInRect(context, CGRectInset(rect, 20, 20))

        // top left circle
        
        progressColor.set()

        CGContextFillEllipseInRect(context, CGRect(x: 0, y: 0, width: 30, height: 30))
        
        // progress circle
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // we're minusing the 20 inset
        let radius = rect.width / 2 - 20
        let startAngle = -CGFloat(M_PI * 2 * 0.25)
        let progressAngle = CGFloat(M_PI * 2) * (progressAmount / 100) + startAngle
        
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: progressAngle, clockwise: true)
        
        CGContextAddPath(context, progressPath.CGPath)
        CGContextStrokePath(context)
        
    }
    
}





















