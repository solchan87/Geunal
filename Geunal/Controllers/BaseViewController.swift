//
//  BaseViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 28/01/2019.
//  Copyright © 2019 SolChan Ahn. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    // MARK: Properties
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    var dismissAction = {()->()in}
    
    // MARK: Rx
    var disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    deinit{
        print("DEINIT: ", className)
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissAction = {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                if let navigationVC = self.navigationController{
                    navigationVC.popViewController(animated: true)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
