//
//  DismissAnimator.swift
//  Geunal
//
//  Created by SolChan Ahn on 19/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let setDuration = 0.0
    let removeDuration = 0.4
    
    var sourceVC: MainCollectionViewController!
    
    var mainCellIndexPath: IndexPath!
    
    var calendarCellIndexPath: IndexPath!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return setDuration + removeDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toViewController = transitionContext.viewController(forKey: .to)!
        
        let fromVC = fromViewController as! DayViewController
        let toVC = toViewController as! MainViewController
        
        transitionContext.containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        
        guard let startContainerView = toVC.mainContainerView else {
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
        dayCenterPointX += fromVC.dateLabel.frame.midX
        
        var dayCenterPointY: CGFloat = 0
        dayCenterPointY += fromVC.dateLabel.frame.midY
        
        let bigScale: CGFloat = fromVC.dateLabel.font.pointSize / dateLabel.font.pointSize
        let smallScale: CGFloat = dateLabel.font.pointSize / fromVC.dateLabel.font.pointSize
        
        // 레이블 속성
        let transitionLabel = UILabel()
        
        transitionLabel.text = fromVC.dateLabel.text
        transitionLabel.frame = fromVC.dateLabel.frame
        transitionLabel.font = fromVC.dateLabel.font
        
        if calendarCell.dateData!.dayOfWeek == 1 {
            transitionLabel.textColor = UIColor(named: "SunColor")
        }else {
            transitionLabel.textColor = UIColor(named: "NormalColor")
        }
        
        // fontSize 최대 사이즈 변경 - 추후 레이아웃 변경시 변경 요망
        transitionLabel.transform = CGAffineTransform(scaleX: smallScale, y: smallScale)
        
        transitionLabel.frame.origin = CGPoint(x: startPointX, y: startPointY)
        
        // 백그라운드 뷰 속성
        calendarCell.isHidden = true
        
        guard let backgroundView = toVC.view!.snapshot else {
            transitionContext.completeTransition(true)
            return
        }
        
        calendarCell.isHidden = false
        
        let centerX: CGFloat = backgroundView.frame.midX + ((backgroundView.frame.midX - transitionLabel.frame.midX) * bigScale)
        
        let centerY: CGFloat = backgroundView.frame.midY + ((backgroundView.frame.midY - transitionLabel.frame.midY) * bigScale)
        
        let diffY: CGFloat = dayCenterPointY - backgroundView.frame.midY
        
        backgroundView.transform = CGAffineTransform(scaleX: bigScale, y: bigScale)
        
        backgroundView.center = CGPoint(x: centerX, y: centerY + diffY)
        
        backgroundView.alpha = 0.0
        
        fromVC.dateLabel.isHidden = true
        
        guard let fromView = fromVC.view!.snapshot else {
            transitionContext.completeTransition(true)
            return
        }
        
        fromVC.dateLabel.isHidden = false
        
        let whiteView = UIView(frame: fromVC.view!.frame)
        whiteView.backgroundColor = .white
        
        // 블러 속성
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundView.bounds
        backgroundView.addSubview(blurEffectView)
        blurEffectView.effect = blurEffect
        
        // Label 속성
        transitionLabel.transform = .identity
        transitionLabel.center = CGPoint(x: dayCenterPointX, y: dayCenterPointY)
        
        
        transitionContext.containerView.addSubview(whiteView)
        
        transitionContext.containerView.addSubview(backgroundView)
        
        transitionContext.containerView.addSubview(fromView)
        
        transitionContext.containerView.addSubview(transitionLabel)
        
        UIView.animate(withDuration: setDuration, delay: 0.0, options: .curveEaseOut, animations: {
            backgroundView.alpha = 1.0
            fromView.alpha = 0.0
        }) { (finished) in
            UIView.animate(withDuration: self.removeDuration, delay: 0.0, options: .curveEaseOut, animations: {
                transitionLabel.transform = CGAffineTransform(scaleX: smallScale, y: smallScale)
                transitionLabel.frame.origin = CGPoint(x: startPointX, y: startPointY)
                
                backgroundView.center = CGPoint(x: toVC.view.frame.midX, y: toVC.view.frame.midY)
                backgroundView.transform = .identity
                blurEffectView.effect = nil
            }) { (finished) in
                transitionLabel.removeFromSuperview()
                backgroundView.removeFromSuperview()
                whiteView.removeFromSuperview()
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
            
        }
    }
}
