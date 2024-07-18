//
//  CoinRowView.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

import SwiftUI
import Kingfisher

struct CoinRowView: View {
    let coin: Coin
    var body: some View {
        HStack{
            // market cap rank
            Text("\(coin.marketCapRank ?? 1)")
                .font(.caption)
                .foregroundColor(.gray)
            //image
            KFImage(URL(string: coin.image))
                .resizable()
                .scaledToFit()
                .frame(width:32, height: 32)
                .foregroundColor(.orange)
            // coin name info
            VStack(alignment: .leading, spacing: 4){
                
                Text(coin.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .padding(.leading, 5)
                
            }
            .padding(.leading, 2)
            Spacer()
            // coin price info
            VStack(alignment:.trailing, spacing: 4){
                Text("\(coin.currentPrice.toCurrency())")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                Text(coin.priceChangePercentage24H.toPerc())
                    .font(.caption)
                    .padding(.leading, 5)
                    .foregroundColor(coin.priceChangePercentage24H > 0 ? .green : .red)
            }
        }
        .padding(.horizontal)
        
    }
}
//
//#Preview {
//    CoinRowView()
//}
