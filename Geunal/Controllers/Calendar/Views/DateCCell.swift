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
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func bind(reactor: DateCCellReactor) {
        
        reactor.state.map {$0.date}
            .map {$0.getDate()}
            .bind(to: dateLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map {$0.date}
            .map {$0.getDate()}
            .bind(to: dateLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
}
