//
//  dbUser.swift
//  crypto
//
//  Created by Kushal Patel on 7/17/24.
//

import FirebaseFirestoreSwift


struct dbUser: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let email: String
    var portfolio: [PortfolioItem]
    
}
