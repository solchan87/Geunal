//
//  MainAnimators.swift
//  Geunal
//
//  Created by SolChan Ahn on 18/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//



import UIKit

class PresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let setDuration = 0.4
    let removeDuration = 0.3
    
    var sourceVC: MainCollectionViewController!
    
    var mainCellIndexPath: IndexPath!
    
    var calendarCellIndexPath: IndexPath!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return setDuration + removeDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        let fromVC = fromViewController as! MainViewController
        let toVC = toViewController as! DayViewController
        
        transitionContext.containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        
        guard let startContainerView = fromVC.mainContainerView else {
            transitionContext.completeTransition(true)
            return
        }
        
        guard let sourceVC = sourceVC else {
            transitionContext.completeTransition(true)
            return
        }
        
        guard let mainCell = sourceVC.collectionViewLayout.collectionView!.cellForItem(at: mainCellIndexPath!) as? MainCollectionViewCell else {
            transitionContext.completeTransition(true)
            return
        }
        
        guard let calendarCell = mainCell.calendarCollectionView.cellForItem(at: calendarCellIndexPath) as? CalendarCollectionViewCell else {
            transitionContext.completeTransition(true)
            return
        }
        
        guard let dateLabel = calendarCell.dateLabel else {
            transitionContext.completeTransition(true)
            return
        }
        
        var startPointX: CGFloat = 0
        startPointX += startContainerView.frame.origin.x
        startPointX += mainCell.calendarBackgroundView.frame.origin.x
        startPointX += mainCell.calendarCollectionView.frame.origin.x
        startPointX += calendarCell.frame.origin.x
        startPointX += dateLabel.frame.origin.x
        
        var startPointY: CGFloat = 0
        startPointY += startContainerView.frame.origin.y
        startPointY += mainCell.calendarBackgroundView.frame.origin.y
        startPointY += mainCell.calendarCollectionView.frame.origin.y
        startPointY += calendarCell.frame.origin.y
        startPointY += dateLabel.frame.origin.y

        var dayCenterPointX: CGFloat = 0
        dayCenterPointX += toVC.dateLabel.frame.midX
        
        var dayCenterPointY: CGFloat = 0
        dayCenterPointY += toVC.dateLabel.frame.midY
        
        let bigScale: CGFloat = toVC.dateLabel.font.pointSize / dateLabel.font.pointSize
        let smallScale: CGFloat = dateLabel.font.pointSize / toVC.dateLabel.font.pointSize
        
        calendarCell.isHidden = true
        
        guard let backgroundView = fromVC.view!.snapshot else {
            transitionContext.completeTransition(true)
            return
        }
        
        calendarCell.isHidden = false
        
        backgroundView.frame.origin = fromVC.view!.convert(.zero, to: nil)
        
        // 블러
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: nil)
        blurEffectView.frame = backgroundView.bounds
        backgroundView.addSubview(blurEffectView)
        
        transitionContext.containerView.addSubview(backgroundView)
        
        let transitionLabel = UILabel()
        
        transitionLabel.text = toVC.dateLabel.text
        transitionLabel.frame = toVC.dateLabel.frame
        transitionLabel.font = toVC.dateLabel.font
        
        if calendarCell.dateData!.dayOfWeek == 1 {
            transitionLabel.textColor = UIColor(named: "SunColor")
        }else {
            transitionLabel.textColor = UIColor(named: "NormalColor")
        }
        
        // fontSize 최대 사이즈 변경 - 추후 레이아웃 변경시 변경 요망
        transitionLabel.transform = CGAffineTransform(scaleX: smallScale, y: smallScale)
        
        transitionLabel.frame.origin = CGPoint(x: startPointX, y: startPointY)
    
        transitionContext.containerView.addSubview(transitionLabel)
        
        
        
        let centerX: CGFloat = backgroundView.frame.midX + ((backgroundView.frame.midX - transitionLabel.frame.midX) * bigScale)
        
        let centerY: CGFloat = backgroundView.frame.midY + ((backgroundView.frame.midY - transitionLabel.frame.midY) * bigScale)
        
        let diffY: CGFloat = dayCenterPointY - backgroundView.frame.midY
        
        
//        toVC.view.isHidden = true
        
        
        UIView.animate(withDuration: setDuration, delay: 0.0, options: .curveEaseOut, animations: {
            transitionLabel.transform = .identity
            transitionLabel.center = CGPoint(x: toVC.dateLabel.frame.midX, y: toVC.dateLabel.frame.midY)

            backgroundView.center = CGPoint(x: centerX, y: centerY + diffY)
            backgroundView.transform = CGAffineTransform(scaleX: bigScale, y: bigScale)
            blurEffectView.effect = blurEffect
        }) { (finished) in
            UIView.animate(withDuration: self.removeDuration, delay: 0.0, options: .curveEaseOut, animations: {
                backgroundView.alpha = 0.0
            }) { (finished) in
                transitionLabel.removeFromSuperview()
                backgroundView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
            
        }
    }
    
}


