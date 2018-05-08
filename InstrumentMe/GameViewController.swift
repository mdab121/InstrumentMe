//
//  ViewController.swift
//  InstrumentMe
//
//  Created by Kajetan Dąbrowski on 07/05/2018.
//  Copyright © 2018 DaftMobile. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

	@IBOutlet weak var gate1View: UIView!
	@IBOutlet weak var gate2View: UIView!

	@IBOutlet weak var gate1Label: UILabel!
	@IBOutlet weak var gate2Label: UILabel!

	@IBOutlet weak var scoreLabel: UILabel!
	var currentGame: Game?

	override func viewDidLoad() {
		super.viewDidLoad()
		gate1View.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(gate1Pressed)))
		gate2View.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(gate2Pressed)))
		newGame()
	}

	@objc func gate1Pressed() {
		performAction(index: 1)
	}

	@objc func gate2Pressed() {
		performAction(index: 2)
	}

	func performAction(index: Int) {
		_ = currentGame?.openGate(at: index)
		updateUI()
	}

	@IBAction func newGame() {
		let game = Game(player: Player(name: UUID().uuidString))
		currentGame = game
		updateUI()
	}

	func updateUI() {
		guard let result = currentGame?.currentResult else { return }
		switch result {
		case .lose:
			scoreLabel.text = NSString(string: "You Lose") as String
		case .win(score: let score):
			scoreLabel.text = NSString(string: "SCORE: \(score)") as String
		}
	}
}

