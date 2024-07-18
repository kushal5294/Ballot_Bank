//
//  Double.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

import Foundation

extension Double{
    private var currencyFormatter: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    private var numberFormatter: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func toCurrency () -> String{
        return currencyFormatter.string(for: self) ?? "$0.00"
    }
    func toPerc () -> String {
        guard let numberAsString = numberFormatter.string(for: self) else {return ""}
        if self > 0 {
            return "+" + numberAsString + "%"
        }
        return numberAsString + "%"
    }
    func toCoin () -> String {
        guard let numberAsString = numberFormatter.string(for: self) else {return ""}
        return numberAsString
    }
    
}
