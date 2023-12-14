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
	@State private var selectedBuilding: Building?
	@State private var isSheetPresented = false
	@State private var isSearchVisible = false
	@State private var isSearching = false

	var body: some View {
		VStack(alignment: .leading) {
			HeaderView
			SearchView
			BuildingsListView
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		.sheet(item: $selectedBuilding, content: BuildingDetailSheet)
		.sheet(isPresented: $isSheetPresented, content: FilterOptionsSheet)
		.onReceive(NotificationCenter.default.publisher(for: .languageChanged)) { _ in
			viewModel.loadBuildingsData()
		}
	}

	private var HeaderView: some View {
		VStack {
			HStack {
				Image("logo")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(maxWidth: 35, maxHeight: 10, alignment: .center)

				Text(t("Buildings"))
					.font(.largeTitle)
					.fontWeight(.bold)
					.foregroundColor(.white)
				Spacer()

				SearchAndFilterButtons
			}
			.padding()
		}
		.background(Color("Topbar"))
	}

	private var SearchAndFilterButtons: some View {
		HStack {
			Button {
				isSearchVisible.toggle()
				isSearching = false
			} label: {
				Image(systemName: isSearchVisible ? "xmark.circle" : "magnifyingglass")
					.foregroundColor(.white)
					.frame(maxWidth: 18, maxHeight: 18, alignment: .center)
			}
			.accessibilityLabel(isSearchVisible ? t("Close") : t("Search"))
			.padding(.trailing, 15)

			Button {
				isSheetPresented.toggle()
			} label: {
				Image("whiteFilterIconNew")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(maxWidth: 20, maxHeight: 10, alignment: .center)
			}
			.accessibilityLabel(t("Filter"))
		}
	}

	private var SearchView: some View {
		Group {
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

	private var BuildingsListView: some View {
		Group {
			if viewModel.filteredBuildings.isEmpty && (isSearching || filtersAreApplied()) {
				Text(t("No Results"))
					.font(.title)
					.fontWeight(.bold)
					.foregroundColor(.red)
					.padding()
			} else {
				ScrollView(.vertical, showsIndicators: true) {
					ForEach(filteredBuildings, id: \.id) { building in
						BuildingDetails(buildingContainer: BuildingContainer(building: building))
							.onTapGesture {
								self.selectedBuilding = building
							}
					}
				}
			}
		}
	}

	private var filteredBuildings: [Building] {
		isSearching ?
			viewModel.buildings.filter { viewModel.searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(viewModel.searchText) } :
			(viewModel.filteredBuildings.isEmpty ? viewModel.buildings : viewModel.filteredBuildings)
	}

	private func BuildingDetailSheet(for building: Building) -> some View {
		BuildingsView(building: building, selectedBuilding: $selectedBuilding)
	}

	private func FilterOptionsSheet() -> some View {
		NavigationView {
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

	private func filtersAreApplied() -> Bool {
		return viewModel.isShuttleFilter || viewModel.isPublicWashroomsFilter
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
