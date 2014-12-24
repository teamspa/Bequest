//
//  BQSTProgressButton.swift
//  Bequest
//
//  Created by Jonathan Hersh on 12/21/14.
//  Copyright (c) 2014 BQST. All rights reserved.
//

import Foundation
import UIKit

enum BQSTProgressButtonState: Int {
    case Unknown = 0
    case Ready
    case Loading
    case Complete
}

class BQSTProgressButton: UIControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.opaque = false
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var progressState: BQSTProgressButtonState = .Unknown {
        willSet {
            self.circleShapeLayer.removeAllAnimations()
            
            switch newValue {
            case .Ready:
                self.circleShapeLayer.removeFromSuperlayer()
                self.circleShapeLayer.strokeStart = 0
                self.circleShapeLayer.strokeEnd = 0
            case .Loading:
                let circleRect = CGRectInset(self.bounds, 8, 8)
                self.circleShapeLayer.strokeStart = 0
                self.circleShapeLayer.strokeEnd = 0
                self.circleShapeLayer.strokeColor = self.progressColor.CGColor
                self.circleShapeLayer.path = UIBezierPath(ovalInRect: circleRect).CGPath
                self.layer.addSublayer(self.circleShapeLayer)

            case .Complete:
                self.circleShapeLayer.strokeEnd = 1
                self.circleShapeLayer.strokeColor = UIColor.BQSTGreenColor().CGColor
                
            default:
                break
            }
            
            self.layer.setNeedsDisplay()
        }
    }
    
    var progressPercentage: CGFloat = 0 {
        willSet {
            self.circleShapeLayer.removeAllAnimations()
        } didSet {
            self.circleShapeAnimation.fromValue = oldValue
            self.circleShapeAnimation.toValue = self.progressPercentage
            self.circleShapeLayer.addAnimation(self.circleShapeAnimation, forKey: "drawCircleAnimation")
            self.setNeedsDisplay()
        }
    }
    
    var progressColor: UIColor = UIColor.BQSTRedColor()
    
    private let circleShapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.position = CGPointZero
        layer.fillColor = UIColor.clearColor().CGColor
        layer.lineCap = kCALineCapRound
        layer.strokeStart = CGFloat(0)
        
        return layer
    }()
    
    private let circleShapeAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.1
        animation.repeatCount = 1
        animation.removedOnCompletion = false
        animation.fromValue = 0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        
        return animation
    }()
    
    override var highlighted: Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        switch self.progressState {
        case .Ready:
            
            ("Send" as NSString).drawInRect(CGRectInset(rect, 0, 10), withAttributes:
                [NSFontAttributeName: UIFont.BQSTFont(18),
                    NSKernAttributeName: NSNull(),
                    NSForegroundColorAttributeName: self.highlighted ? UIColor.whiteColor() : UIColor.BQSTRedColor()])
            
            break
        default:
            break;
        }
    }
}
