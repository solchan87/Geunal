//
//  YearCCell.swift
//  Geunal
//
//  Created by SolChan Ahn on 14/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift


class YearCCell: UICollectionViewCell, StoryboardView {
    
    @IBOutlet weak var yearLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func bind(reactor: YearCCellReactor) {
        
        reactor.state.map {$0.year}
            .map {String($0)}
            .bind(to: yearLabel.rx.text)
            .disposed(by: self.disposeBag)
        
    }
    
}
