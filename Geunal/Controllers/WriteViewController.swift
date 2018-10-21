//
//  InputViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 21/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit
import VisualEffectView
protocol WriteViewControllerDelegate {
    func didCancelButton()
    func didWriteButton()
    func didUpdateButton()
}

class WriteViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var inputBackView: UIView!
    
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    
    let placeholderText = "나는 글을 여기에 쓰겠다."
    
    var sendFlag: Bool! {
        didSet {
            switch sendFlag {
            case true:
                writeButton.titleLabel?.text = "기억"
            case false:
                writeButton.titleLabel?.text = "수정"
            default:
                return
            }
        }
    }
    
    @IBAction func writeButton(_ sender: Any) {
        hideWriteView {
            switch self.sendFlag {
            case true:
                self.delegate?.didWriteButton()
            case false:
                self.delegate?.didUpdateButton()
            default:
                return
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        hideWriteView {
            self.delegate?.didCancelButton()
        }
    }
    
    private var visualEffectView: VisualEffectView!
    
    var delegate: WriteViewControllerDelegate?
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
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
}

extension WriteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
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
            self.writeButton((Any).self)
        }
    }
}


