//
//  Poll.swift
//  crypto
//
//  Created by Kushal Patel on 6/29/24.
//

import Foundation
import RealmSwift

class Poll: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: UUID = UUID()
    @Persisted var category: String = ""
    @Persisted var options: List<String>
    @Persisted var status: String = ""
    @Persisted var title: String = ""
    @Persisted var voteCounts: List<Block>
    
    override init() {
        super.init()
    }
    
    init(title: String, cat: String, options: [String]) {
        super.init()
        self.title = title
        self.category = cat
        self.options.append(objectsIn: options)
        self.status = "Open"
    }
    
    init(title: String, cat: String, options: List<String>, id: UUID, status: String) {
        super.init()
        self.title = title
        self.category = cat
        self.options = options
        self.status = status
        self._id = id
    }
    
    func addVote(response: Block) {
        voteCounts.append(response)
    }
    
    func getWinner() -> String {
        if voteCounts.count == 1 {
            return "No Votes"
        }
        var hashMap = [String: Int]()
        for block in voteCounts {
            if block.data.prefix(7).lowercased() == "created" {
                continue
            }
            hashMap[block.data, default: 0] += 1
        }
        let maxVotes = hashMap.values.max() ?? 0
        let winners = hashMap.filter { $0.value == maxVotes }.map { $0.key }
        if winners.count == 1 {
            return winners.first!
        } else {
            return winners.joined(separator: " and ") + " ties"
        }
    }
}
