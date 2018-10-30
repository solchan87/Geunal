//
//  MainCollectionViewCell.swift
//  Geunal
//
//  Created by SolChan Ahn on 12/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

protocol MainCollectionViewCellDelegate{
    func presentDayViewData(dateData: DateData, calendarCellIndexPath: IndexPath)
}

class MainCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    private struct Metric {
        // collectionView
        static let numberOfItem: CGFloat = 7
        static let numberOfLine: CGFloat = 6
        
        static let itemSpacing: CGFloat = 3
        static let lineSpacing: CGFloat = 3
    }
    
}

extension MainCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        
        return cell
    }
}


extension MainCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing = Metric.itemSpacing * (Metric.numberOfItem - 1)
        let lineSpacing = Metric.lineSpacing * (Metric.numberOfLine - 1)
//        let width = (calendarCollectionView.frame.width - itemSpacing) / Metric.numberOfItem
//        let height = (calendarCollectionView.frame.height - lineSpacing) / Metric.numberOfLine
        
        return CGSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Metric.lineSpacing
    }
}
