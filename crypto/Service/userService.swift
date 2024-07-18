//
//  userService.swift
//  crypto
//
//  Created by Kushal Patel on 7/17/24.
//

import Firebase
import FirebaseFirestoreSwift

struct UserService {
    
    func fetchUser(withUid uid: String, completion: @escaping(dbUser) -> Void) {
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                
                guard let user = try? snapshot.data(as: dbUser.self) else  { return }
                
                completion(user)
                
                
            }
        
    }
    
    
}
