//
//  MonthCCell.swift
//  Geunal
//
//  Created by SolChan Ahn on 14/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift


class MonthCCell: UICollectionViewCell, StoryboardView {
    
    @IBOutlet weak var monthLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func bind(reactor: MonthCCellReactor) {
        
        reactor.state.map {$0.month}
            .map {String($0)}
            .bind(to: monthLabel.rx.text)
            .disposed(by: self.disposeBag)
        
    }
    
}
