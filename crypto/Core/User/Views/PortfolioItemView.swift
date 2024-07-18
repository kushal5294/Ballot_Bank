//
//  PortfolioItemView.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

import SwiftUI
import Kingfisher

struct PortfolioItemView: View {
    let coin: Coin
    let val : Double
    var body: some View {
        HStack{
            
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
                Text("\(val.toCoin()) \(coin.symbol.uppercased())")
                    .font(.caption)
                    .padding(.leading, 5)
                
            }
            .padding(.leading, 2)
            Spacer()
            // coin price info
            VStack(alignment:.trailing, spacing: 4){
                Text("\((coin.currentPrice * val).toCurrency())")
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

