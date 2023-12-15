//
//  HomeView.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-23.
//

import SwiftData
import SwiftUI
import UIKit

struct HomeView: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@EnvironmentObject var lang: LanguageManager
	@State var selectedBuilding: Building?
	@State var isSheetPresented = false
	@State var isSearchVisible = false
	@State var isSearching = false

	var body: some View {
		VStack(alignment: .leading) {
			SearchView(
				isSearching: $isSearching,
				isSearchVisible: $isSearchVisible
			)
			BuildingsListView(
				selectedBuilding: $selectedBuilding,
				isSearching: $isSearching
			)
		}
		.sheet(isPresented: $isSheetPresented) {
			FilterOptionsSheet(
				selectedBuilding: $selectedBuilding,
				isSheetPresented: $isSheetPresented,
				isSearchVisible: $isSearchVisible,
				isSearching: $isSearching
			)
		}
		.onReceive(NotificationCenter.default.publisher(for: .languageChanged)) { _ in
			viewModel.loadBuildingsData()
		}
		.navigationTitle(t("Buildings"))
		.toolbar {
			Group {
				Button {
					isSearchVisible.toggle()
					isSearching = false
				} label: {
					Image(systemName: isSearchVisible ? "xmark.circle" : "magnifyingglass")
						.frame(maxWidth: 18, alignment: .center)
				}
				.accessibilityLabel(isSearchVisible ? t("Close") : t("Search"))

				Button {
					isSheetPresented.toggle()
				} label: {
					Image(systemName: "line.3.horizontal.decrease.circle")
						.frame(width: 18, alignment: .center)
				}
				.accessibilityLabel(t("Filter"))
			}
		}
		.toolbarColorScheme(.dark, for: .navigationBar)
		.toolbarBackground(
			Color("Topbar"),
			for: .navigationBar
		)
		.toolbarBackground(.visible, for: .navigationBar)
	}
}

#Preview {
	NavigationView {
		HomeView()
	}
	.environmentObject(BuildingsDataStore())
	.environmentObject(LanguageManager())
}
