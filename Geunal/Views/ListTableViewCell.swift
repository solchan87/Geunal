//
//  ListTableViewCell.swift
//  Geunal
//
//  Created by SolChan Ahn on 23/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    
    var message: Message! {
        didSet{
            self.messageLabel.text = message.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func showMessageLabel(point: CGFloat) {
        let maxSize = self.frame.width * 0.65
        if point <= maxSize {
            let value = 6 * (point / maxSize)
        }
    }
    
    func hideMessageLabel() {
        UIView.animate(withDuration: 0.5) {
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
