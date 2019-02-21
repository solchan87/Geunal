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
        static let searchCellWidth: CGFloat = 50.0
        static let searchCellHeight: CGFloat = 25.0
    }
    
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    
    @IBOutlet weak var yearCollectionView: UICollectionView!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var changeTypeButton: ChangeTypeView!
    @IBOutlet weak var issueListView: IssueListView!
    @IBOutlet weak var todayView: TodayView!
    
    @IBOutlet var todayViewTapGesture: UITapGestureRecognizer!
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
    
    func setCurrentDatePage(with indexPath: IndexPath, animated: Bool) {
        self.calendarCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        self.yearCollectionView.scrollToItem(at: IndexPath(item: 0, section: indexPath.section), at: .centeredVertically, animated: animated)
        self.monthCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: animated)
    }
    
    // 위아래 여백 생성
    func configureCollectionViewLayoutItemSize() {
        let height: CGFloat = self.yearCollectionView.frame.height
        let inset = (height - Metric.searchCellHeight) / 2
        
        self.yearCollectionView.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        
        self.monthCollectionView.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
        
        guard let yearContentWidth = self.yearCollectionView.collectionViewLayout
            .collectionView?.frame.size.width else { return }
        
        guard let yearContentHeight = self.yearCollectionView.collectionViewLayout
            .collectionView?.frame.size.height else { return }
        
        self.yearCollectionView.contentSize = CGSize(
            width: yearContentWidth - inset * 2,
            height: yearContentHeight)
        
        guard let monthContentWidth = self.monthCollectionView.collectionViewLayout
            .collectionView?.frame.size.width else { return }
        
        guard let monthContentHeight = self.monthCollectionView.collectionViewLayout
            .collectionView?.frame.size.height else { return }
        
        self.monthCollectionView.contentSize = CGSize(
            width: monthContentWidth - inset * 2,
            height: monthContentHeight)
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
                self.configureCollectionViewLayoutItemSize()
                
                let indexPath = reactor.currentState.indexPathOfCurrentTime
                self.setCurrentDatePage(with: indexPath, animated: false)
            }
            .disposed(by: self.disposeBag)
        
        self.todayViewTapGesture.rx.event
            .bind{_ in
                let indexPath = reactor.currentState.indexPathOfCurrentTime
                self.setCurrentDatePage(with: indexPath, animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.yearCollectionView.rx.contentOffset
            .bind {offset in
                var visibleRect = CGRect()
                
                visibleRect.origin = self.yearCollectionView.contentOffset
                visibleRect.size = self.yearCollectionView.bounds.size
                
                let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                
                guard let indexPath = self.yearCollectionView.indexPathForItem(at: visiblePoint) else { return }
                
                print(indexPath)
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
