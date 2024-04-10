//
//  Date+Extensions.swift
//  Expense Tracker
//
//  Created by Frank Chen on 2024-04-01.
//

import Foundation

extension Date {
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
    
    var endOfMonth: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .init(month: 1, minute: -1), to: self.startOfMonth) ?? self
    }
    
    // Define start and end date components for the year 2024
    var startDateComponents: DateComponents {
        var startDateComponents = DateComponents()
        startDateComponents.year = 2024
        startDateComponents.month = 1 // January
        startDateComponents.day = 1
        return startDateComponents
    }

    var endDateComponents: DateComponents {
        var endDateComponents = DateComponents()
        endDateComponents.year = 2024
        endDateComponents.month = 12 // December
        endDateComponents.day = 31
        return endDateComponents
    }
    
    var randomDate: Date {
        let startDate = Calendar.current.date(from: startDateComponents)!
        let endDate = Calendar.current.date(from: endDateComponents)!
        return Date(timeIntervalSinceReferenceDate: TimeInterval.random(in: startDate.timeIntervalSinceReferenceDate...endDate.timeIntervalSinceReferenceDate))
    }
}
