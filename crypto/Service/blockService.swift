//
//  blockService.swift
//  crypto
//
//  Created by Kushal Patel on 7/18/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct BlockService {
    private let db = Firestore.firestore()
    
    func fetchBlockchain(completion: @escaping (Result<[Block], Error>) -> Void) {
        db.collection("Blockchain").order(by: "index").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let blocks = documents.compactMap { try? $0.data(as: Block.self) }
            completion(.success(blocks))
        }
    }
    
    func saveBlock(_ block: Block, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try db.collection("Blockchain").document(block.id.uuidString).setData(from: block) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }
}

