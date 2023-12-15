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

	var isFavorite: Bool?

	private enum CodingKeys: String, CodingKey {
		case categoryId, buildingId, name, image, website, address, category
		case sundayStart, sundayClose, description, saturdayStart, saturdayClose
		case imageDescription, isNew, isShuttle, isGuidedTour, isAccessible
		case isOpenSunday, isFreeParking, isBikeParking, isPaidParking
		case isOpenSaturday, isFamilyFriendly, isPublicWashrooms, isOCTranspoNearby
		case latitude, longitude, isFavorite
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		categoryId = try container.decode(Int.self, forKey: .categoryId)
		buildingId = try container.decode(Int.self, forKey: .buildingId)
		name = try container.decode(String.self, forKey: .name)
		image = try container.decode(String.self, forKey: .image)
		website = try container.decode(String.self, forKey: .website)
		address = try container.decode(String.self, forKey: .address)
		category = try container.decode(String.self, forKey: .category)
		sundayStart = try container.decode(String.self, forKey: .sundayStart)
		sundayClose = try container.decode(String.self, forKey: .sundayClose)
		description = try container.decode(String.self, forKey: .description)
		saturdayStart = try container.decode(String.self, forKey: .saturdayStart)
		saturdayClose = try container.decode(String.self, forKey: .saturdayClose)
		imageDescription = try container.decode(String.self, forKey: .imageDescription)
		isNew = try container.decode(Bool.self, forKey: .isNew)
		isShuttle = try container.decode(Bool.self, forKey: .isShuttle)
		isGuidedTour = try container.decode(Bool.self, forKey: .isGuidedTour)
		isAccessible = try container.decode(Bool.self, forKey: .isAccessible)
		isOpenSunday = try container.decode(Bool.self, forKey: .isOpenSunday)
		isFreeParking = try container.decode(Bool.self, forKey: .isFreeParking)
		isBikeParking = try container.decode(Bool.self, forKey: .isBikeParking)
		isPaidParking = try container.decode(Bool.self, forKey: .isPaidParking)
		isOpenSaturday = try container.decode(Bool.self, forKey: .isOpenSaturday)
		isFamilyFriendly = try container.decode(Bool.self, forKey: .isFamilyFriendly)
		isPublicWashrooms = try container.decode(Bool.self, forKey: .isPublicWashrooms)
		isOCTranspoNearby = try container.decode(Bool.self, forKey: .isOCTranspoNearby)
		latitude = try container.decode(Double.self, forKey: .latitude)
		longitude = try container.decode(Double.self, forKey: .longitude)
		isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
	}
}
