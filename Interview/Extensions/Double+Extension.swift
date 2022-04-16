//
//  Double+Extension.swift
//  Interview
//
//  Created by Emre AYDIN on 16.04.2022.
//

import Foundation

extension Double {

    /// Formatted price from double to string
    var formatAsPrice: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.currencySymbol = ""
        numberFormatter.currencyGroupingSeparator = ","
        numberFormatter.currencyDecimalSeparator = "."
        numberFormatter.numberStyle = .currency
        return numberFormatter.string(from: NSNumber(value: self))!
    }

}
