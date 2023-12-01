//
//  DataController.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-27.
//

import Foundation

import Combine

class DataController: ObservableObject {
	@Published var buildings: [Building] = []
	
	init() {
		loadJsonFromAssets()
	}
	
	private func loadJsonFromAssets() {
		guard let url = Bundle.main.url(forResource: "buildings", withExtension: "json"),
			  let data = try? Data(contentsOf: url) else {
			print("Error: Couldn't load data from assets")
			return
		}
		
		do {
			let decoder = JSONDecoder()
			let buildingList = try decoder.decode([BuildingList].self, from: data)
			buildings = buildingList.first { $0.language == "en" }?.buildings ?? []
		} catch {
			print("Error: Couldn't parse JSON data")
		}
	}
}
