//
//  CalendarCCell.swift
//  Geunal
//
//  Created by SolChan Ahn on 01/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class CalendarCCell: UICollectionViewCell, View {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func bind(reactor: CalendarCCellReactor) {
        
    }
}
