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
    
    var dateData: DateData? {
        didSet{
            configureDate()
        }
    }
    
    
    
    private func configureDate(){
        if let dateData = dateData {
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
