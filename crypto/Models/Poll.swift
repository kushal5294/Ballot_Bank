//
//  Poll.swift
//  crypto
//
//  Created by Kushal Patel on 6/29/24.
//

import Foundation

struct Poll: Codable, Identifiable {
    var id: UUID = UUID()
    var title: String
    var category: String
    var options: [String]
    var voteCounts: [Block]
    var status: String
    
    init(title: String, cat: String, options: [String]) {
        self.title = title
        self.category = cat
        self.options = options
        self.voteCounts = []
        self.status = "Open"
    }
    init(title: String, cat: String, options: [String], id: UUID, status: String) {
        self.title = title
        self.category = cat
        self.options = options
        self.voteCounts = []
        self.status = status
        self.id = id
    }
    
    mutating func addVote(response: Block) {
        voteCounts.append(response)
    }
    func getWinner() -> String {
        if voteCounts.count == 1 {
            return "No Votes"
        }
        var hashMap = Dictionary<String, Int>()
        for block in voteCounts{
            if block.data.prefix(7).lowercased() == "Created"{
                continue
            }
            else{
                if let count = hashMap[block.data]{
                    hashMap[block.data]  = count + 1
                }
                else{
                    hashMap[block.data] = 1
                }
            }
        }
        let maxVotes = hashMap.values.max()
        let winners = hashMap.filter { $0.value == maxVotes }.map { $0.key }
        if winners.count == 1 {
            return winners.first!
        } 
        else {
            return winners.joined(separator: " and ") + " ties"
        }
    }
}

