//
//  Buildings.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-27.
//

import Foundation
import SwiftUI

struct BuildingList: Codable {
	var language: String
	var version: Int
	var year: Int
	var buildings: [Building]
}

struct Building: Codable, Identifiable {
	var id: Int { buildingId }
	let buildingId: Int
	let name: String
	let isNew: Bool
	let address: String
	let description: String
	let website: String
	let categoryId: Int
	let category: String
	let saturdayStart: String
	let saturdayClose: String
	let sundayStart: String
	let sundayClose: String
	let isShuttle: Bool
	let isPublicWashrooms: Bool
	let isAccessible: Bool
	let isFreeParking: Bool
	let isBikeParking: Bool
	let isPaidParking: Bool
	let isGuidedTour: Bool
	let isFamilyFriendly: Bool
	let image: String
	let isOCTranspoNearby: Bool
	let imageDescription: String
	let latitude: Double
	let longitude: Double
	let isOpenSaturday: Bool
	let isOpenSunday: Bool

	var isFavorite: Bool? = false
}

#Preview {
	ContentView()
}
