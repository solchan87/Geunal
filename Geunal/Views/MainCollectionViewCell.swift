//
//  MainCollectionViewCell.swift
//  Geunal
//
//  Created by SolChan Ahn on 12/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit
import RealmSwift

protocol MainCollectionViewCellDelegate{
    func presentDayViewData(dateData: DateData, calendarCellIndexPath: IndexPath)
}

class MainCollectionViewCell: UICollectionViewCell {
    
    let realm = try! Realm()
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var calendarBackgroundView: UIView!
    
    @IBOutlet weak var monthTitle: UILabel!
    
    var delegate: MainCollectionViewCellDelegate?
    
    var monthData: MonthData! {
        didSet{
            
            self.calendarCollectionView.reloadData()
            
            switch monthData?.month {
            case 1:
                monthTitle.text = "일월"
            case 2:
                monthTitle.text = "이월"
            case 3:
                monthTitle.text = "삼월"
            case 4:
                monthTitle.text = "사월"
            case 5:
                monthTitle.text = "오월"
            case 6:
                monthTitle.text = "유월"
            case 7:
                monthTitle.text = "칠월"
            case 8:
                monthTitle.text = "팔월"
            case 9:
                monthTitle.text = "구월"
            case 10:
                monthTitle.text = "시월"
            case 11:
                monthTitle.text = "십일월"
            case 12:
                monthTitle.text = "십이월"
            default:
                monthTitle.text = ""
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendarCollectionView.reloadData()
        self.calendarBackgroundView.layer.cornerRadius = 5
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
        return monthData?.dateDatas.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCollectionViewCell", for: indexPath) as! CalendarCollectionViewCell
        cell.dateData = monthData?.dateDatas[indexPath.item]
        
        if let messageCount = realm.objects(DayMessage.self).filter("year = \(monthData.year) AND month = \(monthData.month) AND date = \(monthData.dateDatas[indexPath.row].date)").first?.messages.count {
            cell.messageCount = messageCount
        }else {
            cell.messageCount = 0
        }
        return cell
    }
}

extension MainCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing = Metric.itemSpacing * (Metric.numberOfItem - 1)
        let lineSpacing = Metric.lineSpacing * (Metric.numberOfLine - 1)
        let width = (calendarCollectionView.frame.width - itemSpacing) / Metric.numberOfItem
        let height = (calendarCollectionView.frame.height - lineSpacing) / Metric.numberOfLine
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Metric.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = calendarCollectionView.cellForItem(at: indexPath) as! CalendarCollectionViewCell
        
        self.delegate?.presentDayViewData(dateData: cell.dateData!, calendarCellIndexPath: indexPath)
    }
}
