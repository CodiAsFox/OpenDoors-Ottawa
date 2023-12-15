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
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(BuildingsDataStore())
				.environmentObject(LanguageManager())
		}
	}
}
