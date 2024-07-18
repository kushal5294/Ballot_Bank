//
//  VotingView.swift
//  crypto
//
//  Created by Kushal Patel on 6/29/24.
//

import SwiftUI

struct VotingView: View {
    @StateObject var viewModel = VotingModel()
    @State private var devMode = false
    @EnvironmentObject var authView: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                // Fixed Header
                HStack {
                    Text("Live Polls")
                        .font(.largeTitle)
                        .padding(.leading, 15)
                        .fontWeight(.bold)
                    
                    if authView.currentUser?.username == "dev1" {
                        Toggle("", isOn: $devMode)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing)
                    } else {
                        Spacer()
                    }
                }
                .padding(.vertical, 10)
                .background(Color(UIColor.systemBackground))
                .zIndex(1)

                Divider()

                // Scrollable Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        if devMode {
                            HStack {
                                Text("Developer Mode")
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                                    .padding(.leading, 15)
                                Spacer()
                                NavigationLink(destination: BlockchainView(blockChain: viewModel.blockChain)) {
                                    HStack(spacing: 0) {
                                        Text("See Local Blockchain")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.trailing, 15)
                                }
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 20)
                        } else {
                            HStack {
                                Spacer()
                                NavigationLink(destination: CreatePollView(viewModel: viewModel)) {
                                    HStack(spacing: 0) {
                                        Text("Create Poll")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.blue)
                                    }
                                    .padding(.trailing, 15)
                                }
                                .padding(.top, 5)
                                .padding(.bottom, 20)
                            }
                        }

                        AllPollsView(viewModel: viewModel, devMode: $devMode)
                            .padding(.horizontal)
                            .padding(.top, 0)
                    }
                }
            }
        }
    }
}

struct VotingView_Previews: PreviewProvider {
    static var previews: some View {
        VotingView()
    }
}
