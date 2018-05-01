//
//  ABMonth.swift
//  ABCalendar
//
//  Created by AB on 14/04/18.
//  Copyright © 2018 AB. All rights reserved.
//

import Foundation

public enum ABDayState: Int {
    case out, selected, available, Event, Holiday
}


class ABMonth {
    
    var weeks = [ABWeek]()
    let lastMonthDay: Date
    let date: Date
    
    var numberOfWeeks: Int {
        return weeks.count
    }
    
    private let calendar: Calendar
    
    func dateInThisMonth(_ date: Date) -> Bool {
        return calendar.isDate(date, equalTo: self.date, toGranularity: .month)
    }
    
    var selectedDays = [ABDay]() {
        didSet {
            self.weeks = generateWeeks()
        }
    }
    
    init(month: Date, calendar: Calendar) {
        self.date = month
        self.calendar = calendar
        self.lastMonthDay = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: date)!
    }
    
    private func generateWeeks() -> [ABWeek] {
        var weeks = [ABWeek]()
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        var weekDay = calendar.date(from: components)!
        
        repeat {
            var days = [ABDay]()
            for index in 0...6 {
                guard let dayInWeek = calendar.date(byAdding: .day, value: +index, to: weekDay) else { continue }
                let day = getDate(for: dayInWeek)
                days.append(day)
            }
            let week = ABWeek(days: days, date: weekDay)
            weeks.append(week)
            weekDay = calendar.date(byAdding: .weekOfYear, value: 1, to: weekDay)!
        } while calendar.isDate(weekDay, equalTo: lastMonthDay, toGranularity: .month)

        return weeks
    }
    
    private func getDate(for date: Date) -> ABDay {
        if !calendar.isDate(date, equalTo: lastMonthDay, toGranularity: .month){
            return ABDay(date: date, state: .out)
        } else if selectedDays.contains(where: { calendar.isDate($0.date , inSameDayAs: date) }) {
            if let index = selectedDays.index(where: { calendar.isDate($0.date , inSameDayAs: date) }) {
                let value = selectedDays[index]
                return value
            }
            return ABDay(date: date, state: .selected)
            
        } else {
            return ABDay(date: date, state: .available)
        }
    }
}


class ABWeek {
    var days: [ABDay]
    let date: Date
    init(days: [ABDay], date: Date) {
        self.days = days
        self.date = date
    }
}

class ABDay {
    let date: Date
    var state: ABDayState = .available
    var day: String? = nil
    
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    init(date: Date, state: ABDayState) {
        self.date = date
        self.state = state
        self.day = ABDay.dayFormatter.string(from: self.date)
    }
    
    
}
