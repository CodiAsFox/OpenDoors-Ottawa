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

struct BuildingsListView: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@Binding var selectedBuilding: Building?
	@Binding var isSearching: Bool
	var onlySaved = false

	var body: some View {
		VStack {
			if viewModel.filteredBuildings.isEmpty && (isSearching || filtersAreApplied()) {
				Text(t("No Results"))
					.font(.title)
					.fontWeight(.bold)
					.foregroundColor(.red)
					.padding()
			} else {
				List {
					ForEach(filteredBuildings, id: \.id) { building in
						BuildingDetails(buildingContainer: BuildingContainer(building: building)).background {
							NavigationLink(destination: BuildingsView(building: building, selectedBuilding: $selectedBuilding)) {
								EmptyView()
							}.opacity(0)
						}
					}.listRowInsets(EdgeInsets())
				}
				.listStyle(.grouped)
			}
		}
	}

	private var filteredBuildings: [Building] {
		isSearching ?
			viewModel.buildings.filter { viewModel.searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(viewModel.searchText) } :
			(viewModel.filteredBuildings.isEmpty ? viewModel.buildings : viewModel.filteredBuildings)
	}

	private func filtersAreApplied() -> Bool {
		return viewModel.isShuttleFilter || viewModel.isPublicWashroomsFilter
	}
}

struct SearchView: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@Binding var isSearching: Bool
	@Binding var isSearchVisible: Bool
	var onlySaved = false

	var body: some View {
		if isSearchVisible {
			VStack(alignment: .leading) {
				HStack {
					TextField(t("Building name"), text: $viewModel.searchText)
						.padding(7)
						.background(Color(.systemGray6))
						.foregroundColor(.black)
						.cornerRadius(10)
						.padding(.horizontal)

					Button(action: {
						isSearching = true
					}) {
						Text(t("Search"))
							.fontWeight(.bold)
							.foregroundColor(.white)
					}
					.padding(10)
					.background(Color("Topbar"))
					.cornerRadius(10)
				}
				.padding(.horizontal)
			}
			.padding(.vertical)
			.background(Color("AccentColor"))
		}
	}
}

struct FilterOptionsSheet: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@Binding var selectedBuilding: Building?
	@Binding var isSheetPresented: Bool
	@Binding var isSearchVisible: Bool
	@Binding var isSearching: Bool
	var onlySaved = false

	var body: some View {
		Form {
			Picker(t("Category"), selection: $viewModel.selectedCategory) {
				Text(t("All Categories")).tag("")
				ForEach(viewModel.categories.sorted(), id: \.self) { category in
					Text(category).tag(category)
				}
			}
			.pickerStyle(.menu)

			Section(header: Text(t("Filters"))) {
				Toggle(isOn: $viewModel.isShuttleFilter) {
					CategoryView(imageName: "shuttle", text: "Shuttle")
				}
				Toggle(isOn: $viewModel.isPublicWashroomsFilter) {
					CategoryView(imageName: "washroom", text: "Public Washrooms")
				}
				Toggle(isOn: $viewModel.isAccessibleFilter) {
					CategoryView(imageName: "accessibility", text: "Accessible")
				}
				Toggle(isOn: $viewModel.isFamilyFriendlyFilter) {
					CategoryView(imageName: "familyFriendly", text: "Family Friendly")
				}
				Toggle(isOn: $viewModel.isFreeParkingFilter) {
					CategoryView(imageName: "freeParking", text: "Free Parking")
				}
				Toggle(isOn: $viewModel.isBikeParkingFilter) {
					CategoryView(imageName: "bikeracks", text: "Bike Rack")
				}
				Toggle(isOn: $viewModel.isPaidParkingFilter) {
					CategoryView(imageName: "paidParking", text: "Paid Parking")
				}
				Toggle(isOn: $viewModel.isGuidedTourFilter) {
					CategoryView(imageName: "guidedTour", text: "Guided Tour")
				}
				Toggle(isOn: $viewModel.isOCTranspoNearbyFilter) {
					CategoryView(imageName: "ocTranspo", text: "OC Transpo Nearby")
				}
				Toggle(isOn: $viewModel.isOpenSaturdayFilter) {
					CategoryView(imageName: "saturday", text: "Open Saturdays")
				}
				Toggle(isOn: $viewModel.isOpenSundayFilter) {
					CategoryView(imageName: "sunday", text: "Opened Sundays")
				}
			}

			Button(action: {
				isSheetPresented = false
				isSearchVisible = false
				viewModel.filterBuildings()
			}) {
				Text(t("Apply Filters"))
			}

			Button(role: .destructive, action: {
				isSheetPresented = false
				isSearchVisible = false
				viewModel.resetFilters()
			}) {
				Text(t("Reset Filters"))
			}
		}

		.navigationBarTitle(t("Filter Options"))
		.navigationBarItems(trailing: Button(t("Close")) {
			isSheetPresented = false
		})
	}
}

struct CategoryView: View {
	var imageName: String
	var text: String

	var body: some View {
		HStack(alignment: .center) {
			Image(imageName)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(maxWidth: 35, maxHeight: 30, alignment: .center)
				.accessibility(hidden: true)

			Text(t(text))
				.font(.system(.body, design: .default))
		}
	}
}

#Preview {
	ContentView()
		.environmentObject(BuildingsDataStore())
		.environmentObject(LanguageManager())
}
