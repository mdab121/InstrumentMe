//
//  Misc.swift
//  InstrumentMe
//
//  Created by Kajetan Dąbrowski on 08/05/2018.
//  Copyright © 2018 DaftMobile. All rights reserved.
//

import UIKit
import CoreImage

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@IBOutlet var imageView: UIImageView!
	@IBOutlet weak var imageView2: UIImageView!
	let imagePicker = UIImagePickerController()

	override func viewDidLoad() {
		super.viewDidLoad()
		imagePicker.delegate = self

	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	@IBAction func takePhoto(_ sender: AnyObject) {

		if !UIImagePickerController.isSourceTypeAvailable(.camera) {
			return
		}

		imagePicker.allowsEditing = false
		imagePicker.sourceType = .camera

		present(imagePicker, animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

		self.imageView.contentMode = .scaleAspectFit

		dismiss(animated: true) { [weak self] in
			if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
				self?.imageView.image = pickedImage.fixedOrientation()
			}
			self?.detect()
		}
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}

	func detect() {
		let imageOptions = [CIDetectorImageOrientation: 0]
		let personciImage = CIImage(cgImage: imageView.image!.cgImage!)
		let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
		let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
		let faces = faceDetector?.features(in: personciImage, options: imageOptions)

		if let face = faces?.first as? CIFaceFeature, face.hasLeftEyePosition && face.hasRightEyePosition {
			imageView.image = drawEyes(left: face.leftEyePosition, right: face.rightEyePosition, image: imageView.image!)
		} else {
			let alert = UIAlertController(title: "No Face!", message: "No face was detected", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
		}
	}

	func drawEyes(left: CGPoint, right: CGPoint, image: UIImage) -> UIImage {

		UIGraphicsBeginImageContextWithOptions(image.size, true, 0)

		image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
		let context = UIGraphicsGetCurrentContext()!
		context.translateBy(x: 0, y: image.size.height)
		context.scaleBy(x: 1.0, y: -1.0)

		drawRandomEye(at: left, context: context)
		drawRandomEye(at: right, context: context)

		let image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return image
	}

	private func drawRandomEye(at point: CGPoint, context: CGContext) {

		let size1: CGFloat = CGFloat.random(min: 90, max: 120)
		let size2: CGFloat = CGFloat.random(min: 50, max: 75)

		context.setFillColor(UIColor.white.cgColor)
		context.fillEllipse(in: CGRect(x: point.x, y: point.y, width: 0, height: 0).insetBy(dx: -size1, dy: -size1).offsetBy(dx: 0, dy: 20))
		context.setFillColor(UIColor.darkGray.cgColor)
		context.fillEllipse(in: CGRect(x: point.x, y: point.y, width: 0, height: 0).insetBy(dx: -size2, dy: -size2))
	}
}

extension UIImage {
	func fixedOrientation() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		draw(in: CGRect(origin: .zero, size: size))
		let processedImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return processedImage

	}
}
