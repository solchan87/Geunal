//
//  CalandarService.swift
//  MyCalendar
//
//  Created by SolChan Ahn on 03/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import Foundation

enum StringOf {
    static let sunday = "일요일"
    static let monday = "월요일"
    static let tuesday = "화요일"
    static let wednesday = "수요일"
    static let thursday = "목요일"
    static let friday = "금요일"
    static let saturday = "토요일"
}

struct MonthData {
    var year: Int
    var month: Int
    var dateDatas: [DateData]
}

struct DateData {
    var today: Bool
    var year: Int
    var month: Int
    var date: Int
    var dayOfWeek: Int
    var dateType: Bool
}

struct CurrentTime {
    var year: Int
    var month: Int
    var date: Int
    var hour: Int
    var min: Int
    var week: Int?
}

// 달력에 대한 정보를 반환하는 클래스
class CalendarService {
    
    // 음력은 알고리즘으로 짤 수 없기 때문에,
    // 향후 업데이트 될 음력 전환 기능은, 공공api를 Json으로 크롤링 와서 관리 할 예정이다.
    // 시작 년도
    let startYear: Int = 1930
    // 마지막 년도
    let endYear: Int = 2050
    
    func getMonthData(year: Int, month: Int) -> MonthData{
        
        let monthData = MonthData(year: year, month: month, dateDatas: getDateDatas(year: year, month: month))
        
        return monthData
    }
    
    // 각 월의 마지막 일을 반환
    private func getLastDate(year: Int, month: Int) -> Int{
        switch month {
        case 1, 3, 5, 7, 8, 10, 12:
            return 31
        case 4, 6, 9, 11:
            return 30
        case 2:
            return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0) ? 29 : 28
        default:
            return 0
        }
    }
    
    // 해당 월 1일에 대한 요일 반환 함수 일요일: 1, 토요일: 7
    func getDayOfWeek(year: Int, month: Int) -> Int {
        var dateToString: String = ""
        if month < 10 {
            dateToString = "\(year)0\(month)01"
        }else {
            dateToString = "\(year)\(month)01"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        let firstDate = formatter.date(from: dateToString)
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: firstDate!)
        
        return weekDay
    }
    
    // 오늘 요일 반환 함수 일요일: 1, 토요일: 7
    func getCurrentDayOfWeek(currentTime: CurrentTime) -> Int {
        let tDate = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyyMMdd"
        let dateToString = formatter.string(from: tDate)
        
        let firstDate = formatter.date(from: dateToString)
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: firstDate!)
        
        return weekDay
    }
    
    //현재 시간 반환
    func getCurrentTime() -> CurrentTime{
        let tDate = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd.hh.mm"
        let result = formatter.string(from: tDate)
        
        let time = result.components(separatedBy: ".")
        
        let year: Int = Int(time[0]) ?? 0
        let month: Int = Int(time[1]) ?? 0
        let date: Int = Int(time[2]) ?? 0
        let hour: Int = Int(time[3]) ?? 0
        let min: Int = Int(time[4]) ?? 0
        
        let currentTime = CurrentTime(year: year, month: month, date: date, hour: hour, min: min, week: nil)
        
        return currentTime
    }
    
    // 해당 월에 대한 일, 요일을 리스트로 반환하는 함수
    func getDateDatas(year: Int, month: Int) -> [DateData] {
        let cDate = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy"
        let currentYear = Int(formatter.string(from: cDate))!
        formatter.dateFormat = "MM"
        let currentMonth = Int(formatter.string(from: cDate))!
        formatter.dateFormat = "dd"
        let currentDate = Int(formatter.string(from: cDate))!
        
        var totalCount = 1
        var weekCount = 1
        var dateCount = 0
        
        var dateDatas:[DateData] = []
        
        let lastDate = getLastDate(year: year, month: month)
        let dayOfWeek = getDayOfWeek(year: year, month: month)
        
        // 해당 월에 오늘이 포함돼 있으면, today를 true로 준다.
        for _ in 1..<(lastDate + dayOfWeek) {
            if totalCount < dayOfWeek {
                let dateData = DateData(today: false, year: year, month: month, date: dateCount, dayOfWeek: weekCount, dateType: false)
                dateDatas.append(dateData)
            }else {
                dateCount += 1
                var dateData = DateData(today: false, year: year, month: month, date: dateCount, dayOfWeek: weekCount, dateType: true)
                
                if currentYear == year && currentMonth == month && currentDate == dateCount {
                    dateData.today = true
                }
                dateDatas.append(dateData)
            }
            totalCount += 1
            if weekCount == 7 {
                weekCount = 1
            }else {
                weekCount += 1
            }
            
        }
        return dateDatas
    }
}

public func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
