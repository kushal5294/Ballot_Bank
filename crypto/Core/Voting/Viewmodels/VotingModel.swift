//  VotingModel.swift
//  crypto
//
//  Created by Kushal Patel on 6/29/24.
//

import SwiftUI

class VotingModel: ObservableObject {
    @Published var blockChain = Blockchain(chain: [])
    @Published var polls = [Poll]()
    
    private let blockService = BlockService()
    
    init() {
        fetchBlockchain()
        processBlocks()
    }
    
    func fetchBlockchain() {
        blockService.fetchBlockchain { result in
            switch result {
            case .success(let blocks):
                DispatchQueue.main.async {
                    self.blockChain = Blockchain(chain: blocks)
//                    print("DEBUG: got good data from db")
                    self.processBlocks()
                }
            case .failure(let error):
//                print("Failed to fetch blockchain with error: \(error.localizedDescription)")
                self.blockChain = Blockchain(chain: [])
//                print("DEBUG: This is the first block: \(self.blockChain.chain[0].printBlock())")
            }
        }
//        print("DEBUG: Done fetching")
    }
    
    func processBlocks() {
        // Process blocks to create polls
        for block in blockChain.chain {
            if block.data.starts(with: "Created") {
                createPollFromBlock(block: block)
            }
        }
        
        for poll in polls {
//            print("DEBUG: We have a poll of (\(poll.title)) @ id:\(poll.id)")
        }
        
        // Process blocks to render votes
        for block in blockChain.chain {
            if !block.data.starts(with: "Created") {
                renderVote(from: block)
            }
        }
    }
    
    func createPollFromBlock(block: Block) {
        guard let pollData = block.poll else { return }
        
        let title = pollData.title
        let category = pollData.category
        let options = pollData.options
        let id = pollData.id
        let status = pollData.status
        
        var newPoll = Poll(title: title, cat: category, options: options, id: id, status: status)
        newPoll.voteCounts.append(block)
        polls.append(newPoll)
    }
    
    func renderVote(from block: Block) {
        let pollID = block.poll?.id
//        print("adding \(block.data) to poll: \(String(describing: block.poll?.id))")
        guard let pollIndex = polls.firstIndex(where: { $0.id == pollID }) else { return }
        polls[pollIndex].addVote(response: block)
//        print("DEBUG: \(polls[pollIndex].title) poll has \(polls[pollIndex].voteCounts) votes")
    }
    
    func addVote(to poll: Poll, with option: String) {
        guard let pollIndex = polls.firstIndex(where: { $0.id == poll.id }) else { return }
        let response = blockChain.createBlock(data: option, poll: poll)
        polls[pollIndex].addVote(response: response)
        saveBlockToFirebase(block: response)
    }
    
    func createPoll(title: String, cat: String, opts: [String]) {
        let newPoll = Poll(title: title, cat: cat, options: opts)
        polls.append(newPoll)
        let response = blockChain.createBlock(data: "Created \(title) Poll", poll: newPoll)
        polls[polls.count - 1].addVote(response: response)
        saveBlockToFirebase(block: response)
    }
    
    private func saveBlockToFirebase(block: Block) {
        blockService.saveBlock(block) { result in
            switch result {
            case .success:
                print("Block saved to Firebase successfully.")
            case .failure(let error):
                print("Failed to save block to Firebase with error: \(error.localizedDescription)")
            }
        }
    }
    
    func dummyVotes() {
        let voteRanges: [ClosedRange<Int>] = [
            0...5, 0...3, 0...10, 0...7, 0...4, 0...8, 0...6, 0...9, 0...3,
            0...5, 0...6, 0...4, 0...8, 0...5, 0...6, 0...7, 0...3, 0...4, 0...9
        ]
        
        for (index, poll) in polls.enumerated() {
            let range = voteRanges[index]
            let numberOfVotes = Int.random(in: range)
            
            for _ in 0..<numberOfVotes {
                let randomIndex = Int.random(in: 0..<poll.options.count)
                let randomOption = poll.options[randomIndex]
                addVote(to: poll, with: randomOption)
            }
        }
    }
    
    func dummyPolls() {
        createPoll(title: "Best NFL Team", cat: "NFL", opts: ["Lions", "Packers", "Chiefs"])
        createPoll(title: "UFC 304 Prediction", cat: "UFC", opts: ["Edwards", "Muhammad"])
        createPoll(title: "Best Social Media Platform", cat: "Tech", opts: ["Twitter", "Instagram", "Facebook"])
        createPoll(title: "Favorite Animal", cat: "General", opts: ["Dog", "Cat", "Fish"])
        createPoll(title: "Best Streaming Service", cat: "Entertainment", opts: ["Netflix", "Disney+", "Hulu"])
        createPoll(title: "Best Movie", cat: "Entertainment", opts: ["Inception", "Interstellar"])
        createPoll(title: "Favorite Sport", cat: "General", opts: ["Football", "Basketball", "MMA"])
        createPoll(title: "Best Book", cat: "Literature", opts: ["Harry Potter", "Lord of the Rings"])
        createPoll(title: "Morning Drink", cat: "General", opts: ["Coffee", "Tea"])
        createPoll(title: "Favorite Season", cat: "General", opts: ["Spring", "Summer", "Winter"])
        createPoll(title: "Favorite Cuisine", cat: "Food", opts: ["Italian", "Indian", "Mexican"])
        createPoll(title: "Favorite Car Brand", cat: "Automobile", opts: ["Tesla", "BMW", "Toyota"])
        createPoll(title: "Favorite Food", cat: "General", opts: ["Pizza", "Burger"])
        createPoll(title: "Top Smartphone Brand", cat: "Tech", opts: ["Apple", "Samsung", "Google"])
        createPoll(title: "Favorite Color", cat: "General", opts: ["Blue", "Red"])
        createPoll(title: "Preferred Music Genre", cat: "Music", opts: ["Rock", "Pop", "Classical"])
    }
    
    private func closeRandomPolls() {
        let randomIndexes = (0..<polls.count).shuffled().prefix(6)
        for index in randomIndexes {
            polls[index].status = "Closed"
        }
    }
}
