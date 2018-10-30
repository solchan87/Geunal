//
//  ViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 12/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit
import VisualEffectView

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var messageListButton: UIButton!
    @IBOutlet weak var moonChangeButton: UIButton!
    @IBOutlet weak var currentPageButton: UIButton!
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var launchView: UIView!
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var launchImage: UIImageView!
    
    @IBOutlet weak var buttonMonthLabel: UILabel!
    @IBOutlet weak var buttonDateLabel: UILabel!
    @IBOutlet weak var buttonWeekLabel: UILabel!
    
    var viewModel: CurrentViewModel? {
        didSet {
            fillCurrenPageButton()
        }
    }
    
    // 음력 달력 전환 버튼
    @IBAction func moonChangeButton(_ sender: Any) {
        
    }
    
    
    @IBAction func messageListButton(_ sender: Any) {
        
    }
    
    // 달력 월 검색 버튼
    @IBAction func searchButton(_ sender: Any) {
        
    }
    
    // 오늘 날짜에 맞는 달력으로 이동하는 버튼
    @IBAction func currentPageButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLunchAnimation()
        
        styleUI()
        
        fillCurrenPageButton()
    }
    
    fileprivate func startLunchAnimation() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
        let visualEffectView = VisualEffectView(frame: CGRect(x: 0, y: 0, width: 600, height: 1200))
        visualEffectView.scale = 1
        visualEffectView.blurRadius = 10
        launchImage.addSubview(visualEffectView)
        UIView.animate(withDuration: 1.0, animations: {
            visualEffectView.blurRadius = 0
            self.launchImage.alpha = 1.0
        }) { (finished) in
            delay(1.0, closure: {
                self.launchView.removeFromSuperview()
            })
        }
    }
    
    fileprivate func styleUI() {
        buttonView.isUserInteractionEnabled = false
        currentPageButton.layer.cornerRadius = 5
        messageListButton.layer.cornerRadius = 5
        moonChangeButton.layer.cornerRadius = 5
    }
    
    fileprivate func fillCurrenPageButton() {
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.currentMonth.bindAndFire { (data) in
            self.buttonMonthLabel.text = String(data)
        }
        
        viewModel.currentDate.bindAndFire { (data) in
            self.buttonDateLabel.text = String(data)
        }
        
        viewModel.currentDay.bindAndFire { (data) in
            self.buttonWeekLabel.text = String(data)
        }
    }
}

// snapshot 관련 함수
extension UIView {
    var snapshot: UIView? {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImageView(image: image)
    }
    
    var snapshotImage: UIImage? {
        UIGraphicsBeginImageContext(self.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
