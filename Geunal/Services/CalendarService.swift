//
//  CalandarService.swift
//  MyCalendar
//
//  Created by SolChan Ahn on 03/10/2018.
//  Copyright © 2018 SolChan Ahn. All rights reserved.
//

import Foundation

struct MonthModel {
    var year: Int
    var month: Int
    var dateDatas: [Date]
}

struct DateModel {
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
final class CalendarService {
    
    // 음력은 알고리즘으로 짤 수 없기 때문에,
    // 향후 업데이트 될 음력 전환 기능은, 공공api를 Json으로 크롤링 와서 관리 할 예정이다.
    // 시작 년도
    let startYear: Int = 1930
    // 마지막 년도
    let endYear: Int = 2050
    
    func getMonthData(year: Int, month: Int) -> MonthModel{
        
        let monthData = MonthModel(year: year, month: month, dateDatas: getDateDatas(year: year, month: month))
        
        return monthData
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
    func getDateDatas(year: Int, month: Int) -> [Date] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let firstDate = formatter.date(from: "\(year)-\(month)-01") else { return [] }

        guard let startDayOfWeek = firstDate.dayNumberOfWeek() else { return [] }
        guard let endDate = firstDate.endDate() else { return [] }
        guard let lastEndDate = firstDate.lastEndDate() else { return [] }
        
        let restCount = ((startDayOfWeek - 1) + endDate) % 7
        
        var nextMonthCount = 0
        if restCount != 0 {
            nextMonthCount = 7 - restCount + 1
        }
        
        var dateList: [Date] = []
        
        // 이전 월에 해당하는 날짜 리스트 구현
        if startDayOfWeek > 1 {
            let prevMonth = month == 1 ? 12 : (month - 1)
            
            for count in 1..<startDayOfWeek {
                let date = lastEndDate - (startDayOfWeek - (count + 1))
                guard let resultDate = formatter.date(from: "\(year)-\(prevMonth)-\(date)") else { return [] }
                dateList.append(resultDate)
            }
        }
        
        // 현재 월에 해당하는 날짜 리스트 구현
        for date in 1...endDate {
            guard let resultDate = formatter.date(from: "\(year)-\(month)-\(date)") else { return [] }
            dateList.append(resultDate)
        }
        
        // 다음 월에 해당하는 날짜 리스트 구현
        if nextMonthCount > 1 {
            let nextMonth = month == 12 ? 1 : (month + 1)
            
            for date in 1..<nextMonthCount {
                guard let resultDate = formatter.date(from: "\(year)-\(nextMonth)-\(date)") else { return [] }
                dateList.append(resultDate)
            }
        }
        
        return dateList
    }
}
