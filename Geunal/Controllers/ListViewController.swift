//
//  ListViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 23/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {
    
    let calendarService = CalendarService()
    
    var currentIndex: Int?
    
    @IBOutlet weak var messageListTableView: UITableView!
    
    @IBAction func dismissButton(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    let realm = try! Realm()
    
    var dayMessageList: Results<DayMessage>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayMessageList = realm.objects(DayMessage.self).sorted(byKeyPath: "timeNum", ascending: true)
        
        let penGesture = UIPanGestureRecognizer(target: self, action: #selector(self.penGestureRecognized(penGesture:)))
        penGesture.delegate = self
        
        self.messageListTableView.addGestureRecognizer(penGesture)
        
        let currentTime = calendarService.getCurrentTime()
        
        let currentTimeToInt: Int = (currentTime.year * 10000) + (currentTime.month * 100) + (currentTime.date)
        
        // 목록 보기 시 현재에 해당되는 데이터가 있을 때 그 위치로 이동해주는 구문
        if let nextMessage = realm.objects(DayMessage.self).filter("timeNum > \(currentTimeToInt)").sorted(byKeyPath: "timeNum", ascending: true).first {
            if nextMessage.messages.count != 0 {
                let index = dayMessageList.index(of: nextMessage)
                currentIndex = index
            }
        }
        
        if let nextMessage = realm.objects(DayMessage.self).filter("timeNum <= \(currentTimeToInt)").sorted(byKeyPath: "timeNum", ascending: false).first {
            // 버그 픽스 - messages의 count가 0개로 잡힐때, indexpath를 찾을 수 없던 오류 수정
            if nextMessage.messages.count != 0 {
                let index = dayMessageList.index(of: nextMessage)
                currentIndex = index
            }
        }
        if let currentIndex = currentIndex {
            messageListTableView.scrollToRow(at: IndexPath(row: 0, section: currentIndex), at: UITableView.ScrollPosition.middle, animated: false)
        }
        
    }
    
    @objc func penGestureRecognized(penGesture: UIPanGestureRecognizer) {
        
        let state = penGesture.state
        
        let location = penGesture.location(in: self.messageListTableView)
        guard let indexPath = self.messageListTableView.indexPathForRow(at: location) else { return }
        
        guard let cell = self.messageListTableView.cellForRow(at: indexPath) as? ListTableViewCell else { return }
        
        let point = penGesture.translation(in: cell).x
        cell.showMessageLabel(point: point.magnitude)
        
        if state == .ended {
            cell.hideMessageLabel()
        }
    }
    
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.gray
        header.textLabel?.font = UIFont(name: "SunBatang-Light", size: 17.0)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dayMessage = dayMessageList[section]
        if dayMessage.messages.count == 0 {
            return 1
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dayMessageList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayMessageList[section].messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageListTableView.dequeueReusableCell(withIdentifier: "ListTableViewCell") as! ListTableViewCell
        cell.message = dayMessageList[indexPath.section].messages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dayMessage = dayMessageList[section]
        
        if dayMessage.messages.count == 0 {
            return ""
        }
        return "\(dayMessage.year)년 \(dayMessage.month)월 \(dayMessage.date)일의 기억"
    }
    
}

extension ListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
