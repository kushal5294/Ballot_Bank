//
//  Block.swift
//  crypto
//
//  Created by Kushal Patel on 6/29/24.
//


import Foundation
import CryptoKit
import RealmSwift

class Block: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var poll: Poll?
    @Persisted var data: String
    @Persisted var previousHash: String
    @Persisted var index: Int
    @Persisted var timeStamp: String
    @Persisted var nonce: Int
    @Persisted var thisHash: String


    // Function to generate a hash for a given string
    static func generateHash(from input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }
    
    // Initializer for the Block class
    convenience init(poll: Poll?, data: String, previousHash: String, index: Int, time: String) {
        self.init()
        self._id = ObjectId.generate() // Ensure unique id for each block
        self.data = data
        self.previousHash = previousHash
        self.index = index
        self.nonce = 0
        self.poll = poll
        self.timeStamp = time
        self.thisHash = Block.calculateHash(data: data, previousHash: previousHash, index: index, time: time, nonce: nonce)
    }
    
    // Initializer for Genesis Block
    convenience init(previousHash: String, index: Int, time: String) {
        self.init()
        self._id = ObjectId.generate() // Ensure unique id for each block
        self.data = "Genesis Block"
        self.previousHash = previousHash
        self.index = index
        self.nonce = 0
        self.poll = nil
        self.timeStamp = time
        self.thisHash = Block.calculateHash(data: data, previousHash: previousHash, index: index, time: time, nonce: nonce)
    }
    
    static func calculateHash(data: String, previousHash: String, index: Int, time: String, nonce: Int) -> String {
        return generateHash(from: "\(data)\(previousHash)\(index)\(time)\(nonce)")
    }
    
    func printBlock() -> String {
        var blockDetails = ""
        blockDetails.append("Hash: \(hash)\n")
        blockDetails.append("Previous Hash: \(previousHash)\n")
        blockDetails.append("Timestamp: \(timeStamp)\n")
        blockDetails.append("Nonce: \(nonce)\n")

        if let poll = poll, !data.hasPrefix("Created") {
            blockDetails.append("Data: { Question: \(poll.title), Vote: \(data) }")
        } else if let poll = poll, data.hasPrefix("Created") {
            blockDetails.append("Data: { \(data) }")
        } else {
            blockDetails.append("Data: \(data)")
        }
        return blockDetails
    }
    
    func getData() -> String {
        if let poll = poll, !data.hasPrefix("Created") {
            return "{ Action: Voted for \(data) }"
        } else if let poll = poll, data.hasPrefix("Created") {
            return "{ Action: \(data) }"
        }
        return "{ Initialize: \(data) }"
    }
}
