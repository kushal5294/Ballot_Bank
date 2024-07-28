//
//  RegisterView.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//
import SwiftUI

struct RegisterView: View {
    @State private var userName: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var showMainView: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Image("BB_logo") // Replace with your actual image name
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100) // Adjust size as needed
                    .padding(.bottom, 20)
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Username", text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                

//                SecureField("Password", text: $password)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()

                Button(action: {
                    viewModel.register(withEmail: email, password: password, username: userName)
                }) {
                    Text("Register")
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

#Preview {
    RegisterView()
}
