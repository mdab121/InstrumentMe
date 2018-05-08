//
//  Misc.swift
//  InstrumentMe
//
//  Created by Kajetan Dąbrowski on 08/05/2018.
//  Copyright © 2018 DaftMobile. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
	static func random() -> CGFloat {
		return random(min: 0.0, max: 1.0)
	}

	static func random(min: CGFloat, max: CGFloat) -> CGFloat {
		assert(max > min)
		return min + ((max - min) * CGFloat(arc4random()) / CGFloat(UInt32.max))
	}
}

extension Int {
	static func random(min: Int, max: Int) -> Int {
		assert(max >= min)
		if min == max { return min }
		return min + Int(arc4random_uniform(UInt32(max - min + 1)))
	}
}

extension UIColor {
	static func randomBrightColor() -> UIColor {
		return UIColor(hue: .random(),
					   saturation: .random(min: 0.5, max: 1.0),
					   brightness: .random(min: 0.7, max: 1.0),
					   alpha: 1.0)
	}

	var darker: UIColor {
		var hue: CGFloat = 0
		var saturation: CGFloat = 0
		var brightness: CGFloat = 0

		if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil) {
			return UIColor(hue: hue, saturation: saturation, brightness: brightness * 0.75, alpha: 1.0)
		}

		return self
	}
}
