//
//  CardStackManagere.swift
//  HellowLit_v2
//
//  Created by Rakesh Jyoti on 12/7/17.
//  Copyright © 2017 RJ. All rights reserved.
//

import UIKit

class CardStackManagere: UIView {

    var arrayCards: [CardView] = []
    let maxCardToShow = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.backgroundColor = UIColor.blue
    }

    
    func addCardsInView() {
        let bottomPadding: CGFloat = 20.0 *  ((UIApplication.shared.keyWindow?.bounds.size.height)! / 568.0)
        var rect = self.bounds
        rect.size.height -= bottomPadding
        
        while arrayCards.count < maxCardToShow {
            
            let card = CardView.initWithXib(frame: rect)
            card.initialCenterPoint = card.center
            
            card.delegate = self
            
            self.addSubview(card)
            arrayCards.append(card)
        }
        
        alignCards()
    }
    
    
    let paddingBottomExtra: CGFloat = 22.0 *  ((UIApplication.shared.keyWindow?.bounds.size.height)! / 568.0)

    func alignCards() {
        
        for i in (0..<arrayCards.count).reversed() {
            
            let card = arrayCards[i]
            var centerPoint = card.initialCenterPoint
            centerPoint.y += paddingBottomExtra * CGFloat(i)
            card.center = centerPoint
            
            let scaleValue = 1.0 - (CGFloat(i) * 0.1)
            card.transform = CGAffineTransform.init(scaleX: scaleValue, y: scaleValue)
            
            card.superview?.bringSubview(toFront: card)
            card.isUserInteractionEnabled = (i == 0)
        }
    }
}


extension CardStackManagere: DelegateCards {
    
    func itemDidRemoved(card: CardView) {
        
//        arrayCards.removeFirst()
//        self.addCardsInView()
    }
    
    
    func movingCurrentItemWithCenter(currentCenter: CGPoint, card: CardView) {
        
        let maxDifference: CGFloat = 100.0
        var xDiffenerce: CGFloat = fabs(currentCenter.x - card.initialCenterPoint.x)
        if xDiffenerce > maxDifference {
            xDiffenerce = maxDifference
        }
        
        for i in (1..<arrayCards.count) {
            
            let card = arrayCards[i]
            var centerPoint = card.initialCenterPoint
            centerPoint.y += paddingBottomExtra * CGFloat(i) - paddingBottomExtra * (xDiffenerce / maxDifference)
            card.center = centerPoint
            
            let scaleValue = 1.0 - (CGFloat(i) * 0.1) + (0.1 * (xDiffenerce / maxDifference))
            card.transform = CGAffineTransform.init(scaleX: scaleValue, y: scaleValue)
        }
    }
    
    
    func itemMovingBackToInitialPlace(card: CardView) {
     
        UIView.animate(withDuration: 0.25) {

            for i in (1..<self.arrayCards.count) {
                
                let card = self.arrayCards[i]
                var centerPoint = card.initialCenterPoint
                centerPoint.y += self.paddingBottomExtra * CGFloat(i)
                card.center = centerPoint
                
                let scaleValue = 1.0 - (CGFloat(i) * 0.1)
                card.transform = CGAffineTransform.init(scaleX: scaleValue, y: scaleValue)
                
            }
        }
    }
    
    
    func itemGoingOutSideOfTheScreen(card: CardView) {
        
        UIView.animate(withDuration: 0.15, animations: {
            for i in (1..<self.arrayCards.count) {
                
                let card = self.arrayCards[i]
                var centerPoint = card.initialCenterPoint
                centerPoint.y += self.paddingBottomExtra * CGFloat(i) - self.paddingBottomExtra
                card.center = centerPoint
                
                let scaleValue = 1.0 - (CGFloat(i) * 0.1) + 0.1
                card.transform = CGAffineTransform.init(scaleX: scaleValue, y: scaleValue)
            }

        }) { (iscompleted) in
            self.arrayCards.removeFirst()
            self.addCardsInView()
            card.superview?.bringSubview(toFront: card)
        }
    }
}



