//
//  DayTableViewCell.swift
//  Geunal
//
//  Created by SolChan Ahn on 19/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var filterView: UIView!
    
    var animationTime: CGFloat = 0.8 {
        didSet{
            setAnimation(time: animationTime)
        }
    }
    
    var message: String = "" {
        didSet{
            
        }
    }
    
    var animator: UIViewPropertyAnimator?
    
    override func awakeFromNib() {
        let temp = CALayer()
        temp.frame = self.bounds
        super.awakeFromNib()
        if let blurFilter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputRadiusKey: 2]){
            
            temp.backgroundFilters = [blurFilter]
            
            
            
//            messageLabel.layer.backgroundFilters = [blurFilter]
//            self.filterView.layer.backgroundFilters = [blurFilter]
            
//            self.layer.backgroundFilters = [blurFilter]
//            foreground.backgroundFilters = [blurFilter]
        }
        messageLabel.layer.addSublayer(temp)

        
    }
    
    func setBlurEffect(message: String) {
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setAnimation(time: CGFloat) {
        animator?.fractionComplete = CGFloat(time)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
