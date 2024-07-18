//
//  BlocksView.swift
//  crypto
//
//  Created by Kushal Patel on 6/29/24.
//

import SwiftUI

struct BlocksView: View {
    var poll: Poll

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack{
                    ForEach(poll.voteCounts.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 5){
                            Text("TimeStamp:")
                                .fontWeight(.bold)
                            Text("\(poll.voteCounts[index].timeStamp)")
                                .font(.subheadline)
                            Text("Hash:")
                                .fontWeight(.bold)
                            Text("\(poll.voteCounts[index].hash)")
                                .font(.subheadline)
                            Text("Prev Hash:")
                                .fontWeight(.bold)
                            Text("\(poll.voteCounts[index].previousHash)")
                                .font(.subheadline)
                            Text("Data:")
                                .fontWeight(.bold)
                            Text("\(poll.voteCounts[index].getData())")
                                .font(.subheadline)
                            Text("Nonce:")
                                .fontWeight(.bold)
                            Text("\(poll.voteCounts[index].nonce)")
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
            .navigationTitle("Blocks for \(poll.title)")
            
        }
    }
}

