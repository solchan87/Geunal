//
//  DayViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 18/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

class DayViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBOutlet weak var dayTableView: UITableView!
    
    var dateData: DateData? {
        didSet{
            configureDate()
        }
    }
    @IBAction func dismissButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func configureDate() {
        if let dateData = dateData {
            
            if dateData.dayOfWeek == 1 {
                dateLabel.textColor = UIColor(named: "SunColor")
                weekLabel.textColor = UIColor(named: "SunColor")
            }else {
                dateLabel.textColor = UIColor(named: "NormalColor")
                weekLabel.textColor = UIColor(named: "NormalColor")
            }
            
            dateLabel.text = String(dateData.date)
            
            switch  dateData.dayOfWeek{
            case 1:
                weekLabel.text = "일요일"
            case 2:
                weekLabel.text = "월요일"
            case 3:
                weekLabel.text = "화요일"
            case 4:
                weekLabel.text = "수요일"
            case 5:
                weekLabel.text = "목요일"
            case 6:
                weekLabel.text = "금요일"
            case 7:
                weekLabel.text = "토요일"
            default:
                weekLabel.text = ""
            }
            
            switch dateData.month {
            case 1:
                monthLabel.text = "일월"
            case 2:
                monthLabel.text = "이월"
            case 3:
                monthLabel.text = "삼월"
            case 4:
                monthLabel.text = "사월"
            case 5:
                monthLabel.text = "오월"
            case 6:
                monthLabel.text = "유월"
            case 7:
                monthLabel.text = "칠월"
            case 8:
                monthLabel.text = "팔월"
            case 9:
                monthLabel.text = "구월"
            case 10:
                monthLabel.text = "시월"
            case 11:
                monthLabel.text = "십일월"
            case 12:
                monthLabel.text = "십이월"
            default:
                monthLabel.text = ""
            }
            
        }
    }

}

extension DayViewController: UIViewControllerTransitioningDelegate {
    
}
