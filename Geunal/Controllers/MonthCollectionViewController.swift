//
//  MonthCollectionViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 14/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit


/// 월 검색 관리 클래스
class MonthCollectionViewController: UICollectionViewController {
    
    private struct CellMetric {
        static let width: CGFloat = 50
        static let height: CGFloat = 25
    }
    
    private var indexOfCellBeforeDragging = 0
    
    let cellCount = 1000000
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureCollectionViewLayoutItemSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
    }
    
    // 인셋 사이즈 관리 함수
    private func calculateSectionInset() -> CGFloat{
        let height: CGFloat = self.collectionViewLayout.collectionView!.frame.height
        let inset = (height - CellMetric.height) / 2
        
        return inset
    }
    
    // 인셋 세팅 함수
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset()
        
        self.collectionViewLayout.collectionView!.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        
        self.collectionViewLayout.collectionView!.contentSize = CGSize(width: self.collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: self.collectionViewLayout.collectionView!.frame.size.height)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCollectionViewCell", for: indexPath) as! MonthCollectionViewCell
        
        print("ghfghf")
        return cell
    }
    
}

extension MonthCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CellMetric.width, height: CellMetric.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 현재 해당되는 셀의 함수
    private func indexOfYearCell() -> Int {
        let proportionalOffset = self.collectionViewLayout.collectionView!.contentOffset.y / CellMetric.height
        let index = Int(round(proportionalOffset + 0.5))
        let numberOfItems = self.collectionViewLayout.collectionView!.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        
        return safeIndex
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        
        let indexOfMajorCell = self.indexOfYearCell()
        
        let dataSourceCount = collectionView(self.collectionViewLayout.collectionView!, numberOfItemsInSection: 0)
        
        let swipeVelocityThreshold: CGFloat = 0.5
        
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.y > swipeVelocityThreshold
        
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.y < -swipeVelocityThreshold
        
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = CellMetric.height * CGFloat(snapToIndex)
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
            self.collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }
    }
}

