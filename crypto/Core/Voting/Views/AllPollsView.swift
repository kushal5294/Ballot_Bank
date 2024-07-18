//
//  AllPollsView.swift
//  crypto
//
//  Created by Kushal Patel on 6/29/24.
//

import SwiftUI

struct AllPollsView: View {
    @StateObject var viewModel: VotingModel
    @Binding var devMode: Bool

    var body: some View {
        VStack(alignment: .leading){
            ScrollView{
                VStack{
                    ForEach(viewModel.polls.indices, id: \.self) { index in
                        PollRowView(poll: viewModel.polls[index], index: index + 1, votes: viewModel.polls[index].voteCounts.count, viewModel: viewModel, devMode: $devMode)
                        Divider()
                    }
                    
                }
            }
        }
    }
}

