//
//  PopAnimator.swift
//  PhotoSearchApp
//
//  Created by Anton Zyabkin on 18.02.2023.
//

import UIKit

class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration =  0.5
    var presenting =  true
    var originFrame =  CGRect .zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let photoView = presenting ? transitionContext.view(forKey: .to) : transitionContext.view(forKey: .from) else {
            print("failue photoView = presenting")
            return
        }
        let initialFrame = presenting ? originFrame : photoView.frame
        let finalFrame = presenting ? photoView.frame : originFrame
        
        let xScaleFactor = presenting ?
        initialFrame.width / finalFrame.width :
        finalFrame.width / initialFrame.width
        
        let yScaleFactor = presenting ?
        initialFrame.height / finalFrame.height :
        finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        if presenting {
            photoView.transform = scaleTransform
            photoView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
            photoView.clipsToBounds = true
        }
        containerView.addSubview(photoView)
        
        UIView.animate(
            withDuration: duration,
            delay:0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            animations: {
                photoView.transform = self.presenting ? .identity : scaleTransform
                photoView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
    }
}
