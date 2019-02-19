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
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthCollectionView: UICollectionView!
    @IBOutlet weak var backView: UIView!
    
    let calendarService = CalendarService()
    
    // MARK: Rx
    var disposeBag = DisposeBag()
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<DateSection>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, sectionItem in
            guard let self = self else { return UICollectionViewCell() }
            
            let dateCCell = self.monthCollectionView.dequeueReusableCell(withReuseIdentifier: "DateCCell", for: indexPath) as! DateCCell
            
            dateCCell.reactor = sectionItem
            
            return dateCCell
    })
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setAttributes()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func setAttributes() {
        self.backView.layer.cornerRadius = 5
    }
    
    func bind(reactor: CalendarCCellReactor) {
        
        self.rx.methodInvoked(#selector(UICollectionViewCell.layoutSubviews)).asObservable()
            .map {_ in Reactor.Action.getDateList() }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.monthSection }
            .bind(to: self.monthCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map {$0.month}
            .bind { [weak self] month in
                guard let self = self else {return}
                self.monthLabel.text = self.calendarService.getString(of: month)
            }
            .disposed(by: self.disposeBag)
    }
    
}

extension CalendarCCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.monthCollectionView.frame.width - 1) / 7,
                      height: self.monthCollectionView.frame.height / 6)
    }
}
