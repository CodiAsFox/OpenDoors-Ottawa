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
		ZStack(alignment: .top) {
			VStack {
				if self.selectedBuilding != nil {
					BuildingDetails(buildingContainer: BuildingContainer(building: selectedBuilding!))
					Button(action: {
						sheetBuilding = selectedBuilding
					}) {
						Label(t("View more"), systemImage: "chevron.up")
							.labelStyle(.titleAndIcon)
							.padding(.top, 10)
							.padding(.bottom, 5)
							.foregroundColor(.blue)
							.font(.headline)
							.frame(maxWidth: .infinity, alignment: .center)
							.background(Color.white)
							.cornerRadius(10)
							.padding(.horizontal, 15)
							.padding(.bottom, 10)
					}
				}

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
						}.tint(colorForCategory(building.category))
					}
				}
				.padding(.top, selectedBuilding != nil ? 0 : 0)
				.animation(.easeInOut, value: selectedBuilding != nil)
				.mapControls {
					MapUserLocationButton()
					MapCompass()
					MapScaleView()
				}
			}
			.padding(.top, 67)
			.sheet(item: $sheetBuilding, content: BuildingDetailSheet)

			VStack {
				HeaderView
					.zIndex(1)
			}
		}
	}

	private func BuildingDetailSheet(for building: Building) -> some View {
		BuildingsView(building: building, selectedBuilding: $sheetBuilding)
	}

	private func imageName(from filename: String) -> String {
		let parts = filename.split(separator: ".")
		return parts.first.map { String($0) } ?? ""
	}

	var HeaderView: some View {
		HStack {
			Image("logo")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(maxWidth: 35, maxHeight: 10, alignment: .center)

			Text(t("Explore"))
				.font(.largeTitle)
				.fontWeight(.bold)
				.foregroundColor(Color.white)
			Spacer()
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
		.padding()
		.background(Color("Topbar"))
	}
}

func colorForCategory(_ category: String) -> Color {
	switch category {
	case t("Academic Institutions"): return .yellow
	case t("Business and/or Foundations"): return .blue
	case t("Community and/or Care centres"): return .green
	case t("Embassies"): return .pink
	case t("Functional buildings"): return .red
	case t("Galleries and Theatres"): return .purple
	case t("Government buildings"): return .mint
	case t("Museums, Archives and Historic Sites"): return .orange
	case t("Other"): return .teal
	case t("Religious buildings"): return .brown
	case t("Sports and Leisure buildings"): return .black
	default: print("Error: Unknown category: \(category)")
		return .gray
	}
}

func iconForCategory(_ category: String) -> String {
	switch category {
	case t("Academic Institutions"): return "academic"
	case t("Business and/or Foundations"): return "business"
	case t("Community and/or Care centres"): return "community"
	case t("Embassies"): return "embassy"
	case t("Functional buildings"): return "utilities"
	case t("Galleries and Theatres"): return "theatre"
	case t("Government buildings"): return "government"
	case t("Museums, Archives and Historic Sites"): return "museum"
	case t("Other"): return "other"
	case t("Religious buildings"): return "religious"
	case t("Sports and Leisure buildings"): return "sports"

	default: print("Error: Unknown category: \(category)")
		return "other"
	}
}

#Preview {
	ContentView()
		.environmentObject(BuildingsDataStore())
		.environmentObject(LanguageManager())
}
