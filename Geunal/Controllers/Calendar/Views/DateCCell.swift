//
//  DateCCell.swift
//  Geunal
//
//  Created by SolChan Ahn on 06/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift


class DateCCell: UICollectionViewCell, StoryboardView {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var firstIssue: UIView!
    @IBOutlet weak var secondIssue: UIView!
    @IBOutlet weak var thirdIssue: UIView!
    
    var disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setAttribute()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func setAttribute() {
        self.firstIssue.layer.cornerRadius = self.firstIssue.frame.width / 2
        self.secondIssue.layer.cornerRadius = self.secondIssue.frame.width / 2
        self.thirdIssue.layer.cornerRadius = self.thirdIssue.frame.width / 2
    }
    
    func bind(reactor: DateCCellReactor) {
        
        reactor.state.map {$0.date}
            .map {String($0.getDate())}
            .bind(to: dateLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map {$0.date}
            .map {$0.getWeekDay()}
            .bind { [weak self] weekDay in
                guard let self = self else { return }
                switch weekDay {
                case 1:
                    self.dateLabel.textColor = UIColor(named: "SunColor")
                default:
                    self.dateLabel.textColor = UIColor(named: "NormalColor")
                }
            }
            .disposed(by: self.disposeBag)
        
        reactor.state.map {$0.isIncludedInMonth}
            .bind { [weak self] isIncludedInMonth in
                guard let self = self else { return }
                if isIncludedInMonth {
                    self.alpha = 1.0
                }else {
                    self.alpha = 0.2
                }
            }
            .disposed(by: self.disposeBag)
        
        reactor.state.map {$0.issueCount}
            .bind { [weak self] count in
                guard let self = self else { return }
                switch count {
                case 0:
                    self.firstIssue.isHidden = true
                    self.secondIssue.isHidden = true
                    self.thirdIssue.isHidden = true
                case 1:
                    self.firstIssue.isHidden = true
                    self.secondIssue.isHidden = false
                    self.thirdIssue.isHidden = false
                case 2:
                    self.firstIssue.isHidden = true
                    self.secondIssue.isHidden = true
                    self.thirdIssue.isHidden = false
                default:
                    self.firstIssue.isHidden = true
                    self.secondIssue.isHidden = true
                    self.thirdIssue.isHidden = true
                }
            }
            .disposed(by: self.disposeBag)
        
        
    }
    
}
