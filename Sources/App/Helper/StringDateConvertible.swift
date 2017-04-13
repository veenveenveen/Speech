//
//  StringDateConvertible.swift
//  Speech
//
//  Created by viwii on 2017/4/3.
//
//

import Foundation

/*
func string() {
    let string = "2017-01-27T18:36:36Z"
    
    let dateFormatter = DateFormatter()
    
    let tempLocale = dateFormatter.locale // save locale temporarily
    
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    let date = dateFormatter.date(from: string)!
    
    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
    dateFormatter.locale = tempLocale // reset the locale
    
    let dateString = dateFormatter.string(from: date)
    
    print("EXACT_DATE : \(dateString)", date)
}
*/


enum DateConvertError: Error {
    case invalidFormat
}

extension String {
    
    /// String format: yyyy-MM-dd HH:mm:ss
    ///
    func date() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
    
    func dateTimeIntervalFrom1970() throws -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: self) else {
            throw DateConvertError.invalidFormat
        }
        return date.timeIntervalSince1970
    }
}
