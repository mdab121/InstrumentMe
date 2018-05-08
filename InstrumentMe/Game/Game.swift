//
//  Game.swift
//  InstrumentMe
//
//  Created by Kajetan Dąbrowski on 07/05/2018.
//  Copyright © 2018 DaftMobile. All rights reserved.
//

import Foundation

enum Result {
	case win(score: Int)
	case lose
}
class Game {

	var currentResult: Result
	let player: Player

	init(player: Player) {
		self.player = player
		self.currentResult = .win(score: 0)
		self.player.game = self
	}

	func openGate(at index: Int) -> Result {
		guard case .win(score: let score) = currentResult else { return .lose }

		switch index {
		case 1: currentResult = .win(score: score + 1)
		default: currentResult = .lose
		}
		return currentResult
	}

}
