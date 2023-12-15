//
//  Main.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-26.
//

import CoreData
import SwiftUI

struct ContentView: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@EnvironmentObject var lang: LanguageManager

	var body: some View {
		TabView {
			NavigationView {
				HomeView()
			}
			.tabItem {
				Label(t("Home"), systemImage: "building")
			}
			NavigationView {
				MapView()

			}.tabItem {
				Label(t("Map"), systemImage: "map")
			}

			NavigationView {
				SavedView()
			}
			.tabItem {
				Label(t("Saved"), systemImage: "star.fill")
			}
			NavigationView {
				MoreView()
			}.tabItem {
				Label(t("More"), systemImage: "ellipsis")
			}
		}
	}
}

#Preview {
	ContentView()
		.environmentObject(BuildingsDataStore())
		.environmentObject(LanguageManager())
}
