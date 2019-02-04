//
//  CalendarController.swift
//  Geunal
//
//  Created by SolChan Ahn on 27/01/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxDataSources
import RxSwift

class CalendarViewController: UIViewController, View {
    
    // MARK: Properties
    fileprivate struct Metric {
        static let shotTileSectionInsetLeftRight = 10
        static let shotTileSectionItemSpacing = 10
    }
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    // MARK: Initializing
    
    // MARK: Rx
    var disposeBag = DisposeBag()
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<CalendarSection>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, sectionItem in
            guard let self = self else { return UICollectionViewCell() }
            
            let calendarCCell = self.calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCCell", for: indexPath) as! CalendarCCell
            
            calendarCCell.reactor = sectionItem
            
            return calendarCCell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: CalendarReactor) {
        self.calendarCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.calendarSection }
            .bind(to: self.calendarCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.calendarCollectionView.frame.width,
                      height: self.calendarCollectionView.frame.height)
    }
}
