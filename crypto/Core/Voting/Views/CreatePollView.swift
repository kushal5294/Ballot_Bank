//
//  CreatePollView.swift
//  crypto
//
//  Created by Kushal Patel on 6/29/24.
//

import SwiftUI

struct CreatePollView: View {
    @State private var title: String = ""
    @State private var category: String = ""
    @State private var options: [String] = ["", ""]
    @StateObject var viewModel: VotingModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Title")
                .font(.headline)
            TextField("Enter poll title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Category")
                .font(.headline)
            TextField("Enter poll category", text: $category)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Options")
                .font(.headline)

            ForEach(options.indices, id: \.self) { index in
                TextField("Option \(index + 1)", text: $options[index])
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            Button(action: {
                options.append("")
            }) {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                    Text("Add Option")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }

            Button(action: {
                createPoll()
            }) {
                Text("Create Poll")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Create Poll")
    }

    private func createPoll() {
        viewModel.createPoll(title: title, cat: category, opts: options)
        presentationMode.wrappedValue.dismiss()
    }
}
