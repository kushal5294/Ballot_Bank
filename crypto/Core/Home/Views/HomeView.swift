//
//  HomeView.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                
                // Top movers view
                TopMoversView(viewModel: viewModel)
                
                // divider
                Divider()
                // All coins view
                AllCoinsView(viewModel: viewModel)
            }
            .navigationTitle("Live Prices")
        }
    }
}

#Preview {
    HomeView()
}
