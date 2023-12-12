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
				Label(t( "Home"), systemImage: "house")
			}

			MapView()
				.tabItem {
					Label(t("Map"), systemImage: "map")
				}

			NavigationView {
				Saved()
			}
			.tabItem {
				Label(t("Saved"), systemImage: "star.fill")
			}

			MoreView()
				.tabItem {
					Label(t( "More"), systemImage: "ellipsis")
				}
		}
		.tabViewStyle(.automatic)
	}
}

struct Saved: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@EnvironmentObject var lang: LanguageManager

	var body: some View {
		Text("Saved crap!")
	}
}

#Preview {
	ContentView()
}
