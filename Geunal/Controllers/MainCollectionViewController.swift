//
//  MainCollectionViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 12/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

/// MainViewController 내의 CollectionView 관리 클래스
class MainCollectionViewController: UICollectionViewController {
    
    var viewModel: MainCollectionViewModel = MainCollectionViewModelFrom(currentTimeModel: CurrentTimeModel()) {
        didSet {
            moveCalendarPage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moveCalendarPage()
    }
    
    fileprivate func moveCalendarPage(){
        if !isViewLoaded {
            return
        }
        
        self.collectionViewLayout.collectionView!.scrollToItem(at: viewModel.getIndexPath(), at: .centeredHorizontally, animated: false)
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.calendarYearRange.count ?? 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 각 해에 해당하는 월 수 : 12
        return viewModel.calendarMonthRange.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        calendarCell.yearTitleLabel.text = String(viewModel.calendarMonthRange[indexPath.row])
        return calendarCell
    }
    
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = self.view.frame.width
        let height: CGFloat = self.view.frame.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

