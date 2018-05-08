//
//  PhotosCollectionViewController.swift
//  InstrumentMe
//
//  Created by Kajetan Dąbrowski on 07/05/2018.
//  Copyright © 2018 DaftMobile. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
	
	@IBOutlet weak var imageView: UIImageView!

	override func awakeFromNib() {
		super.awakeFromNib()
		addMotion()
	}

	func addMotion() {
		let motionX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
		motionX.minimumRelativeValue = -20
		motionX.maximumRelativeValue = 20
		imageView.addMotionEffect(motionX)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
	}
}

extension UIImage {
	func thumbnail(size: CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
		let proportionsx = self.size.width / size.width
		let proportionsy = self.size.height / size.height
		let prop = min(proportionsx, proportionsy)

		let drawingWidth = (1.0 / prop) * self.size.width
		let drawingHeight = (1.0 / prop) * self.size.height
		let offsetX = (drawingWidth - size.width) * 0.5
		let offsetY = (drawingHeight - size.height) * 0.5

		self.draw(in: CGRect(x: -offsetX, y: -offsetY, width: drawingWidth, height: drawingHeight))
		let image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}
}

class PhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 100
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as? PhotoCell else { fatalError() }
		let index = (indexPath.item % 5) + 1
		let name = "photo\(index)"
		let imagePath = Bundle.main.url(forResource: name, withExtension: "jpg")!
		let data = try! Data.init(contentsOf: imagePath)
		let image = UIImage(data: data)
		cell.imageView.image = image
		return cell
	}

	var side: CGFloat { return min(collectionView!.bounds.width, collectionView!.bounds.height) }

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: side, height: side)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 20
	}
}
