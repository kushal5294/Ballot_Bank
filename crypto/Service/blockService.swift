//
//  blockService.swift
//  crypto
//
//  Created by Kushal Patel on 7/18/24.
//

import Foundation
import RealmSwift

class BlockService {
    private let app: App
    private var syncUser: RealmSwift.User?

    init() {
        app = App(id: "crypto-ykwyuwr")
    }

    func loginAndConfigureRealm(completion: @escaping (Result<Realm, Error>) -> Void) {
        app.login(credentials: Credentials.anonymous) { result in
            switch result {
            case .success(let user):
                self.syncUser = user
                let configuration = user.flexibleSyncConfiguration { subs in
                    subs.append(QuerySubscription<Block> {
                        $0.index > 0
                    })
                    subs.append(QuerySubscription<Poll> {
                        $0.status == "Open"
                    })

                }
                
                do {
                    let realm = try Realm(configuration: configuration)
                    completion(.success(realm))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchBlockchain(completion: @escaping (Result<[Block], Error>) -> Void) {
        loginAndConfigureRealm { result in
            switch result {
            case .success(let realm):
                let blocks = realm.objects(Block.self).sorted(byKeyPath: "index")
                completion(.success(Array(blocks)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func saveBlock(_ block: Block, completion: @escaping (Result<Void, Error>) -> Void) {
        loginAndConfigureRealm { result in
            switch result {
            case .success(let realm):
                do {
                    try realm.write {
                        realm.add(block)
                    }
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


//struct BlockService {
//    private let db = Firestore.firestore()
//    
//    func fetchBlockchain(completion: @escaping (Result<[Block], Error>) -> Void) {
//        db.collection("Blockchain").order(by: "index").getDocuments { snapshot, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let documents = snapshot?.documents else {
//                completion(.success([]))
//                return
//            }
//            
//            let blocks = documents.compactMap { try? $0.data(as: Block.self) }
//            completion(.success(blocks))
//        }
//    }
//    
//    func saveBlock(_ block: Block, completion: @escaping (Result<Void, Error>) -> Void) {
//        do {
//            try db.collection("Blockchain").document(block.id.uuidString).setData(from: block) { error in
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    completion(.success(()))
//                }
//            }
//        } catch let error {
//            completion(.failure(error))
//        }
//    }
//}

//mongodb+srv://kushal5294:BYhZVngyLOvLmylc@crypto.yiwtgzp.mongodb.net/
