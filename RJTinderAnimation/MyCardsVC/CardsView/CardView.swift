//
//  CardView.swift
//  TinderAnimation
//
//  Created by Rakesh Jyoti on 12/7/17.
//  Copyright © 2017 RJ. All rights reserved.
//

import UIKit


internal func degreesToRadians(_ degrees: Float) -> Float
{
    return (degrees) * (.pi / 180.0)
}


protocol DelegateCards: class {
    
    func itemDidRemoved(card: CardView)
    func movingCurrentItemWithCenter(currentCenter: CGPoint, card: CardView)
    func itemMovingBackToInitialPlace(card: CardView)
    func itemGoingOutSideOfTheScreen(card: CardView);
}




class CardView: UIView {

    weak var delegate: DelegateCards?
    
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0, y:0)
    var initalHeight: CGFloat = 0
    
    private var _initialCenterPoint: CGPoint!
    var initialCenterPoint: CGPoint {
        
        set {
            self.center = newValue
            _initialCenterPoint = newValue
        }
        
        get {
            return _initialCenterPoint
        }
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    class func initWithXib(frame: CGRect) -> CardView {
    
        let cardView: CardView = UINib.init(nibName: "CardView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as! CardView
        cardView.frame = frame

        return cardView
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let panGes = UIPanGestureRecognizer.init(target: self, action: #selector(self.didPanView(recognizer:)))
        self.addGestureRecognizer(panGes)
    }
    
    
    @objc func didPanView(recognizer: UIPanGestureRecognizer) {
        
        if recognizer.state == .began {
            initialTouchPoint = recognizer.location(in: self)
            initalHeight = self.frame.size.height
        }
        
        let translation = recognizer.translation(in: self)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self)
        
        let rotateAngle = rotateView(currentCenter: center)
        self.transform = CGAffineTransform.init(rotationAngle: CGFloat(rotateAngle))

        self.delegate?.movingCurrentItemWithCenter(currentCenter: center, card: self)
        
        if recognizer.state == UIGestureRecognizerState.ended {
            
            let velocity = recognizer.velocity(in: self)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            
            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y:recognizer.view!.center.y + (velocity.y * slideFactor))
            
            let maxMoveForDisapear: CGFloat = 150.0
            if fabs(finalPoint.x - initialCenterPoint.x) < maxMoveForDisapear {
                
                returnToInitialPosition()
                
            }else {
                
                if finalPoint.x < initialCenterPoint.x {
                    finalPoint.x =  -max(self.bounds.size.width, self.bounds.size.height)
                }else {
                    finalPoint.x =  UIScreen.main.bounds.width + max(self.bounds.size.width, self.bounds.size.height)
                }
                

 
                
                let rotateAngle = rotateView(currentCenter: finalPoint)
                
                //max(, self.view.bounds.size.width)
                //                finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
                
                //                let animationDuration = Double(slideFactor * 2)
                
                let animationDuration = 0.25 * (fabs(finalPoint.x - center.x)/100.0)
                
                print("animationDuration:::::::::\(animationDuration)")
                print("finalPoint:::::::::\(finalPoint)\n\n")

                
                
                delegate?.itemGoingOutSideOfTheScreen(card: self)
                UIView.animate(withDuration: Double(animationDuration),
                               delay: 0,
                               // 6
                    options: UIViewAnimationOptions.curveEaseOut,
                    animations: {
                        recognizer.view!.center = finalPoint
                        self.transform = CGAffineTransform.init(rotationAngle: CGFloat(rotateAngle))
                },
                    completion:{ (isCompleted) in
                        
                        //                        self.transform = CGAffineTransform.init(rotationAngle: CGFloat(0.0))
                        //                        self.initialCenterPoint = self._initialCenterPoint
                        
                        self.delegate?.itemDidRemoved(card: self)
                })
            }
        }
    }
    
    
    func returnToInitialPosition()  {
        
        delegate?.itemMovingBackToInitialPlace(card: self)
        
        UIView.animate(withDuration: 0.25) {
            
            self.center = self.initialCenterPoint
            self.transform = CGAffineTransform.init(rotationAngle: 0.0)
        }
    }
    
    
    func rotateView(currentCenter: CGPoint) -> Float{
        
        var xDifference: Float = Float(currentCenter.x - initialCenterPoint.x)
        xDifference = xDifference/10.0
        
        var rotationAngle: Float = 0.0
        
        
        print("self.frame.size.height/2::::::::::\(self.frame.size.height/2)")
        
        if xDifference > 0 {
            if initialTouchPoint.y > initalHeight/2 {
                rotationAngle = -(degreesToRadians(360.0 + xDifference))
            }else {
                rotationAngle = degreesToRadians(xDifference)
            }
        }else {
            if initialTouchPoint.y > initalHeight/2 {
                rotationAngle = -(degreesToRadians(xDifference))
            }else {
                rotationAngle = -(degreesToRadians(360.0 - xDifference))
            }
        }
        
        return rotationAngle
    }
}
