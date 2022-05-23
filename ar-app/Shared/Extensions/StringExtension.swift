//
//  StringExtension.swift
//  ar-app
//
//  Created by Kyle Gardner on 5/23/22.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[ !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~])[A-Za-z\\d !\"\\\\#$%&'\\(\\)\\*+,\\-\\./:;<=>?@\\[\\]^_`\\{|\\}~]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    func isValidSsn(_ ssn: String) -> Bool {
      let ssnRegext = "^(?!(000|666|9))\\d{3}-(?!00)\\d{2}-(?!0000)\\d{4}$"
      return ssn.range(of: ssnRegext, options: .regularExpression, range: nil, locale: nil) != nil
    }

    var isValidPhoneNumber: Bool {
        digitsOnly.count == 10
    }
    
    var formattedPhoneNumber: String {
        let phoneMask = "(XXX) XXX-XXXX" //US
        let phone = self.stringByTrimmingCountryCode
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for ch in phoneMask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    var stringByTrimmingCountryCode: String {
        guard first == "1" else { return self }
        var trimmed = self
        trimmed.removeFirst()
        return trimmed
    }
    
    var titlecased: String {
        return replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression, range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized
    }
    
    var digitsOnly: String {
        components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}
