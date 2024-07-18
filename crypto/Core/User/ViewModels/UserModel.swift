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

    
    init(viewModel: AuthViewModel) {
        // Initialize portfolio with an empty array initially
        self.portfolio = []
        
        if let currentUser = viewModel.currentUser {
            // If the current user is available, initialize the portfolio
            self.portfolio = currentUser.portfolio
        } else {
            // If the current user is not available, set a delay to fetch the portfolio later
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.portfolio = viewModel.currentUser?.portfolio ?? []
            }
        }
    }
    
    // Method to add a new item to the portfolio
    func addToPortfolio(item: String, value: Double) {
        if let index = portfolio.firstIndex(where: { $0.name == item }) {
            portfolio[index].value += value
        } else {
            let newItem = PortfolioItem(name: item, value: value)
            portfolio.append(newItem)
        }
    }
    
    // Method to remove an item from the portfolio
    func removeFromPortfolio(itemName: String, value: Double) {
        if let index = portfolio.firstIndex(where: { $0.name == itemName }) {
            portfolio[index].value -= value
            if portfolio[index].value <= 0 {
                portfolio.remove(at: index)
            }
        }
    }
    
    
}
