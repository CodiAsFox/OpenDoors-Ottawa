//
//  FilterOptionsSheet.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-15.
//

import SwiftUI

struct FilterOptionsSheet: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@Binding var selectedBuilding: Building?
	@Binding var isSheetPresented: Bool
	@Binding var isSearchVisible: Bool
	@Binding var isSearching: Bool

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

#Preview {
	NavigationView {
		HomeView()
	}
	.environmentObject(BuildingsDataStore())
	.environmentObject(LanguageManager())
}
