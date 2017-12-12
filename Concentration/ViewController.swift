//
//  ViewController.swift
//  Concentration
//
//  Created by YangyangWang on 07/12/2017.
//  Copyright © 2017 wangyangyang. All rights reserved.
//

import UIKit

 class ViewController: UIViewController {
    
    private var game: Concentration!
    
    override func viewDidLoad() {
        newGame(newGameButton)
    }
    // Start New Game
    @IBAction func newGame(_ sender: Any) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1 ) / 2)
        
        view.backgroundColor = game.chosenTheme.backgroundColor
        newGameButton.setTitleColor(game.chosenTheme.titleColor, for: .normal)
        flipCountLabel.textColor = game.chosenTheme.titleColor
        scoreLabel.textColor = game.chosenTheme.titleColor
        updateViewFromModel()
    }
    @IBOutlet private weak var flipCountLabel: UILabel!
//        {
//        didSet{
//            let attributes: [NSAttributedStringKey:Any] = [
//                .strokeWidth: 5.0,
//                .strokeColor: game.chosenTheme.titleColor
//            ]
//            let attributedString = NSAttributedString(string: "Flips:\(game.flipCount)", attributes: attributes)
//            flipCountLabel.attributedText = attributedString
//        }
//    }
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton)  {
        if let cardNumber = cardButtons.index(of: sender) {
            if !game.cards[cardNumber].isFaceUp {
                game.chooseCard(at: cardNumber)
                updateViewFromModel()
            }
        }
    }
   private func updateViewFromModel() {
        flipCountLabel.text = "Flips:\(game.flipCount)"
        scoreLabel.text = "Score:\(game.score)"
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp, !game.isOver {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = UIColor.white
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : game.chosenTheme.titleColor
            }
        }
    }
    
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, game.chosenTheme.emojis.count > 0 {
            let randomText = game.chosenTheme.emojis.count.arc4random
            emoji[card] = game.chosenTheme.emojis.remove(at: randomText)
        }
        return emoji[card] ?? "?"
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self)))) 
        } else {
            return 0
        }
    }
}

