import Cocoa
import Foundation
enum Suit: String, CaseIterable {
    case hearts = "♥", diamonds = "♦", clubs = "♣", spades = "♠"
}
enum Rank: String, CaseIterable {
    case nine = "9", ten = "10", jack = "J", queen = "Q", king = "K", ace = "A"
}
struct Card {
    var suit: Suit
    var rank: Rank
    var value: Int
}
class Deck {
    var cards: [Card] = []
    init() {
        for suit in Suit.allCases {
            for rank in Rank.allCases {
                switch rank {
                case .nine:
                    cards.append(Card(suit: suit, rank: rank, value: 1))
                case .ten:
                    cards.append(Card(suit: suit, rank: rank, value: 2))
                case .jack:
                    cards.append(Card(suit: suit, rank: rank, value: 3))
                case .queen:
                    cards.append(Card(suit: suit, rank: rank, value: 4))
                case .king:
                    cards.append(Card(suit: suit, rank: rank, value: 5))
                case .ace:
                    cards.append(Card(suit: suit, rank: rank, value: 6))
                }
                
            }
        }
    }
    func deal(p1: Player, p2: Player, p3: Player, p4: Player){
        while deck.cards.count > 4 {
            deck.cards.shuffle()
            p1.hand.append(deck.cards[0])
            deck.cards.remove(at: 0)
            p2.hand.append(deck.cards[0])
            deck.cards.remove(at: 0)
            p3.hand.append(deck.cards[0])
            deck.cards.remove(at: 0)
            p4.hand.append(deck.cards[0])
            deck.cards.remove(at: 0)
        }
    }
    
    // Function to randomly set the trump suit
    func setTrumpSuit() -> Suit {
        let allSuits = Suit.allCases
        let randomIndex = Int.random(in: 0..<allSuits.count)
        return allSuits[randomIndex]
    }
}
class Player {
    var hand : [Card] = []
    var list : [(String, String)] = []
    var name : String
    
    init(name: String){
        self.name = name
    }
    func printHand(){
        list = []
        for i in 0..<hand.count{
            list.append((hand[i].rank.rawValue, hand[i].suit.rawValue))
        }
        print(list)
    }
    
    //NEEDS FIX SO IT WORKS
    func playCard(table: inout [Card]) {
        print("\(name) plays")
        if table.count == 0{
            //generates random number that then is used to throw a card
            let rand = Int.random(in: 0..<hand.count)
            //This conditional checks if the card is already a trump card, or if the card is the jack of the opposite suit of the same color.
            if hand[rand].suit != trumpSuit || hand[rand].suit != oppositeSuit(trump: trumpSuit) && hand[rand].rank != .jack{
                hand[rand].value += 6
            }
            table.append(hand[rand])
            hand.remove(at: rand)
            return
        }
        for i in 0..<hand.count { //looks through hand so it must play the same suit
            //checks if leading card is the bauer
            if table[0].suit == oppositeSuit(trump: trumpSuit) && table[0].rank == .jack{
                if hand[i].suit == trumpSuit{
                    table.append(hand[i])
                    hand.remove(at: i)
                    return
                }
                table.append(hand[0])
                hand.remove(at: 0)
                return
            }
            if hand[i].suit == table[0].suit {
                table.append(hand[i])
                hand.remove(at: i)
                return
            }
        }
        for i in 0..<hand.count { //looks through hand to check for greater card
            if hand[i].value > table[table.count-1].value {
                table.append(hand[i])
                hand.remove(at: i)
                return
            }
        }
        table.append(hand[0])
        hand.remove(at: 0)
    }
    //give value to leading suit
    func leadingSuit(table: inout [Card], trump : Suit){
        
        var leadingSuit = table[0].suit
        
        //if bauer is played as first card
        if table[0].suit == oppositeSuit(trump: trumpSuit) && table[0].rank == .jack{
            leadingSuit = trumpSuit
        }
        //reset values of cards
        for i in 0..<hand.count {
            switch hand[i].rank {
            case .nine:
                if hand[i].suit == trump {
                    break
                }
                hand[i].value = 1
            case .ten:
                if hand[i].suit == trump {
                    break
                }
                hand[i].value = 2
            case .jack:
                if hand[i].suit == trump || hand[i].suit == oppositeSuit(trump: trump) && hand[i].rank == .jack {
                    break
                }
                hand[i].value = 3
            case .queen:
                if hand[i].suit == trump {
                    break
                }
                hand[i].value = 4
            case .king:
                if hand[i].suit == trump {
                    break
                }
                hand[i].value = 5
            case .ace:
                if hand[i].suit == trump {
                    break
                }
                hand[i].value = 6
            }
        }
        //loop through each players hand
        for i in 0..<hand.count {
            if hand[i].suit == leadingSuit {
                hand[i].value += 6
            }
        }
    }
    
    func addTrump(trump: Suit){
        for i in 0..<hand.count {
            if hand[i].suit == trump {
                hand[i].value += 12
                if hand[i].rank == .jack {
                    hand[i].value += 7
                }
            }
            if hand[i].suit == oppositeSuit(trump: trump) && hand[i].rank == .jack {
                hand[i].value += 16
            }
        }
    }
    
    func oppositeSuit(trump: Suit) -> Suit {
        if trump == .clubs {
            return .spades
        }
        else if trump == .spades{
            return .clubs
        }
        else if trump == .diamonds{
            return .hearts
        }
        else{
            return .diamonds
        }
    }
    
}
