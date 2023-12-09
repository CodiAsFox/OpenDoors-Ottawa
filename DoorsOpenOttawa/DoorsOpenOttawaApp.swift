//
//  DoorsOpenOttawaApp.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-23.
//

import SwiftData
import SwiftUI

@main
struct DoorsOpenOttawaApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(BuildingsDataStore())
		}
	}
}
