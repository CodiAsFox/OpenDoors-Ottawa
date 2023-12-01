//
//  DataModel.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-27.
//

import Combine
import Foundation
import SwiftUI

class BuildingsDataStore: ObservableObject {
	@Published var buildings: [Building] = []

	init() {
		loadBuildingsData()
	}

	private func loadBuildingsData() {
		if isFirstLaunch() {
			loadJsonFromAssets()
		} else {
			loadJsonFromAssets()
//			loadJsonFromLocalStorage()
		}
	}

	private func isFirstLaunch() -> Bool {
		let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
		if !launchedBefore {
			UserDefaults.standard.set(true, forKey: "launchedBefore")
			return true
		}
		return false
	}

	private func loadJsonFromAssets() {
		guard let url = Bundle.main.url(forResource: "buildings", withExtension: "json"),
		      let data = try? Data(contentsOf: url)
		else {
			print("Error: Couldn't load data from assets")
			return
		}
		parseAndSave(jsonData: data)
	}

	private func parseAndSave(jsonData: Data) {
		do {
			let buildingList = try JSONDecoder().decode([BuildingList].self, from: jsonData)
			buildings = buildingList.first { $0.language == "en" }?.buildings ?? []
			saveToLocalStorage(jsonData: jsonData)
		} catch {
			print("Error: Couldn't parse JSON data - \(error)")
		}
	}

	private func saveToLocalStorage(jsonData: Data) {
		UserDefaults.standard.set(jsonData, forKey: "buildingsData")
	}

	// When saving favorites
	func saveFavorites(favoriteBuildingIDs: [Int]) {
		UserDefaults.standard.set(favoriteBuildingIDs, forKey: "favoriteBuildingIds")
	}

	// When loading buildings and updating their favorites
	private func updateFavorites(in _: inout [Building]) {
//		guard let favoriteBuildingIDs = UserDefaults.standard.array(forKey: "favoriteBuildingIds") as? [Int] else { return }
//		for i in buildings.indices {
//			buildings[i].isFavorite = favoriteBuildingIDs.contains(buildings[i].id)
//		}
	}

	private func loadJsonFromLocalStorage() {
		guard let jsonData = UserDefaults.standard.data(forKey: "buildingsData") else { return }
		do {
			var buildingList = try JSONDecoder().decode([BuildingList].self, from: jsonData)
			if let index = buildingList.firstIndex(where: { $0.language == "en" }) {
				updateFavorites(in: &buildingList[index].buildings)
				buildings = buildingList[index].buildings
			}
		} catch {
			print("Error: Couldn't load data from local storage")
		}
	}
}

class BuildingContainer: ObservableObject {
	@Published var building: Building

	init(building: Building) {
		self.building = building
	}
}

#Preview {
	ContentView()
}
