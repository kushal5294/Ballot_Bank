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
    
    mutating func createInitialBlock() {
        let currentDate = ISO8601DateFormatter().string(from: Date())
        let genesisBlock = Block(previousHash: "0000", index: 0, time: currentDate)
        chain.append(genesisBlock)
    }
    
    mutating func createBlock(data: String, poll: Poll) -> Block {
        let previousBlock = chain.last!
        let currentDate = ISO8601DateFormatter().string(from: Date())
        var newBlock = Block(poll: poll, data: data, previousHash: previousBlock.hash, index: chain.count-1, time: currentDate)
        newBlock = mineBlock(block: newBlock)
        chain.append(newBlock)
        return newBlock
    }
    
    private func mineBlock(block: Block) -> Block {
        var newBlock = block
        while !newBlock.hash.hasPrefix(String(repeating: "0", count: 2)) {
            newBlock.nonce += 1
            newBlock.hash = Block.calculateHash(data: newBlock.data, previousHash: newBlock.previousHash, index: newBlock.index, time: newBlock.timeStamp, nonce: newBlock.nonce)
        }
        return newBlock
    }
    
    init(chain: [Block]) {
//        print("DEBUG: in blockchain")
        self.chain = chain
//        print("DEBUG: We have \(self.chain.count) blocks")
    }
}
