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
import RxDataSources
import RxSwift

class CalendarCCell: UICollectionViewCell, StoryboardView {
    
    // MARK: Properties
    fileprivate struct Metric {
        static let shotTileSectionInsetLeftRight = 10
        static let shotTileSectionItemSpacing = 10
    }
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var daysCollectionView: UICollectionView!
    
    // MARK: Rx
    var disposeBag = DisposeBag()
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<CalendarSection>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, sectionItem in
            guard let self = self else { return UICollectionViewCell() }
            
            let calendarCCell = self.daysCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCCell", for: indexPath) as! CalendarCCell
            
            calendarCCell.reactor = sectionItem
            
            return calendarCCell
    })
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func bind(reactor: CalendarCCellReactor) {
        
    }
}
