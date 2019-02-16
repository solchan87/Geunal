//
//  ChangeTypeView.swift
//  Geunal
//
//  Created by SolChan Ahn on 15/02/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class ChangeTypeView: UIView, StoryboardView {

    var disposeBag = DisposeBag()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5
    }
    
    func bind(reactor: ChangeTypeViewReactor) {
        
    }

}
