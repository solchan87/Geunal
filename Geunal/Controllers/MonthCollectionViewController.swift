//
//  MonthCollectionViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 14/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

protocol MonthCollectionViewDelegate {
    func didChangeMonth(month: Int)
}

class MonthCollectionViewController: UICollectionViewController {
    
    private var indexOfCellBeforeDragging = 0
    
    private struct CellMetric {
        static let width: CGFloat = 50
        static let height: CGFloat = 25
    }
    
    var searchMonth: Int = 0 {
        didSet {
            if oldValue != searchMonth {
                self.delegate?.didChangeMonth(month: searchMonth)
            }
        }
    }
    
    var delegate: MonthCollectionViewDelegate?
    
    let month: [Int] = [12,1,2,3,4,5,6,7,8,9,10,11,12,1]
    
    var visibelMonth: Int = 0
    
    var firstFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if firstFlag {
            configureCollectionViewLayoutItemSize()
            firstFlag = false
        }
    }

    func setSearchMonth(month: Int, hideFlag: Bool) {
        
        var searchMonth = month
        if visibelMonth == 2 && searchMonth == 1{
            searchMonth = 1
        }else if visibelMonth == 1 && searchMonth == 12 {
            searchMonth = 0
        }else if visibelMonth == 11 && searchMonth == 12 {
            searchMonth = 12
        }else if visibelMonth == 12 && searchMonth == 1 {
            searchMonth = 13
        }else if visibelMonth == 13 && searchMonth == 12 {
            searchMonth = 0
        }else if visibelMonth == 0 && searchMonth == 1 {
            searchMonth = 13
        }
        let indexPath = IndexPath(item: searchMonth, section: 0)
        self.collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredVertically, animated: hideFlag)
        visibelMonth = searchMonth
    }
    
    private func calculateSectionInset() -> CGFloat{
        let height: CGFloat = self.collectionViewLayout.collectionView!.frame.height
        let inset = (height - CellMetric.height) / 2
        
        return inset
    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset()
        
        self.collectionViewLayout.collectionView!.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        
        self.collectionViewLayout.collectionView!.contentSize = CGSize(width: self.collectionViewLayout.collectionView!.frame.size.width - inset * 2, height: self.collectionViewLayout.collectionView!.frame.size.height)
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return month.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCollectionViewCell", for: indexPath) as! MonthCollectionViewCell
    
        cell.monthNum = month[indexPath.row]
    
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
            self.searchMonth = month[indexOfMajorCell]
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let X = scrollView.contentOffset.y
        if X > 0
        {
            if X >=  (CellMetric.height * CGFloat(month.count - 1)) - calculateSectionInset() {
                self.collectionViewLayout.collectionView!.contentOffset = CGPoint(x:0 , y:  CellMetric.height - calculateSectionInset())
            }
        }
        else if X < 0
        {
            self.collectionViewLayout.collectionView!.contentOffset = CGPoint(x:0 , y:  CellMetric.height * CGFloat(month.count - 2))
        }
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(600), execute: {
            self.setCellHideFlag(index: self.indexOfYearCell())
        })
    }
    
    func setCellHideFlag(index: Int){
        var tempArray: [Int] = []
        if index == 1 {
            tempArray.append(0)
            tempArray.append(2)
        }else if index == 12 {
            tempArray.append(11)
            tempArray.append(13)
        }else if 1 < index && index < 12 {
            tempArray.append(index - 1)
            tempArray.append(index + 1)
        }
        
        for num in tempArray {
            let cell = self.collectionViewLayout.collectionView!.cellForItem(at: IndexPath(item: num, section: 0)) as! MonthCollectionViewCell
            cell.cellFadeFlag = false
        }
    }

}

