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
    
    @IBOutlet weak var changeTypeButton: ChangeTypeView!
    @IBOutlet weak var issueListView: IssueListView!
    @IBOutlet weak var todayView: TodayView!
    
    
    // MARK: Initializing
    
    // MARK: Rx
    var disposeBag = DisposeBag()
    
    lazy var calendarDataSource = RxCollectionViewSectionedReloadDataSource<CalendarSection>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, sectionItem in
            guard let self = self else { return UICollectionViewCell() }
            
            guard let calendarCCell =
                self.calendarCollectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCCell",
                                                                for: indexPath)
                    as? CalendarCCell else { return UICollectionViewCell() }
            
            calendarCCell.reactor = sectionItem
            
            return calendarCCell
    })
    
    lazy var yearDataSource = RxCollectionViewSectionedReloadDataSource<YearSection>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, sectionItem in
            guard let self = self else { return UICollectionViewCell() }
            
            guard let yearCCell =
                self.yearCollectionView.dequeueReusableCell(withReuseIdentifier: "YearCCell",
                                                                for: indexPath)
                    as? YearCCell else { return UICollectionViewCell() }
            
            yearCCell.reactor = sectionItem
            
            return yearCCell
    })
    
    lazy var monthDataSource = RxCollectionViewSectionedReloadDataSource<MonthSection>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, sectionItem in
            guard let self = self else { return UICollectionViewCell() }
            
            guard let monthCCell =
                self.monthCollectionView.dequeueReusableCell(withReuseIdentifier: "MonthCCell",
                                                                for: indexPath)
                    as? MonthCCell else { return UICollectionViewCell() }
            
            monthCCell.reactor = sectionItem
            
            return monthCCell
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAttributes()
        
        self.todayView.reactor = TodayViewReactor()
    }
    
    func setAttributes() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
    }
    
    func bind(reactor: CalendarReactor) {
        
        self.rx.methodInvoked(#selector(UIViewController.viewDidAppear(_:))).asObservable()
            .take(1)
            .map {_ in Reactor.Action.start}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.calendarSection }
            .bind(to: self.calendarCollectionView.rx.items(dataSource: calendarDataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.yearSection }
            .bind(to: self.yearCollectionView.rx.items(dataSource: yearDataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.monthSection }
            .bind(to: self.monthCollectionView.rx.items(dataSource: monthDataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map {$0.isLoaded}
            .filter { $0 }
            .bind { _ in
                let indexPath = reactor.currentState.indexPathOfCurrentTime
                self.calendarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                self.monthCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
            .disposed(by: self.disposeBag)
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
