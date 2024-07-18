//
//  TopMoversItemView.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

import SwiftUI
import Kingfisher

struct TopMoversItemView: View {
    let coin:Coin
    var body: some View {
        VStack (alignment: .leading)  {
            // Image
            KFImage(URL(string: coin.image))
                .resizable()
                .frame(width:32, height:32)
                .foregroundColor(.orange)
                .padding(.bottom, 8)
            // Coin info
            HStack{
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                Text("\(coin.currentPrice.toCurrency())")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Text(coin.priceChangePercentage24H.toPerc())
                .font(.title2)
                .foregroundColor(coin.priceChangePercentage24H > 0 ? .green : .red)
            
            // coin percent change
        }
        .frame(width: 140, height: 140)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 2)
        )
    }
}

//#Preview {
//    TopMoversItemView()
//}
