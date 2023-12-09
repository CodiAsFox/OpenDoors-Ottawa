//
//  MapView.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-07.
//

import MapKit
import SwiftUI

struct MapView: View {
	@ObservedObject var viewModel: BuildingsDataStore

	var body: some View {
		VStack {
			HStack {
				Image("logo")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(maxWidth: 35, maxHeight: 10, alignment: .center)

				Text("Explore")
					.font(.largeTitle)
					.fontWeight(.bold)
					.foregroundColor(.white)
				Spacer()
			}
			.padding()
			.frame(minWidth: 0, maxWidth: .infinity)

			Map {
				ForEach(viewModel.buildings, id: \.id) { building in
					Annotation("", coordinate: CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude)) {
						ZStack {
							Button(action: {
								print("Button pressed")
							}) {
								Image(iconForCategory(building.category))
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(maxWidth: 30, maxHeight: 10, alignment: .center)
							}
						}
					}
				}
			}
			.mapControls {
				MapUserLocationButton()
				MapCompass()
				MapScaleView()
			}
		}
		.background(Color("Topbar"))
	}

	private func colorForCategory(_ category: String) -> Color {
		switch category {
		case "Academic Institutions": return .yellow
		case "Business and/or Foundations": return .blue
		case "Community and/or Care centres": return .green
		case "Embassies": return .pink
		case "Functional buildings": return .red
		case "Galleries and Theatres": return .purple
		case "Government buildings": return .mint
		case "Museums, Archives and Historic Sites": return .orange
		case "Other": return .teal
		case "Religious buildings": return .brown
		case "Sports and Leisure buildings": return .black
		default: print("Error: Unknown category: \(category)")
			return .gray
		}
	}

	private func iconForCategory(_ category: String) -> String {
		switch category {
		case "Academic Institutions": return "mapAcademic"
		case "Business and/or Foundations": return "mapBusiness"
		case "Community and/or Care centres": return "mapCommunity"
		case "Embassies": return "mapEmbassy"
		case "Functional buildings": return "mapFunctional"
		case "Galleries and Theatres": return "mapGalleries"
		case "Government buildings": return "mapGovernement"
		case "Museums, Archives and Historic Sites": return "mapMuseum"
		case "Other": return "mapOther"
		case "Religious buildings": return "newReligionFilterMap"
		case "Sports and Leisure buildings": return "mapSports"

		default: return ""
		}
	}
}

#Preview {
	ContentView()
}
