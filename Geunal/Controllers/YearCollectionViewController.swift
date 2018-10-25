//
//  YearCollectionViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 14/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

protocol YearCollectionViewDelegate {
    func didChangeYear(year: Int)
}


/// 검색 년도를 관리하는 클래스
class YearCollectionViewController: UICollectionViewController {
    
    private struct CellMetric {
        static let width: CGFloat = 50
        static let height: CGFloat = 25
    }
    
    private var indexOfCellBeforeDragging = 0
    
    var year: [Int]!
    
    let calendarService = CalendarService()
    
    var delegate: YearCollectionViewDelegate?
    
    // 처음 시작시에만 실행 함수
    var firstFlag = true
    
    var searchYear: Int = 0 {
        didSet {
            if oldValue != searchYear {
                self.delegate?.didChangeYear(year: searchYear)
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        year = Array(calendarService.startYear...calendarService.endYear)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if firstFlag {
            configureCollectionViewLayoutItemSize()
            firstFlag = false
        }
    }
    
    // 검색 후 아래 위 셀들을 숨기는 함수
    func setSearchYear(year: Int, hideFlag: Bool) {
        if year >= calendarService.startYear && calendarService.endYear >= year {
            let indexPath = IndexPath(item: year - calendarService.startYear, section: 0)
            self.collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredVertically, animated: hideFlag)
        }
    }
    
    // 위 아래 여백 계산 함수
    private func calculateSectionInset() -> CGFloat{
        let height: CGFloat = self.collectionViewLayout.collectionView!.frame.height
        let inset = (height - CellMetric.height) / 2
        
        return inset
    }
    
    // 위아래 여백 생성
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
        return year.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YearCollectionViewCell", for: indexPath) as! YearCollectionViewCell
        
        cell.yearNum = year[indexPath.row]
        
        return cell
    }
    
}

extension YearCollectionViewController: UICollectionViewDelegateFlowLayout {
    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: CellMetric.width, height: CellMetric.height)
    }
    
    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
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
            self.searchYear = year[indexOfMajorCell]
        }
        
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.setCellHideFlag(index: self.indexOfYearCell())
        })
    }
    
    private func setCellHideFlag(index: Int){
        if let prevCell = self.collectionViewLayout.collectionView!.cellForItem(at: IndexPath(row: index - 1, section: 0)) as? YearCollectionViewCell {
            prevCell.cellFadeFlag = false
        }
        
        if let nextCell = self.collectionViewLayout.collectionView!.cellForItem(at: IndexPath(row: index + 1, section: 0)) as? YearCollectionViewCell {
            nextCell.cellFadeFlag = false
        }
    }
}
