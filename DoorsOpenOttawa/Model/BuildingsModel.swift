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

struct Building: Equatable, Codable, Identifiable {
	var id: Int { buildingId }
	let categoryId: Int
	let buildingId: Int
	let name: String
	let image: String
	let website: String
	let address: String
	let category: String
	let sundayStart: String
	let sundayClose: String
	let description: String
	let saturdayStart: String
	let saturdayClose: String
	let imageDescription: String
	let isNew: Bool
	let isShuttle: Bool
	let isGuidedTour: Bool
	let isAccessible: Bool
	let isOpenSunday: Bool
	let isFreeParking: Bool
	let isBikeParking: Bool
	let isPaidParking: Bool
	let isOpenSaturday: Bool
	let isFamilyFriendly: Bool
	let isPublicWashrooms: Bool
	let isOCTranspoNearby: Bool
	let latitude: Double
	let longitude: Double

	var isFavorite: Bool? = false
}
