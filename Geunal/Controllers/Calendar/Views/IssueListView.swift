//
//  IssueListView.swift
//  Geunal
//
//  Created by SolChan Ahn on 15/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class IssueListView: UIView, StoryboardView {

    var disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 8
    }
    
    func bind(reactor: IssueListViewReactor) {
        
    }

}
