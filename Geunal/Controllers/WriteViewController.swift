//
//  InputViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 21/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit
import RealmSwift

protocol WriteViewControllerDelegate {
    func didCancelButton()
    func didWriteButton()
    func didUpdateButton()
}


/// 뷰를 컨테이너에 담아 hidden 관계로 두려 했으나,
/// 공통적으로 사용해야될 필요가 있어, 차후 present 관계로 변경해야됨
class WriteViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var inputBackView: UIView!
    
    @IBOutlet weak var writeButton: UIButton!
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var timeTextLabel: UILabel!
    
    // textview 에 placeholder를 구성하면서 빈칸일때,
    // placeholder 글이 입력되는 것을 방지하기 위한 flag
    var editFlag: Bool = false
    let placeholderText = "기억을 여기에 남기다."
    
    private var visualEffectView: VisualEffectView!
    
    var delegate: WriteViewControllerDelegate?
    
    // flag상태에 따라 기억, 수정 구분
    // storyboard 버그 - 버튼을 누르면 기본 텍스트로 바뀌는 버그가 있다.
    var sendFlag: Bool! {
        didSet {
            switch sendFlag {
            case true:
                writeButton.titleLabel!.text = "기억"
            case false:
                writeButton.titleLabel!.text = "수정"
            default:
                return
            }
        }
    }
    
    var dateData: DateData!{
        didSet {
            timeTextLabel.text = dateToString(dateData: dateData)
        }
    }
    
    // edit 시 메시지 가진 변수
    var message: Message? {
        didSet{
            messageTextView.becomeFirstResponder()
            messageTextView.text = message?.text
        }
    }
    
    
    @IBAction func writeButton(_ sender: Any) {
        //xcode burg - 차후 확인 요망
        if messageTextView.text != "" && editFlag == true {
            hideWriteView {
                switch self.sendFlag {
                case true:
                    self.writeMessage(text: self.messageTextView.text!)
                    self.delegate?.didWriteButton()
                case false:
                    self.updateMessage(text: self.messageTextView.text!)
                    self.delegate?.didUpdateButton()
                default:
                    return
                }
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        hideWriteView {
            self.delegate?.didCancelButton()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlaceholderText()
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        visualEffectView = VisualEffectView(frame: self.view.bounds)
        
        visualEffectView.colorTint = .darkGray
        visualEffectView.colorTintAlpha = 0.6
        visualEffectView.blurRadius = 0
        visualEffectView.scale = 1
        
        backgroundView.addSubview(visualEffectView)
        
        inputBackView.layer.cornerRadius = 10
        inputBackView.alpha = 0.0
        visualEffectView.alpha = 0.0
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func hideKeyboardOnTap(_ selector: Selector) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
        tap.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tap)
    }
    
    private func setPlaceholderText() {
        messageTextView.delegate = self
        messageTextView.text = placeholderText
        messageTextView.textColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // textview에는 place 홀더가 없어서 키보드 상태에 따라 view의 텍스트를 조절해줘야 된다.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // keyboard
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height / 2)
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += (keyboardSize.height / 2)
            }
        }
    }
    
    func showWriteView(){
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.visualEffectView.blurRadius = 4
            self.visualEffectView.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                self.inputBackView.alpha = 1.0
            })
        }
    }
    
    func subDateToInt(dateData: DateData) -> Int{
        let year = dateData.year * 10000
        let month = dateData.month * 100
        let date = dateData.date
        
        let result = year + month + date
        
        return result
    }
    
    // realm 데이터가 있을때와 없을때를 구분해서 만든다.
    private func writeMessage(text: String){
        if let dayMessage = self.realm.objects(DayMessage.self).filter("year = \(self.dateData.year) AND month = \(self.dateData.month) AND date = \(self.dateData.date)").first {
            try! self.realm.write {
                let message = Message()
                message.order = dayMessage.lastOeder + 1
                message.state = "normal"
                message.text = text
                dayMessage.lastOeder += 1
                
                dayMessage.messages.append(message)
            }
        }else {
            let dayMessage = DayMessage()
            dayMessage.timeNum = self.subDateToInt(dateData: dateData)
            dayMessage.year = self.dateData.year
            dayMessage.month = self.dateData.month
            dayMessage.date = self.self.dateData.date
            dayMessage.state = "normal"
            
            let message = Message()
            message.order = 0
            message.state = "normal"
            message.text = text
            
            dayMessage.messages.append(message)
            
            try! self.realm.write {
                self.realm.add(dayMessage)
            }
        }
    }
    
    private func updateMessage(text: String) {
        if let message = message {
            try! self.realm.write {
                message.text = text
            }
        }
    }
    
    private func hideWriteView(completion: @escaping () -> ()){
        view.endEditing(true)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.inputBackView.alpha = 0.0
        }) { (finished) in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.visualEffectView.blurRadius = 0
                self.visualEffectView.alpha = 0.0
            }, completion: { (finished) in
                completion()
                self.setPlaceholderText()
            })
        }
    }
    
    
    // 숫자를 한글로 변환할 때, 더 좋은 방법이 있는지 생각해보기
    private func dateToString(dateData: DateData) -> String {
        
        var monthText: String = ""
        var dayText: String  = ""
        
        switch dateData.month {
        case 1:
            monthText = "일월"
        case 2:
            monthText = "이월"
        case 3:
            monthText = "삼월"
        case 4:
            monthText = "사월"
        case 5:
            monthText = "오월"
        case 6:
            monthText = "유월"
        case 7:
            monthText = "칠월"
        case 8:
            monthText = "팔월"
        case 9:
            monthText = "구월"
        case 10:
            monthText = "시월"
        case 11:
            monthText = "십일월"
        case 12:
            monthText = "십이월"
        default:
            monthText = ""
        }
        
        switch dateData.date / 10 {
        case 1:
            dayText = "십"
        case 2:
            dayText = "이십"
        case 3:
            dayText = "삼십"
        default:
            dayText = ""
        }
        
        switch dateData.date % 10 {
        case 1:
            dayText.append("일일")
        case 2:
            dayText.append("이일")
        case 3:
            dayText.append("삼일")
        case 4:
            dayText.append("사일")
        case 5:
            dayText.append("오일")
        case 6:
            dayText.append("육일")
        case 7:
            dayText.append("칠일")
        case 8:
            dayText.append("팔일")
        case 9:
            dayText.append("구일")
        default:
            dayText.append("일")
        }
        
        return "\(monthText) \(dayText)"
    }
}

extension WriteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            editFlag = true
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.last == "\n" { //Check if last char is newline
            textView.text.removeLast() //Remove newline
            textView.resignFirstResponder() //Dismiss keyboard
            if textView.text != "" {
                self.writeButton((Any).self)
            }
        }
        if textView.text.count == 20 {
            textView.text.removeLast()
        }
    }
}



