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

class CalendarViewController: UIViewController, StoryboardView {
    
    // MARK: Properties
    fileprivate struct Metric {
        static let searchCellWidth = 50
        static let searchCellHeight = 25
    }
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    @IBOutlet weak var yearCollectionView: UICollectionView!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: Initializing
    
    // MARK: Rx
    var disposeBag = DisposeBag()
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<CalendarSection>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, sectionItem in
            guard let self = self else { return UICollectionViewCell() }
            
            guard let calendarCCell =
                self.calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCCell",
                                                                for: indexPath)
                    as? CalendarCCell else { return UICollectionViewCell() }
            
            calendarCCell.reactor = sectionItem
            
            return calendarCCell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAttributes()
    }
    
    func setAttributes() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
    }
    
    func bind(reactor: CalendarReactor) {
        
        self.rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:))).asObservable()
            .map {_ in Reactor.Action.start}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.calendarSection }
            .bind(to: self.calendarCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map {$0.isLoaded}
            .filter { $0 }
            .bind { _ in
                let indexPath = reactor.currentState.indexPathOfCurrentTime
                self.calendarCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
            }
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.yearList }
            .bind(to: self.yearCollectionView.rx.items(cellIdentifier: "YearCCell", cellType: YearCCell.self)) { indexPath, repo, cell in
                cell.reactor = YearCCellReactor(year: repo)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.monthList }
            .bind(to: self.monthCollectionView.rx.items(cellIdentifier: "MonthCCell", cellType: MonthCCell.self)) { indexPath, repo, cell in
                cell.reactor = MonthCCellReactor(month: repo)
            }
            .disposed(by: disposeBag)
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case calendarCollectionView:
            return CGSize(width: self.calendarCollectionView.frame.width,
                          height: self.calendarCollectionView.frame.height)
        case yearCollectionView, monthCollectionView:
            return CGSize(width: Metric.searchCellWidth, height: Metric.searchCellHeight)
        default:
            return .zero
        }
    }
}
