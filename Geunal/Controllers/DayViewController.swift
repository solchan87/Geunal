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
    @IBOutlet weak var monthSubView: UILabel!
    @IBOutlet weak var monthView: UIView!
    
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weekSubLabel: UILabel!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var weekSubView: UIView!
    @IBOutlet weak var calendarImageView: UIImageView!
    
    @IBOutlet weak var dayTableView: UITableView!
    
    private var sourceIndexPath: IndexPath?
    
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
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(DayViewController.longPressGestureRecognized(longPress:)))
        self.dayTableView.addGestureRecognizer(longPress)
        
        weekView.layer.borderWidth = 0.5
        weekView.layer.cornerRadius = 5
        weekView.layer.borderColor = UIColor(named: "NormalColor")?.cgColor
        
        monthView.layer.borderWidth = 0.5
        monthView.layer.cornerRadius = 5
        monthView.layer.borderColor = UIColor(named: "NormalColor")?.cgColor
    }
    
    @objc func longPressGestureRecognized(longPress: UILongPressGestureRecognizer) {
        
        let state = longPress.state
        let location = longPress.location(in: self.dayTableView)
        guard let indexPath = self.dayTableView.indexPathForRow(at: location) else { return }
        let cell = self.dayTableView.cellForRow(at: indexPath) as! DayTableViewCell
        
//        if cell.animationTime <= 1 {
//            cell.animationTime = cell.animationTime + 0.02
//        }
//        
//        if state == .ended {
//            while cell.animationTime >= 0.8 {
//                cell.animationTime = cell.animationTime - 0.01
//            }
//        }
        
    }
    
    
    private func configureDate() {
        if let dateData = dateData {
            
            if dateData.dayOfWeek == 1 {
                print("jebal")
                dateLabel.textColor = UIColor(named: "SunColor")
                weekLabel.textColor = UIColor(named: "SunColor")
                weekView.layer.borderColor = UIColor(named: "SunColor")?.cgColor
                weekSubView.backgroundColor = UIColor(named: "SunColor")
            }else {
                dateLabel.textColor = UIColor(named: "NormalColor")
                weekLabel.textColor = UIColor(named: "NormalColor")
                weekView.layer.borderColor = UIColor(named: "NormalColor")?.cgColor
                weekSubView.backgroundColor = UIColor(named: "NormalColor")
            }
            
            dateLabel.text = String(dateData.date)
            
            switch  dateData.dayOfWeek{
            case 1:
                weekLabel.text = "일"
                weekSubLabel.text = "SUN"
            case 2:
                weekLabel.text = "월"
                weekSubLabel.text = "MON"
            case 3:
                weekLabel.text = "화"
                weekSubLabel.text = "TUE"
            case 4:
                weekLabel.text = "수"
                weekSubLabel.text = "WED"
            case 5:
                weekLabel.text = "목"
                weekSubLabel.text = "THU"
            case 6:
                weekLabel.text = "금"
                weekSubLabel.text = "FRI"
            case 7:
                weekLabel.text = "토"
                weekSubLabel.text = "SAT"
            default:
                weekLabel.text = ""
            }
            
            switch dateData.month {
            case 1:
                monthLabel.text = "1"
                monthSubView.text = "일월"
            case 2:
                monthLabel.text = "2"
                monthSubView.text = "이월"
            case 3:
                monthLabel.text = "3"
                monthSubView.text = "삼월"
            case 4:
                monthLabel.text = "4"
                monthSubView.text = "사월"
            case 5:
                monthLabel.text = "5"
                monthSubView.text = "오월"
            case 6:
                monthLabel.text = "6"
                monthSubView.text = "유월"
            case 7:
                monthLabel.text = "7"
                monthSubView.text = "칠월"
            case 8:
                monthLabel.text = "8"
                monthSubView.text = "팔월"
            case 9:
                monthLabel.text = "9"
                monthSubView.text = "구월"
            case 10:
                monthLabel.text = "10"
                monthSubView.text = "시월"
            case 11:
                monthLabel.text = "11"
                monthSubView.text = "십일월"
            case 12:
                monthLabel.text = "12"
                monthSubView.text = "십이월"
            default:
                monthLabel.text = ""
            }
            
        }
    }

}

extension DayViewController: UIViewControllerTransitioningDelegate {
    
}

extension DayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension DayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dayCell = dayTableView.dequeueReusableCell(withIdentifier: "DayTableViewCell") as! DayTableViewCell
        dayCell.message = "아 제발 좀 됐으면 좋겠다."
        return dayCell
    }
    
    
}
