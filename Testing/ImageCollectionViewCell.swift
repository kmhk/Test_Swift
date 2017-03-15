//
//  ImageCollectionViewCell.swift
//  Testing
//
//  Created by Com on 19/02/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static var id = "ImageCollectionViewCell"
	
	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var lblDistance: UILabel!
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
	var imgItem: ImageItem?
	
	var distance: Double = -1
	var imgData: Data?
	
	func setCell(with item: ImageItem) {
		imgItem = item
		
		lblTitle.text = imgItem?.title
		
		if let distance = imgItem?.distance {
			self.distance = round(10 * distance / 1000) / 10
			lblDistance.text = "\(self.distance) km"
		}
		
		let dataTask: ((Data?, URLResponse?, Error?) -> Void) = { (data, response, error) in
			self.showLoadingIndicator(flag: false)
			guard error == nil else { return }
			
			self.imgData = data
			self.imgView.image = UIImage(data: data!)
		}
		
//		if let data = imgData {
//			self.imgView.image = UIImage(data: data)
//		} else {
			showLoadingIndicator(flag: true)
			URLSession.shared.dataTask(with: (imgItem?.url)!, completionHandler: dataTask).resume()
//		}
	}
	
	func showLoadingIndicator(flag: Bool) {
		if flag == true {
			loadingIndicator.startAnimating()
			loadingIndicator.isHidden = false
		} else {
			self.loadingIndicator.stopAnimating()
			self.loadingIndicator.isHidden = true
		}
	}
}
