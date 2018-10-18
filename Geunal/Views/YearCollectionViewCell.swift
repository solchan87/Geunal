//
//  YearCollectionViewCell.swift
//  Geunal
//
//  Created by SolChan Ahn on 14/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

class YearCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var yearLabel: UILabel!
    
    var yearNum: Int? {
        didSet{
            configureDate()
        }
    }
    
    var cellFadeFlag: Bool? {
        didSet{
            setCellFade(flag: cellFadeFlag!)
        }
    }
    
    private func setCellFade(flag: Bool) {
        if flag {
            self.alpha = 1
            
        }else {
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.alpha = 0
            }, completion: { _ in
            })
        }
    }
    
    private func configureDate(){
        if let yearNum = yearNum {
            yearLabel.text = String(yearNum)
        }
    }
}
