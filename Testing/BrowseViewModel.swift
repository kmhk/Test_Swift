//
//  BrowseViewModel.swift
//  Testing
//
//  Created by Com on 19/02/2017.
//  Copyright © 2017 Com. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


struct ImageItem {
	var title: String
	var longitude: Double
	var latitude: Double
	var url: URL
	var distance: CLLocationDistance?
	
	init(dict: Dictionary<String, String>) {
		title = dict["title"]!
		latitude = Double(dict["latitude"]!)!
		longitude = Double(dict["longitude"]!)!
		url = URL(string: dict["Url"]!)!
	}
}

class BrowseViewModel: NSObject {
	var arrayImages = [ImageItem]()
	
	var locationManager = CLLocationManager()
	var geocoder = CLGeocoder()
	var currentLocation: CLLocation?
	
	override init() {
		super.init()
		
		readJson()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestAlwaysAuthorization()
		locationManager.startUpdatingLocation()
	}
	
	
	// MARK: private func
	
	private func readJson() {
		let url = Bundle.main.url(forResource: "data", withExtension: "json")
		let data = try? Data(contentsOf: url!)
		
		do {
			let array = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [Dictionary<String, String>]
			for dict in array {
				let item = ImageItem(dict: dict)
				arrayImages.append(item)
			}
			
		} catch {
			print()
		}
	}
	
	func getDistance() {
		for i in 0 ..< arrayImages.count {
			arrayImages[i].distance = currentLocation?.distance(from: CLLocation(latitude: arrayImages[i].latitude, longitude: arrayImages[i].longitude))
		}
	}
}


extension BrowseViewModel: CLLocationManagerDelegate {
	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		currentLocation = locations.last
		getDistance()
	}
}
