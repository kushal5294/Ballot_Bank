//  Profile.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

import SwiftUI
import Kingfisher
import Charts

struct Profile: View {

    @StateObject var homeViewModel = HomeViewModel()
    @State private var coinPortfolio: [(coin: Coin, value: Double)] = []
    @State private var wallet: Double = 0.0
    @State private var showBuyModal = false
    @State private var coin = ""
    @State private var amount = ""
    @State private var showSellModal = false
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var user: User
        
    init(viewModel: AuthViewModel) {
        _user = StateObject(wrappedValue: User(viewModel: viewModel))
    }


    var body: some View {
        if let usr = viewModel.UserSession {
            NavigationView {
                if homeViewModel.coins.isEmpty {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(3)
                } else {
                    VStack {
                        Text("My Portfolio")
                            .font(.title)
                            .padding(.top)
                            .fontWeight(.bold)
                        Chart {
                            ForEach(coinPortfolio, id: \.coin.id) { item in
                                SectorMark(angle: .value(item.coin.symbol.uppercased(), item.value * item.coin.currentPrice))
                                    .foregroundStyle(by: .value("Name", item.coin.name))
                                    .cornerRadius(6)
                                    .annotation(position: .overlay) {
                                        KFImage(URL(string: item.coin.image))
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                    }
                            }
                        }
                        .chartLegend(.hidden)
                        .frame(width: 150, height: 150)
                        
                        VStack {
                            Text("Live Valuation:")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("\(wallet.toCurrency())")
                                .font(.title)
                                .fontWeight(.light)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        .padding(.bottom, 0)


                        Text("My Coins")
                            .font(.headline)
                            .padding(.top, 3)
                            .fontWeight(.bold)
                        
                        List {
                            ForEach(coinPortfolio, id: \.coin.id) { item in
                                PortfolioItemView(coin: item.coin, val: item.value)
                            }
                        }
                        .listStyle(PlainListStyle())
                        
                        HStack {
                            Button(action: {
                                // Action for Buy button
                                showBuyModal = true
                            }) {
                                Text("Buy")
                                    .font(.headline)
                                    .padding(.horizontal, 20)
                                    
                                    .foregroundColor(.red)
                            }
                            
                            Button(action: {
                                // Action for Sell button
                                showSellModal = true
                            }) {
                                Text("Sell")
                                    .font(.headline)
                                    .padding()
                                    
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        .padding(.top, 0)
                        
                        Spacer()
                    }
                    .onAppear {
                        print("Profile View appeared. Fetching coin data.")
                        updateCoinPortfolio()
                    }
                    .navigationBarItems(leading: Button(action: {
                        viewModel.signOut()
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.blue)
                    })
                    
                }
            }
            .sheet(isPresented: $showBuyModal, content: {
                        VStack {
                            Text("Add to Portfolio")
                                .font(.title)
                                .padding()
                            
                            TextField("Coin", text: $coin)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            TextField("Amount", text: $amount)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            Button(action: {
                                user.addToPortfolio(item: coin, value: Double(amount) ?? 0.0)
                                viewModel.addToPortfolio(coin: coin, value: Double(amount) ?? 0.0)
                                updateCoinPortfolio()
                                showBuyModal = false
                                coin = ""
                                amount = ""
                            }) {
                                Text("Add")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                        .padding()
                    })
            .sheet(isPresented: $showSellModal, content: {
                        VStack {
                            Text("Sell from Portfolio")
                                .font(.title)
                                .padding()
                            
                            TextField("Coin", text: $coin)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            TextField("Amount", text: $amount)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                            Button(action: {
                                user.removeFromPortfolio(itemName: coin, value: Double(amount) ?? 0.0)
                                viewModel.removeFromPortfolio(coin: coin, value: Double(amount) ?? 0.0)
                                updateCoinPortfolio()
                                showSellModal = false
                                coin = ""
                                amount = ""
                            }) {
                                Text("Sell")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                        .padding()
                    })
            
        }
    }
       

    private func updateCoinPortfolio() {
        // Ensure that the HomeViewModel has finished fetching coin data before proceeding
        if homeViewModel.coins.isEmpty {
            print("Coin data not yet available. Retrying in 1 second.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.updateCoinPortfolio()
            }
            return
        }
        
        print("Coin data is available. Updating portfolio.")
        coinPortfolio = user.portfolio.compactMap { item in
            if let coin = homeViewModel.getCoinBySymbol(item.name.lowercased()) {
                wallet += item.value * coin.currentPrice
                return (coin: coin, value: item.value)
            } else {
                print("No coin found for symbol: \(item.name.lowercased())")
                return nil
            }
        }
        
        if coinPortfolio.isEmpty {
            print("No coins matched the portfolio items.")
        } else {
            print("Coin portfolio updated with \(coinPortfolio.count) items.")
        }
    }
}
