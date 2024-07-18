//
//  TopMoversView.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

import SwiftUI

struct TopMoversView: View {
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        VStack (alignment: .leading) {
            Text("Top Movers")
                .font(.headline)
            ScrollView (.horizontal){
                HStack (spacing: 16) {
                    ForEach(viewModel.topMovingCoins){ coin in
                        TopMoversItemView(coin: coin)
                    }
                }
            }
        }
        .padding()
    }
}
//
//#Preview {
//    TopMoversView()
//}
