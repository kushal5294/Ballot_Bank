//
//  AllCoinsView.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

import SwiftUI

struct AllCoinsView: View {
    @StateObject var viewModel: HomeViewModel
    var body: some View {
        VStack(alignment: .leading){
            Text("All Coins")
                .font(.headline)
                .padding()
            HStack{
                Text("Coin")
                Spacer()
                Text("Prices")
            }
            .padding()
            .font(.caption)
            .foregroundColor(.gray)
            
            ScrollView{
                
                VStack{
                    ForEach(viewModel.coins) {coin in
                        CoinRowView(coin: coin)
                    }
                    
                }
            }
        }
        
    }
}
//
//#Preview {
//    AllCoinsView(viewModel: HomeViewModel)
//}
