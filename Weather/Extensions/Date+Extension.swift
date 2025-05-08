//
//  Date+Extension.swift
//  Weather
//
//  Created by Spencer Dearman on 5/6/25.
//

import Foundation

extension Date {
    func localDate(for timezone: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = timezone
        return dateFormatter.string(from: self)
    }
    
    func localTime(for timezone: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = timezone
        return dateFormatter.string(from: self)
    }
    
    func localWeekDay(for timezone: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.timeZone = timezone
        return dateFormatter.string(from: self)
    }
}
