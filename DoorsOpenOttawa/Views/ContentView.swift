//
//  Main.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-26.
//

import CoreData
import SwiftUI

struct ContentView: View {
	@StateObject var dataStore = BuildingsDataStore()

	var body: some View {
		TabView {
			NavigationView {
				HomeView(viewModel: dataStore)
			}
			.tabItem {
				Label("Home", systemImage: "house")
			}

			MapView(viewModel: dataStore)
				.tabItem {
					Label("Map", systemImage: "map")
				}

			NavigationView {
				Saved(viewModel: dataStore)
			}
			.tabItem {
				Label("Saved", systemImage: "star.fill")
			}

			Settings()
				.tabItem {
					Label("More", systemImage: "ellipsis")
				}
		}
		.tabViewStyle(.automatic)
	}
}

struct Settings: View {
	var body: some View {
		Text("Settings Crap!")
	}
}

struct Saved: View {
	@ObservedObject var viewModel: BuildingsDataStore

	var body: some View {
		Text("Saved crap!")
	}
}

#Preview {
	ContentView()
}
