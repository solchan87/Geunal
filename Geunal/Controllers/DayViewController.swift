//
//  DayViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 18/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit
import RealmSwift

// 일력 페이지 클래스
class DayViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthSubView: UILabel!
    @IBOutlet weak var monthView: UIView!
    
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weekSubLabel: UILabel!
    @IBOutlet weak var weekView: UIView!
    @IBOutlet weak var weekSubView: UIView!
    
    @IBOutlet weak var midBarView: UIView!
    @IBOutlet weak var writeContainerView: UIView!
    
    @IBOutlet weak var calendarImageView: UIImageView!
    
    @IBOutlet weak var dayTableView: UITableView!
    
    private var sourceIndexPath: IndexPath?
    
    let realm = try! Realm()
    
    private var writeViewController: WriteViewController!
    
    // 셀 수정창이 한개의 셀에서만 나오게 하는 변수
    private var selectCell: DayTableViewCell! {
        didSet {
            if let cell = oldValue {
                cell.buttonViewFlag = false
            }
            selectCell.buttonViewFlag = true
        }
    }
    
    var dateData: DateData! {
        didSet{
            configureDate()
            reloadMessage()
            writeViewController.dateData = dateData
        }
    }
    
    var dayMessage: DayMessage?
    
    @IBAction func dismissButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func writeMessageButton(_ sender: Any) {
        writeViewController.sendFlag = true
        writeContainerView.isHidden = false
        writeViewController.showWriteView()
        writeViewController.editFlag = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 제스처 관련
        let penGesture = UIPanGestureRecognizer(target: self, action: #selector(self.penGestureRecognized(penGesture:)))
        penGesture.delegate = self
        
        self.dayTableView.addGestureRecognizer(penGesture)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longGestureRecognized(longGesture:)))
        longGesture.delegate = self
        longGesture.minimumPressDuration = 0.6
        
        self.dayTableView.addGestureRecognizer(longGesture)
        
        weekView.layer.borderWidth = 0.5
        weekView.layer.cornerRadius = 5
        weekView.layer.borderColor = UIColor(named: "NormalColor")?.cgColor
        
        monthView.layer.borderWidth = 0.5
        monthView.layer.cornerRadius = 5
        monthView.layer.borderColor = UIColor(named: "NormalColor")?.cgColor
        
        // 그라데이션
        let gradient = CAGradientLayer()
        gradient.frame = midBarView.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0, 0.2, 0.8, 1]
        midBarView.layer.mask = gradient
        
    }
    
    func reloadMessage() {
        if let dayMessage = realm.objects(DayMessage.self).filter("year = \(dateData.year) AND month = \(dateData.month) AND date = \(dateData.date)").first {
            self.dayMessage = dayMessage
        }
        dayTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "writeSegue") {
            writeViewController = segue.destination as? WriteViewController
            writeViewController.delegate = self
        }
    }
    
    @objc func penGestureRecognized(penGesture: UIPanGestureRecognizer) {
        
        let state = penGesture.state
        
        let location = penGesture.location(in: self.dayTableView)
        guard let indexPath = self.dayTableView.indexPathForRow(at: location) else { return }
        
        guard let cell = self.dayTableView.cellForRow(at: indexPath) as? DayTableViewCell else { return }
        
        // 이동하는 것 만큼 블러 Radius 변경
        let point = penGesture.translation(in: cell).x
        cell.showMessageLabel(point: point.magnitude)
        
        if state == .ended {
            cell.hideMessageLabel()
        }
    }
    
    // long press gesture 로 셀 수정창 관리
    @objc func longGestureRecognized(longGesture: UILongPressGestureRecognizer) {
        let location = longGesture.location(in: self.dayTableView)
        guard let indexPath = self.dayTableView.indexPathForRow(at: location) else { return }
        
        if longGesture.state == .began {
            if let cell = self.dayTableView.cellForRow(at: indexPath) as? DayTableViewCell {
                self.selectCell = cell
            }
        }
    }
    
    private func configureDate() {
        if let dateData = dateData {
            
            if dateData.dayOfWeek == 1 {
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
        return (dayMessage?.messages.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == (dayMessage?.messages.count ?? 0){
            let testCell = dayTableView.dequeueReusableCell(withIdentifier: "testCell")
            return testCell!
        }else {
            let dayCell = dayTableView.dequeueReusableCell(withIdentifier: "DayTableViewCell") as! DayTableViewCell
            if let dayMessage = dayMessage {
                dayCell.message = dayMessage.messages[indexPath.row]
            }
            dayCell.delegate = self
            return dayCell
        }
    }
}

extension DayViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DayViewController: WriteViewControllerDelegate {
    func didCancelButton() {
        reloadMessage()
        writeContainerView.isHidden = true
    }
    
    func didWriteButton() {
        reloadMessage()
        writeContainerView.isHidden = true
    }
    
    func didUpdateButton() {
        reloadMessage()
        writeContainerView.isHidden = true
    }
}

extension DayViewController: DayTableViewCellDelegate {
    func pushUpdateButton(message: Message) {
        writeViewController.sendFlag = false
        writeContainerView.isHidden = false
        writeViewController.editFlag = false
        writeViewController.message = message
        writeViewController.showWriteView()
    }
    
    func pushDeleteButton(message: Message) {
        try! realm.write {
            realm.delete(message)
            reloadMessage()
        }
    }
    
    
}
