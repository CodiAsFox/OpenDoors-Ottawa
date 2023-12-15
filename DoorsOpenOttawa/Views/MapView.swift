//
//  MapView.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-07.
//

import MapKit
import SwiftUI

struct MapView: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@EnvironmentObject var lang: LanguageManager
	@State private var selectedBuilding: Building?
	@State private var sheetBuilding: Building?

	var body: some View {
		VStack {
			if self.selectedBuilding != nil {
				BuildingDetails(buildingContainer: BuildingContainer(building: selectedBuilding!))
				Button(action: {
					sheetBuilding = selectedBuilding
				}) {
					Text(t("View more"))
						.foregroundColor(.blue)
						.font(.headline)
						.frame(maxWidth: .infinity, alignment: .center)
				}
			}

			VStack {
				MapExplore(selectedBuilding: $selectedBuilding)
			}
			.sheet(item: $sheetBuilding) { Building in
				NavigationView {
					BuildingDetailSheet(for: Building)
						.navigationBarItems(leading: NewBuildingIndicator, trailing: Button(t("Close")) {
							sheetBuilding = nil
						})
				}
			}
		}
		.navigationTitle(t("Explore"))
		.toolbarColorScheme(.dark, for: .navigationBar)
		.toolbar {
			if self.selectedBuilding != nil {
				Button(action: {
					self.selectedBuilding = nil
				}) {
					Text(t("Close"))
						.font(.headline)
						.fontWeight(.bold)
						.foregroundColor(.white)
				}
			}
		}
		.toolbarBackground(
			Color("Topbar"),
			for: .navigationBar
		)
		.toolbarBackground(.visible, for: .navigationBar)
	}


	private func BuildingDetailSheet(for building: Building) -> some View {
		BuildingsView(building: building, selectedBuilding: $sheetBuilding)
	}

	private func imageName(from filename: String) -> String {
		let parts = filename.split(separator: ".")
		return parts.first.map { String($0) } ?? ""
	}

	private var NewBuildingIndicator: some View {
		HStack {
			if (sheetBuilding?.isNew) != nil {
				HStack {
					Image("newBuilding")
						.resizable(capInsets: EdgeInsets())
						.aspectRatio(contentMode: .fill).padding(2)
						.frame(width: 35, height: 35).background(.white).cornerRadius(35)
				}.frame(width: 45, height: 45).background(Color("Topbar")).cornerRadius(35)
			}
		}
	}
}

struct MapExplore: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@EnvironmentObject var lang: LanguageManager
	@Binding var selectedBuilding: Building?

	var body: some View {
		Map {
			ForEach(viewModel.buildings, id: \.id) { building in
				Annotation("", coordinate: CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)) {
					Button(action: {
						withAnimation {
							self.selectedBuilding = building
						}
					}) {
						Image(iconForCategory(building.category))
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: 35, height: 35)
							.clipShape(Circle())
					}
					.background {
						Circle()
							.fill(Color("MapIcon"))
							.stroke(Color("MapIcon"), lineWidth: 5)
					}
					.frame(width: 45, height: 45)
					.overlay(
						Circle()
							.stroke(
								selectedBuilding == nil
									? colorForCategory(building.category)
									: (building == selectedBuilding
										? colorForCategory(building.category)
										: Color.gray),
								lineWidth: 4
							)
					)
				}
				.tint(colorForCategory(building.category))
			}
		}
		.animation(.easeInOut, value: selectedBuilding != nil)
		.mapControls {
			MapUserLocationButton()
			MapCompass()
			MapScaleView()
		}
	}
}

#Preview {
	NavigationView {
		MapView()
	}
	.environmentObject(BuildingsDataStore())
	.environmentObject(LanguageManager())
}
