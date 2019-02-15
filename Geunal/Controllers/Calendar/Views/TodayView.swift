//
//  TodayView.swift
//  Geunal
//
//  Created by SolChan Ahn on 15/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class TodayView: UIView, StoryboardView{
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayOfWeakLabel: UILabel!

    var disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 8
    }
    
    func bind(reactor: TodayViewReactor) {
        reactor.state.map {$0.currentDate}
            .bind { [weak self] date in
                guard let self = self else { return }
                self.monthLabel.text = String(date.getMonth())
                self.dateLabel.text = String(date.getDate())
                
                var weakOfDay = ""
                switch date.getWeekDay() {
                case 1:
                    weakOfDay = "일요일"
                case 2:
                    weakOfDay = "월요일"
                case 3:
                    weakOfDay = "화요일"
                case 4:
                    weakOfDay = "수요일"
                case 5:
                    weakOfDay = "목요일"
                case 6:
                    weakOfDay = "금요일"
                case 7:
                    weakOfDay = "토요일"
                default: break
                }
                
                self.dayOfWeakLabel.text = weakOfDay
            }
            .disposed(by: self.disposeBag)
    }

}
