//
//  BlockchainView.swift
//  crypto
//
//  Created by Kushal Patel on 6/29/24.
//

import SwiftUI

struct BlockchainView: View {
    var blockChain: Blockchain
    
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    ForEach(blockChain.chain.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 5){
                            Text("TimeStamp:")
                                .fontWeight(.bold)
                            Text("\(blockChain.chain[index].timeStamp)")
                                .font(.subheadline)
                            Text("Hash:")
                                .fontWeight(.bold)
                            Text("\(blockChain.chain[index].hash)")
                                .font(.subheadline)
                            Text("Prev Hash:")
                                .fontWeight(.bold)
                            Text("\(blockChain.chain[index].previousHash)")
                                .font(.subheadline)
                            Text("Data:")
                                .fontWeight(.bold)
                            Text("\(blockChain.chain[index].getData())")
                                .font(.subheadline)
                            Text("Nonce:")
                                .fontWeight(.bold)
                            Text("\(blockChain.chain[index].nonce)")
                                .font(.subheadline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue))
                        .foregroundColor(.white)
                        Divider()
                    }
    
                }
                .padding(.top, 15)
                .padding(.horizontal, 25)
            }
            
            
        }
        .navigationTitle("Full Blockchain")
    }
}

