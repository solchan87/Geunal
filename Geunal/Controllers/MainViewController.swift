//
//  ViewController.swift
//  Geunal
//
//  Created by SolChan Ahn on 12/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let calendarService = CalendarService()
    
    var mainCollectionView: MainCollectionViewController!
    
    var yearCollectionView: YearCollectionViewController!
    
    var monthCollectionView: MonthCollectionViewController!
    
    let transition = MainAnimators()
    
    //animation transition value
    var mainCellIndexPath: IndexPath!
    
    var calendarCellIndexPath: IndexPath!
    
    
    var firstFlag = true
    
    @IBOutlet weak var mainContainerView: UIView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func searchButton(_ sender: Any) {
        calendarFlag = false
        mainCollectionView.setCalendarView(year: searchYear, month: searchMonth, animated: true)
        setButtonState(flag: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
           self.calendarFlag = true
        })
    }
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var buttonMonthLabel: UILabel!
    @IBOutlet weak var buttonDateLabel: UILabel!
    @IBOutlet weak var buttonWeekLabel: UILabel!
    
    @IBOutlet weak var currentPageButton: UIButton!
    
    @IBAction func currentPageButton(_ sender: Any) {
        
        let currentTime = calendarService.getCurrentTime()
        
        mainCollectionView.setCalendarView(year: currentTime.year, month: currentTime.month, animated: true)
        
        UIView.animate(withDuration: 0.3) {
            self.buttonView.alpha = 0.4
            self.buttonView.alpha = 1
        }
    }
    
    var calendarFlag: Bool = true
    
    var searchYear: Int = 0 {
        didSet{
            if oldValue != searchYear {
                setButtonState(flag: true)
            }
        }
    }
    
    var searchMonth: Int = 0 {
        didSet{
            if oldValue != searchMonth {
                setButtonState(flag: true)
            }
        }
    }
    
    var visibleYear: Int = 0 {
        didSet{
            if calendarFlag {
                yearCollectionView.setSearchYear(year: visibleYear, hideFlag: true)
            }
        }
    }
    
    var visibleMonth: Int = 0 {
        didSet{
            if calendarFlag {
                monthCollectionView.setSearchMonth(month: visibleMonth, hideFlag: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
        
    }
    
    private func setButtonState(flag: Bool) {
        if flag {
            searchButton.isEnabled = true
            searchButton.alpha = 1
        }else {
            searchButton.isEnabled = false
            searchButton.alpha = 0.4
        }
    }
    
    private func setCurrentButtonTime(currentTime: CurrentTime) {
        let dayOfweek = calendarService.getCurrentDayOfWeek(currentTime: currentTime)
        
        switch dayOfweek {
        case 1:
            buttonWeekLabel.text = "일요일"
        case 2:
            buttonWeekLabel.text = "월요일"
        case 3:
            buttonWeekLabel.text = "화요일"
        case 4:
            buttonWeekLabel.text = "수요일"
        case 5:
            buttonWeekLabel.text = "목요일"
        case 6:
            buttonWeekLabel.text = "금요일"
        case 7:
            buttonWeekLabel.text = "토요일"
        default:
            buttonWeekLabel.text = ""
        }
        
        buttonMonthLabel.text = String(currentTime.month)
        buttonDateLabel.text = String(currentTime.date)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if firstFlag {
            let currentTime = calendarService.getCurrentTime()
            
            setCurrentButtonTime(currentTime: currentTime)
            
            mainCollectionView.setCalendarView(year: currentTime.year, month: currentTime.month, animated: false)
            yearCollectionView.setSearchYear(year: currentTime.year, hideFlag: false)
            monthCollectionView.setSearchMonth(month: currentTime.month, hideFlag: false)
            
            searchYear = currentTime.year
            searchMonth = currentTime.month
            
            setButtonState(flag: false)
            
            buttonView.isUserInteractionEnabled = false
            currentPageButton.layer.cornerRadius = 5
            
            firstFlag = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "yearSegue") {
            yearCollectionView = segue.destination as? YearCollectionViewController
            yearCollectionView.delegate = self
        }
        
        if (segue.identifier == "monthSegue") {
            monthCollectionView = segue.destination as? MonthCollectionViewController
            monthCollectionView.delegate = self
        }
        
        if (segue.identifier == "mainSegue") {
            mainCollectionView = segue.destination as? MainCollectionViewController
            mainCollectionView.delegate = self
            
        }
    }
}

extension MainViewController: YearCollectionViewDelegate {
    func didChangeYear(year: Int) {
        self.searchYear = year
    }
}

extension MainViewController: MonthCollectionViewDelegate {
    func didChangeMonth(month: Int) {
        self.searchMonth = month
    }
}

extension MainViewController: MainCollectionViewDelegate {
    func getPresentData(dateData: DateData, calendarCellIndexPath: IndexPath, mainCellIndexPath: IndexPath) {
        
        self.mainCellIndexPath = mainCellIndexPath
        self.calendarCellIndexPath = calendarCellIndexPath
        
        let dayView = storyboard!.instantiateViewController(withIdentifier: "DayViewController") as! DayViewController
        
        dayView.transitioningDelegate = self
        
        present(dayView, animated: true, completion: nil)
        
        dayView.dateData = dateData
    }
    
    func didChangeVisibleYear(year: Int) {
        self.visibleYear = year
    }
    
    func didChangeVisibleMonth(month: Int) {
        self.visibleMonth = month
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.mainCellIndexPath = self.mainCellIndexPath
        transition.calendarCellIndexPath = self.calendarCellIndexPath
        transition.sourceVC = mainCollectionView
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return nil
    }
}
