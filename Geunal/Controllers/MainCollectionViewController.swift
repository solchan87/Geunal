//
//  MainCollectionViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 12/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

protocol MainCollectionViewDelegate {
    func didChangeVisibleYear(year: Int)
    func didChangeVisibleMonth(month: Int)
    func getPresentData(dateData: DateData, calendarCellIndexPath: IndexPath, mainCellIndexPath: IndexPath)
}

class MainCollectionViewController: UICollectionViewController {
    
    var year: [Int]!
    let month: [Int] = Array(1...12)
    
    var visibleYear: Int = 0 {
        didSet {
            if oldValue != visibleYear {
                self.delegate?.didChangeVisibleYear(year: visibleYear)
            }
        }
    }
    
    var visibleMonth: Int = 0 {
        didSet {
            if oldValue != visibleMonth {
                self.delegate?.didChangeVisibleMonth(month: visibleMonth)
            }
        }
    }
    
    let calendarService = CalendarService()
    
    var delegate: MainCollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        year = Array(calendarService.startYear...calendarService.endYear)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return year.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return month.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        
        let monthData = calendarService.getMonthData(year: year[indexPath.section], month: month[indexPath.row])
        calendarCell.monthData = monthData
        
        calendarCell.delegate = self
        
        return calendarCell
    }
    
    func setCalendarView(year: Int, month: Int, animated: Bool) {
        let indexPath = IndexPath(row: month - 1, section: year - calendarService.startYear)
        
        collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
    
    func getVisiblePageIndex() -> IndexPath? {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return nil }
        
        return indexPath
    }
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = self.view.frame.width
        let height: CGFloat = self.view.frame.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let visibleIndex = getVisiblePageIndex() {
            visibleYear = year[visibleIndex.section]
            visibleMonth = month[visibleIndex.row]
        }
    }
}

extension MainCollectionViewController: MainCollectionViewCellDelegate {
    func presentDayViewData(dateData: DateData, calendarCellIndexPath: IndexPath) {
        self.delegate?.getPresentData(dateData: dateData, calendarCellIndexPath: calendarCellIndexPath, mainCellIndexPath: getVisiblePageIndex()!)
    }
    
}

