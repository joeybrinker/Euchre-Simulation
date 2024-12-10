//
//  main.swift
//  Euchre
//
//  Created by Joseph Brinker on 11/13/24.
//

import Foundation

// Create Players
var p1 = Player(name: "BOT 1")
var p2 = Player(name: "BOT 2")
var p3 = Player(name: "BOT 3")
var p4 = Player(name: "BOT 4")

// Initialize variables
var table: [Card] = []
let players = [p1, p2, p3, p4]
var deck = Deck()
var trumpSuit = deck.setTrumpSuit()
var team1Score = 0
var team2Score = 0
var handWinner = 0

// Run until a team wins 3 points
while (team1Score < 3 && team2Score < 3) {
    
    // Keep track of who wins the hands
    var team1Hands = 0
    var team2Hands = 0
    
    // Create deck, deal to players, and find the trump suit
    deck = Deck()
    deck.deal(p1: p1, p2: p2, p3: p3, p4: p4)
    trumpSuit = deck.setTrumpSuit()
    
    for player in players {
        player.addTrump(trump: trumpSuit)
    }
    print("The trump suit is: \(trumpSuit.rawValue)")  // Display the trump suit
    
    // Show original hands
    print("Everyone's Hands")
    for player in players {
        player.printHand()
    }
    print()
    
    // Play hands
    while p1.hand.count > 0 {
        
        p1.playCard(table: &table)
        printTable()
        
        for player in players {
            player.leadingSuit(table: &table, trump: trumpSuit)
        }
        
        p2.playCard(table: &table)
        printTable()
        
        p3.playCard(table: &table)
        printTable()
        
        p4.playCard(table: &table)
        printTable()
        
        // Get winner of hand
        handWinner = findWinner()!
        
        // Print the winner of the hand in a bold style
        printWinnerOfTheHand(player: players[handWinner].name)
        
        // Increment the appropriate team's score based on the hand winner
        if handWinner == 0 || handWinner == 2 {
            team1Hands += 1
        } else {
            team2Hands += 1
        }
        
        // Reset table
        table = []
        
        print()
    }
    
    // Determine the overall round winner based on hands won
    if team1Hands > team2Hands {
        team1Score += 1
    } else {
        team2Score += 1
    }
    
    // Print round end message and scores
    print("\n--- Round Over! ---")
    print("Team 1 Score: \(team1Score) | Team 2 Score: \(team2Score)")
    print("\n====================\n")
}
// Function to print "Winner of the hand" in bold, large ASCII text
func printWinnerOfTheHand(player: String) {
    print("""
    *******************************
    **   WINNER OF THE HAND    **
    **     \(player) is the winner!     **
    *******************************
    """)
}
// Function to print winner in ASCII (only at the end of the game)
func printFinalWinner(team: Int) {
    // ASCII Art for TEAM 1 or TEAM 2
    if team == 1 {
        print("""
        TTTTT  EEEEE  AAAAA  M   M   1
          T    E      A   A  MM MM   1
          T    EEEE   AAAAA  M M M   1
          T    E      A   A  M   M   1
          T    EEEEE  A   A  M   M  1111
        
        W   W  III  N   N  SSSS
        W   W   I   NN  N  S
        W W W   I   N N N  SSS
        WW WW   I   N  NN     S
        W   W  III  N   N  SSSS
        """)
        print("\nTEAM 1 WINS THE GAME!\n")
    } else {
        print("""
        TTTTT  EEEEE  AAAAA  M   M   22222
          T    E      A   A  MM MM      2
          T    EEEE   AAAAA  M M M   2222
          T    E      A   A  M   M   2
          T    EEEEE  A   A  M   M   22222
        
        W   W  III  N   N  SSSS
        W   W   I   NN  N  S
        W W W   I   N N N  SSS
        WW WW   I   N  NN     S
        W   W  III  N   N  SSSS
        """)
        print("\nTEAM 2 WINS THE GAME!\n")
    }
}
// At the end of the game, print the winner of the game
if team1Score == 3 {
    printFinalWinner(team: 1)
} else {
    printFinalWinner(team: 2)
}
// Find the index that has the highest card value
func findWinner() -> Int? {
    var values: [Int] = []
    for card in table {
        values.append(card.value) // Assuming `card.value` is the card's numerical value
    }
    let max = values.max()! // Find the highest card value
    let winner = values.firstIndex(of: max) // Get the index of the card with the highest value
    return winner // Return the index of the winner
}
func printTable() {
    // Create a list of card descriptions (e.g., "Ace of Spades")
    let descriptions = table.map { "\($0.rank.rawValue) of \($0.suit.rawValue)" }
    
    // Print the descriptions joined by commas
    print(descriptions.joined(separator: ", "))
}
