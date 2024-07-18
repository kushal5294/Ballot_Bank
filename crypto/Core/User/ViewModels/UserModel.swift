//  UserModel.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

//  UserModel.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

import Foundation
import SwiftUI

struct PortfolioItem: Codable {
    var name: String
    var value: Double
}

class User: ObservableObject {
    @Published var portfolio: [PortfolioItem]
    
    init(port: [PortfolioItem]) {
        self.portfolio = port
    }
    
    func addToPortfolio(item: String, value: Double) {
        if let index = portfolio.firstIndex(where: { $0.name == item }) {
            portfolio[index].value += value
        } else {
            let newItem = PortfolioItem(name: item, value: value)
            portfolio.append(newItem)
        }
    }
    
    func removeFromPortfolio(itemName: String, value: Double) {
        if let index = portfolio.firstIndex(where: { $0.name == itemName }) {
            portfolio[index].value -= value
            if portfolio[index].value <= 0 {
                portfolio.remove(at: index)
            }
        }
    }
}
