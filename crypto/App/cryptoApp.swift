//
//  cryptoApp.swift
//  crypto
//
//  Created by Kushal Patel on 6/16/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main


struct cryptoApp: App {
    
    @StateObject var viewModel = AuthViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
                
        }
        .environmentObject(viewModel)
    }
}
