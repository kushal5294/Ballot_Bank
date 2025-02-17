//
//  SignInView.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//
import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showMainView: Bool = false
    @EnvironmentObject var viewModel:  AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Image("BB_logo") // Replace with your actual image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150) // Adjust size as needed
                    .padding(.bottom, 20)
                Text("Ballot Bank")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    viewModel.login(withEmail: email, password: password)
                }) {
                    Text("Sign In")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                NavigationLink(destination: RegisterView()) {
                                    Text("Create Account")
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .padding()
                                }
                Button(action: {
                    viewModel.login(withEmail: "Dev@test.com", password: "devtest")
                }) {
                    Text("Dev Demo")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
                                
                
                
            }
            .padding()
        }
    }

}
