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
	@ObservedObject var viewModel: BuildingsDataStore
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
	}

	private var HeaderView: some View {
		VStack {
			HStack {
				Image("logo")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(maxWidth: 35, maxHeight: 10, alignment: .center)

				Text("Buildings")
					.font(.largeTitle)
					.fontWeight(.bold)
					.foregroundColor(.white)
				Spacer()

				SearchAndFilterButtons
			}
			.frame(minWidth: 0, maxWidth: .infinity)
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
			.accessibilityLabel(isSearchVisible ? "Close" : "Search")
			.padding(.trailing, 15)

			Button {
				isSheetPresented.toggle()
			} label: {
				Image("whiteFilterIconNew")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(maxWidth: 20, maxHeight: 10, alignment: .center)
			}
			.accessibilityLabel("Filter")
		}
	}

	private var SearchView: some View {
		Group {
			if isSearchVisible {
				VStack(alignment: .leading) {
					HStack {
						TextField("Building name", text: $viewModel.searchText)
							.padding(7)
							.background(Color(.systemGray6))
							.foregroundColor(.black)
							.cornerRadius(10)
							.padding(.horizontal)

						Button(action: {
							isSearching = true
						}) {
							Text("Search")
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
				Text("No Results")
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
					.padding()
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
				Picker("Category", selection: $viewModel.selectedCategory) {
					Text("All Categories").tag("")
					ForEach(viewModel.categories.sorted(), id: \.self) { category in
						Text(category).tag(category)
					}
				}
				.pickerStyle(.menu)

				Section(header: Text("Filters")) {
					Toggle("Shuttle", isOn: $viewModel.isShuttleFilter)
					Toggle("Public Washrooms", isOn: $viewModel.isPublicWashroomsFilter)
					Toggle("Accessible", isOn: $viewModel.isAccessibleFilter)
					Toggle("Family Friendly", isOn: $viewModel.isFamilyFriendlyFilter)
					Toggle("Free Parking", isOn: $viewModel.isFreeParkingFilter)
					Toggle("Bike Parking", isOn: $viewModel.isBikeParkingFilter)
					Toggle("Paid Parking", isOn: $viewModel.isPaidParkingFilter)
					Toggle("Guided Tour", isOn: $viewModel.isGuidedTourFilter)
					Toggle("OC Transpo Nearby", isOn: $viewModel.isOCTranspoNearbyFilter)
					Toggle("Open on Saturdays", isOn: $viewModel.isOpenSaturdayFilter)
					Toggle("Open on Sundays", isOn: $viewModel.isOpenSundayFilter)
				}

				Button(action: {
					isSheetPresented = false
					isSearchVisible = false
					viewModel.filterBuildings()
				}) {
					Text("Apply Filters")
				}

				Button(role: .destructive, action: {
					isSheetPresented = false
					isSearchVisible = false
					viewModel.resetFilters()
				}) {
					Text("Reset Filters")
				}
			}
			.navigationBarTitle("Filter Options")
			.navigationBarItems(trailing: Button("Close") {
				isSheetPresented = false
			})
		}
	}

	private func filtersAreApplied() -> Bool {
		return viewModel.isShuttleFilter || viewModel.isPublicWashroomsFilter
	}
}

struct BuildingDetailView: View {
	var building: Building

	var body: some View {
		Text(building.name) // Example
	}
}

#Preview {
	ContentView()
}
