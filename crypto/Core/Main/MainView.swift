//
//  MainView.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

import SwiftUI
import Firebase

struct MainView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.UserSession == nil {
            SignInView()
            
        } else {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Market")
                    }
                VotingView()
                    .tabItem {
                        Image(systemName: "checkmark")
                        Text("Vote")
                    }

                Profile()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Account")
                    }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
