//
//  AuthViewModel.swift
//  crypto
//
//  Created by Kushal Patel on 7/17/24.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    @Published var UserSession: FirebaseAuth.User?
    @Published var currentUser: dbUser?
    private let service = UserService()
    
    init () {
        self.UserSession = Auth.auth().currentUser
        self.fetchUser()
        
    }
    
    func login (withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else {return}
            self.UserSession = user
            print("DEBUG: logged in with \(email)")

            self.fetchUser()
        }
    
    }
    
    func register (withEmail email: String, password: String, username: String){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else {return}
            self.UserSession = user
            
            print("DEBUG: registered user succesfully")
            
            let portfolio: [PortfolioItem] = []
        
            

            let data: [String: Any] = ["email": email,
                                       "username": username.lowercased(),
                                       "portfolio": portfolio.map { ["name": $0.name, "value": $0.value] }]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { _ in
                    print("DEBUG: Uploaded user data")
                }
        }
        self.fetchUser()
    }
    
    func signOut () {
        UserSession = nil
        try? Auth.auth().signOut()
    }
    
    func fetchUser () {
        guard let uid = self.UserSession?.uid else {return}
        service.fetchUser(withUid: uid) { dbUser in
            self.currentUser = dbUser
        }
    }
    func addToPortfolio(coin: String, value: Double) {
            guard let currentUser = currentUser else { return }
            
            var updatedPortfolio = currentUser.portfolio
            
            if let index = updatedPortfolio.firstIndex(where: { $0.name == coin }) {
                updatedPortfolio[index].value += value
            } else {
                updatedPortfolio.append(PortfolioItem(name: coin, value: value))
            }
            
            let portfolioData = updatedPortfolio.map { ["name": $0.name, "value": $0.value] }
            
            Firestore.firestore().collection("users")
                .document(currentUser.id ?? "")
                .updateData(["portfolio": portfolioData]) { error in
                    if let error = error {
                        print("Error updating portfolio: \(error.localizedDescription)")
                    } else {
                        print("Portfolio updated successfully")
                        // Optionally, update local currentUser with updated portfolio
                        self.currentUser?.portfolio = updatedPortfolio
                    }
                }
        }
        
        func removeFromPortfolio(coin: String, value: Double) {
            guard let currentUser = currentUser else { return }
            
            var updatedPortfolio = currentUser.portfolio
            
            if let index = updatedPortfolio.firstIndex(where: { $0.name == coin }) {
                updatedPortfolio[index].value -= value
                
                if updatedPortfolio[index].value <= 0 {
                    updatedPortfolio.remove(at: index)
                }
                
                let portfolioData = updatedPortfolio.map { ["name": $0.name, "value": $0.value] }
                
                Firestore.firestore().collection("users")
                    .document(currentUser.id ?? "")
                    .updateData(["portfolio": portfolioData]) { error in
                        if let error = error {
                            print("Error updating portfolio: \(error.localizedDescription)")
                        } else {
                            print("Portfolio updated successfully")
                            // Optionally, update local currentUser with updated portfolio
                            self.currentUser?.portfolio = updatedPortfolio
                        }
                    }
            }
        }
    }
