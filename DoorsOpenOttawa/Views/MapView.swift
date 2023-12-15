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
						Text(t("View more"))
							.foregroundColor(.blue)
							.font(.headline)
							.frame(maxWidth: .infinity, alignment: .center)
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
			.sheet(item: $sheetBuilding) {
				NavigationView {
					BuildingDetailSheet
				}
//				.navigationBarItems(leading: NewBuildingIndicator, trailing: Button(t("Close")) {
//					self.selectedBuilding = nil
//				})
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

	private var NewBuildingIndicator: some View {
		Group {
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

	private func BuildingDetailSheet(for building: Building) -> some View {
		BuildingsView(building: building, selectedBuilding: $sheetBuilding)
	}

	private func imageName(from filename: String) -> String {
		let parts = filename.split(separator: ".")
		return parts.first.map { String($0) } ?? ""
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
