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
    init(reactor: CalendarReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Rx
    var disposeBag = DisposeBag()
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<CalendarSection>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, sectionItem in
            guard let self = self else { return UICollectionViewCell() }
            
            let cell = CalendarCCell()
            
            return cell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: CalendarReactor) {
        self.calendarCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    
}
