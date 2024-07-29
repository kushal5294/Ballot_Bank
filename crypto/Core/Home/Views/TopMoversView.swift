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
        VStack(alignment: .leading) {
            Text("Top Movers")
                .font(.headline)
            
            if (viewModel.topMovingCoins.count != 0) {
                ScrollView(.horizontal) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.topMovingCoins) { coin in
                            TopMoversItemView(coin: coin)
                        }
                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(2)
                    .padding(.vertical, 45)
                    .padding(.leading, 35)
            }
        }
        .padding()
    }
}
//
//#Preview {
//    TopMoversView()
//}
