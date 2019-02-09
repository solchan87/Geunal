//
//  CalendarCollectionViewCell.swift
//  Geunal
//
//  Created by SolChan Ahn on 12/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var firstDot: UIImageView!
    @IBOutlet weak var secondDot: UIImageView!
    @IBOutlet weak var thirdDot: UIImageView!
    
    var dateData: DateModel? {
        didSet{
            configureDate()
        }
    }
    
    var messageCount: Int! {
        didSet {
            switch messageCount {
            case 0:
                firstDot.isHidden = true
                secondDot.isHidden = true
                thirdDot.isHidden = true
            case 1:
                firstDot.isHidden = false
                secondDot.isHidden = true
                thirdDot.isHidden = true
            case 2:
                firstDot.isHidden = false
                secondDot.isHidden = false
                thirdDot.isHidden = true
            default:
                firstDot.isHidden = false
                secondDot.isHidden = false
                thirdDot.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        firstDot.tintColor = .lightGray
        firstDot.isHidden = true
        secondDot.tintColor = .lightGray
        secondDot.isHidden = true
        thirdDot.tintColor = .lightGray
        thirdDot.isHidden = true
    }
    
    private func configureDate(){
        if let dateData = dateData {
            if dateData.today {
                dateLabel.font = UIFont(name: "SunBatang-Medium", size: 20.0)
            }else  {
                dateLabel.font = UIFont(name: "SunBatang-Light", size: 17.0)
            }
            if dateData.dateType {
                self.isUserInteractionEnabled = true
                dateLabel.isHidden = false
                dateLabel.text = String(dateData.date)
                if dateData.dayOfWeek == 1 {
                    dateLabel.textColor = UIColor(named: "SunColor")
                }else {
                    dateLabel.textColor = UIColor(named: "NormalColor")
                }
            }else {
                self.isUserInteractionEnabled = false
                dateLabel.isHidden = true
                dateLabel.text = String(dateData.date)
            }
        }
    }
}
