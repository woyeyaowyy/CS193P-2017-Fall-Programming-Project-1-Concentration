//
//  Concentration.swift
//  Concentration
//
//  Created by YangyangWang on 07/12/2017.
//  Copyright © 2017 wangyangyang. All rights reserved.
//

import Foundation
import UIKit
class Concentration {
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
              return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//          let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            return faceUpCardIndices.count == 1 ? faceUpCardIndices.first : nil
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var flipCount = 0
    var score = 0
    var pairsOfMatchedCards = 0
    var isOver: Bool{
        return pairsOfMatchedCards == 8
    }

    struct theme {
        var emojis: [String]
        var backgroundColor: UIColor
        var titleColor: UIColor
    }
    var chosenTheme: theme
    var themes = [
        theme(emojis: ["🐂","🐑","🐎","🐷","🐱","🐶","🐦","🐟"],backgroundColor: UIColor.black,titleColor: UIColor.orange),
        theme(emojis: ["⚽️","🏀","🏐️","🏓️","🏸️","🏈","🎾","⚾️"],backgroundColor: UIColor.white,titleColor: UIColor.blue),
        theme(emojis: ["🍎","🍌","🍉","🌰","🍑","🍓","🍇","🍒"],backgroundColor: UIColor.white,titleColor: UIColor.green),
        theme(emojis: ["🚗","🚕","🚙","🚌","🚎","🏎","🚓","🚑"],backgroundColor: UIColor.white,titleColor: UIColor.black),
        theme(emojis: ["😀","😆","😉","😍","😇","😜","🤓","😘"],backgroundColor: UIColor.white,titleColor: UIColor.yellow),
        theme(emojis: ["🍭","🍬","🍫","🍿","🍩","🍪","🍧","🍦"],backgroundColor: UIColor.white ,titleColor: UIColor.cyan)
    ]
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chosenCard(at: \(index )): chosen index not in the card")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    pairsOfMatchedCards += 1
                    score += 2
                } else if cards[index].hasFaceUp {
                    score -= 1
                }
                if !cards[index].hasFaceUp {
                    for thisindex in cards.indices {
                        if cards[thisindex] == cards[index] {
                            cards[thisindex].hasFaceUp = true
                        }
                    }
                }
                cards[index].isFaceUp = true
            } else {
                if !cards[index].hasFaceUp {
                    for thisindex in cards.indices {
                        if cards[thisindex] == cards[index] {
                            cards[thisindex].hasFaceUp = true
                        }
                    }
                } else {
                    score -= 1
                }
                //either no cards or 2 cards face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards): you must have at least one pair of cards")

        for _  in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        chosenTheme = themes[themes.count.arc4random]
        for index in 0..<numberOfPairsOfCards * 2 {
            let randomIndex = numberOfPairsOfCards*2.arc4random
            var temporyCard = Card()
            temporyCard =  cards[randomIndex]
            cards[randomIndex] = cards[index]
            cards[index] = temporyCard
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
