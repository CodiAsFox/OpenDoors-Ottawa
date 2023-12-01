//
//  LocationHelper.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-27.
//

import CoreLocation
import Foundation

struct Location {
	let latitude: Double
	let longitude: Double
}

func haversineDistance(userLocation: Location, destinationLocation: Location) -> Double {
	let earthRadius: Double = 6371

	let lat1 = userLocation.latitude.toRadians()
	let lon1 = userLocation.longitude.toRadians()
	let lat2 = destinationLocation.latitude.toRadians()
	let lon2 = destinationLocation.longitude.toRadians()

	let dLat = lat2 - lat1
	let dLon = lon2 - lon1

	let a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2)
	let c = 2 * atan2(sqrt(a), sqrt(1 - a))

	let distance = earthRadius * c
	return distance
}

extension Double {
	func toRadians() -> Double {
		return self * Double.pi / 180.0
	}
}

// let userLocation = Location(latitude: userLatitude, longitude: userLongitude)
// let destinationLocation = Location(latitude: destinationLatitude, longitude: destinationLongitude)
//
// let distance = haversineDistance(userLocation: userLocation, destinationLocation: destinationLocation)
// print("Distance: \(distance) km")

// import CoreLocation
// let locationManager = CLLocationManager()
// func requestLocationPermission() {
//	locationManager.delegate = self
//	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//	locationManager.requestWhenInUseAuthorization()
// }
//
// extension YourViewController: CLLocationManagerDelegate {
//	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//		if let location = locations.last {
//			let userLatitude = location.coordinate.latitude
//			let userLongitude = location.coordinate.longitude
//
//			// Now you have the user's latitude and longitude
//			print("Latitude: \(userLatitude), Longitude: \(userLongitude)")
//		}
//	}
//
//	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//		// Handle location error here
//		print("Location error: \(error.localizedDescription)")
//	}
// }
//
// locationManager.startUpdatingLocation()
// struct YourView: View {
//	let locationManager = CLLocationManager()
//
//	var body: some View {
//		Text("Your Content")
//			.onAppear {
//				requestLocationPermission()
//			}
//	}
//
//	func requestLocationPermission() {
//		locationManager.delegate = self
//		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//		locationManager.requestWhenInUseAuthorization()
//		locationManager.startUpdatingLocation()
//	}
// }
