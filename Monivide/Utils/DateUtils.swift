//
//  DateUtils.swift
//  WxForecast
//
//  Created by Chung Nguyen on 6/18/22.
//

import Foundation

protocol DateUtils {
    func getDateString(_ date: Date, _ format: String) -> String
    func parseDate(_ string: String, _ format: String) -> Date?
}

struct DateUtilsImpl: DateUtils {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    let customDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    let calendar = Calendar.current
    
    // Except ToDay and Yesterday...
    func getDateOfWeekDisplay(date: String) -> String {
        let todayDate = Date()
        guard let yesterdayDate = calendar.date(byAdding: .day, value: -1, to: todayDate) else {
            assertionFailure()
            return ""
        }
        let todayDisplay = dateFormatter.string(from: todayDate)
        let yesterdayDisplay = dateFormatter.string(from: yesterdayDate)
        
        switch date {
        case todayDisplay:
            return "Today"
        case yesterdayDisplay:
            return "Yesterday"
        default:
            guard let curDate = dateFormatter.date(from: date) else {
                assertionFailure()
                return ""
            }
            
            let dateOfWeek = calendar.component(.weekday, from: curDate) - 1
            return dateFormatter.weekdaySymbols[dateOfWeek]
        }
    }
    
    func getDateDiff(_ date: Date, _ diff: Int) -> String {
        guard let newDate = calendar.date(byAdding: .day, value: diff, to: date) else {
            assertionFailure()
            return ""
        }
        
        return dateFormatter.string(from: newDate)
    }
    
    func getDateFrom(_ date: Date, _ diff: Int) -> Date {
        guard let newDate = calendar.date(byAdding: .day, value: diff, to: date) else {
            assertionFailure()
            return Date()
        }
        
        return newDate
    }
    
    func getDateString(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func getDateString(_ date: Date, _ format: String) -> String {
        customDateFormatter.dateFormat = format
        return customDateFormatter.string(from: date)
    }
    
    func parseDate(_ string: String, _ format: String) -> Date? {
        customDateFormatter.dateFormat = format
        return customDateFormatter.date(from: string)
    }
    
    func getDateComponent(_ component: Calendar.Component, _ date: Date) -> Int {
        return calendar.component(component, from: date)
    }
}
