//  PollRowView.swift
//  crypto
//
//  Created by Kushal Patel on 6/29/24.
//

import SwiftUI

struct PollRowView: View {
    var poll: Poll
    let index: Int
    @State var votes: Int
    @State private var isExpanded = false
    @StateObject var viewModel: VotingModel
    @State private var hasVoted = false
    @Binding var devMode: Bool
    @EnvironmentObject var authView: AuthViewModel

    

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(index)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(poll.title)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.leading, 4)
                        HStack(spacing: 5){
                            Text("\(poll.category)")
                                .font(.caption)
                            if devMode {
                                NavigationLink(destination: BlocksView(poll: poll)) {
                                    Text("Show blocks")
                                        .cornerRadius(8)
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(.leading, 4)
                    }
                    .padding(.leading, 2)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(votes-1) \(votes-1 == 1 ? "Vote" : "Votes")")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.leading, 4)
                        Text("\(poll.status)")
                            .font(.caption)
                            .padding(.leading, 5)
                            .foregroundColor(poll.status == "Open" ? .green : .red)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                
                if isExpanded {
                    if !hasVoted && poll.status == "Open" {
                        HStack(spacing: 30) {
                            ForEach(poll.options, id: \.self) { option in
                                Button(action: {
                                    hasVoted = true
                                    votes += 1
                                    viewModel.addVote(to: poll, with: option)
                                    authView.addVote(voteId: poll.id.uuidString)
                                }) {
                                    Text("\(option)")
                                        .foregroundColor(.black)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                                        .cornerRadius(8)
                                        .font(.subheadline)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                        .frame(maxWidth: .infinity)
                    }
                    else if poll.status != "Open" {
                        Text("Winner: \(poll.getWinner())")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .cornerRadius(8)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 8)
                    }
                    else {
                        Text("Vote Submitted!")
                            .foregroundColor(.green)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .cornerRadius(8)
                            .padding(.horizontal, 8)
                            .padding(.bottom, 8)
                    }
                }
            }
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
        }
        .onAppear {
            // Check if the current user has already voted for this poll
            if let currentUserVotes = authView.currentUser?.votes {
                hasVoted = currentUserVotes.contains(poll.id.uuidString)
            }
        }
    }
}
