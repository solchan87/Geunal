//
//  DayTableViewCell.swift
//  Geunal
//
//  Created by SolChan Ahn on 19/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

protocol DayTableViewCellDelegate {
    func pushUpdateButton(message: Message)
    func pushDeleteButton(message: Message)
}

class DayTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageBackView: UIView!
    
    @IBOutlet weak var buttonBackView: UIView!
    
    var visualEffectView: VisualEffectView!
    
    var delegate: DayTableViewCellDelegate?
    
    var message: Message! {
        didSet{
            self.messageLabel.text = message.text
            visualEffectView.blurRadius = 6
        }
    }
    
    var buttonViewFlag: Bool = false {
        didSet {
            if buttonViewFlag {
                showButtonView()
            }else {
                hideButtonView()
            }
        }
    }
    
    // 버튼 뷰의 버튼에 해당되는 delegate가 있다.
    @IBAction func updateButton(_ sender: Any) {
        delegate?.pushUpdateButton(message: self.message)
        buttonViewFlag = false
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        delegate?.pushDeleteButton(message: self.message)
        buttonViewFlag = false
    }
    @IBAction func cancelButton(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.buttonBackView.alpha = 0.0
        }) { (finished) in
            self.buttonViewFlag = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        visualEffectView = VisualEffectView(frame: self.bounds)
        visualEffectView.scale = 1
        messageBackView.addSubview(visualEffectView)
    }
    
    func showMessageLabel(point: CGFloat) {
        let maxSize = self.frame.width * 0.65
        if point <= maxSize {
            let value = 6 * (point / maxSize)
            visualEffectView.blurRadius = 6 - value
        }
    }
    
    func hideMessageLabel() {
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.blurRadius = 6
        }
    }
    
    func showButtonView() {
        buttonBackView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.buttonBackView.alpha = 1.0
        }
    }
    
    func hideButtonView() {
        buttonBackView.isHidden = true
        self.buttonBackView.alpha = 0.0
    }
    // 중요 - 차후 cell selected 를 long Press로 바꿔야 된다!!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
