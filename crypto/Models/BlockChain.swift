//  Blockchain.swift
//  crypto
//
//  Created by Kushal Patel on 6/29/24.
//

import Foundation
import CryptoKit

struct Blockchain: Codable, Identifiable {
    var id = UUID()
    var chain = [Block]()
    let difficulty = 2
    
    mutating func createInitialBlock() {
        let initialDate = "2024-07-02T00:00:00Z"
        let genesisBlock = Block(previousHash: "0000", index: 0, time: initialDate)
        chain.append(genesisBlock)
    }
    
    mutating func createBlock(data: String, poll: Poll) -> Block {
        let previousBlock = chain.last!
        let newTime = getNextTimeStamp(previousTimeStamp: previousBlock.timeStamp)
        var newBlock = Block(poll: poll, data: data, previousHash: previousBlock.hash, index: chain.count, time: newTime)
        newBlock = mineBlock(block: newBlock)
        chain.append(newBlock)
        return newBlock
    }
    
    private func getNextTimeStamp(previousTimeStamp: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        if let previousDate = dateFormatter.date(from: previousTimeStamp) {
            let randomHoursToAdd = Int.random(in: 1...12)
            let randomMinutesToAdd = Int.random(in: 0...59)
            let randomSecondsToAdd = Int.random(in: 0...59)
            var newDate = Calendar.current.date(byAdding: .hour, value: randomHoursToAdd, to: previousDate)!
            newDate = Calendar.current.date(byAdding: .minute, value: randomMinutesToAdd, to: newDate)!
            newDate = Calendar.current.date(byAdding: .second, value: randomSecondsToAdd, to: newDate)!
            return dateFormatter.string(from: newDate)
        }
        return previousTimeStamp
    }
    
    private func mineBlock(block: Block) -> Block {
        var newBlock = block
        while !newBlock.hash.hasPrefix(String(repeating: "0", count: difficulty)) {
            newBlock.nonce += 1
            newBlock.hash = Block.calculateHash(data: newBlock.data, previousHash: newBlock.previousHash, index: newBlock.index, time: newBlock.timeStamp, nonce: newBlock.nonce)
        }
        return newBlock
    }
    
    init() {
        self.chain = []
        createInitialBlock()
    }
}
