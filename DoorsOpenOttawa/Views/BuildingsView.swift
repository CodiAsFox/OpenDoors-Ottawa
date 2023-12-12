//
//  BuildingsView.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-26.
//

import MapKit
import SwiftUI

struct BuildingsView: View {
	@EnvironmentObject var lang: LanguageManager
	var building: Building
	@Binding var selectedBuilding: Building?

	@State private var showingShareSheet = false

	var body: some View {
		NavigationView {
			ScrollView(.vertical, showsIndicators: true) {
				VStack {
					BuildingImageView
					BuildingInfoView
				}
			}
			.navigationBarTitle("Building Details", displayMode: .inline)
			.navigationBarItems(leading: NewBuildingIndicator, trailing: Button("Close") {
				self.selectedBuilding = nil
			})
		}
	}

	private var BuildingImageView: some View {
		let imgName = imageName(from: building.image)
		return Image(imgName)
			.resizable()
			.accessibilityLabel("Image of \(building.imageDescription)")
			.aspectRatio(contentMode: .fill)
			.frame(height: 200, alignment: .center)
			.clipped()
	}

	private var BuildingInfoView: some View {
		VStack {
			BuildingDetailsView
			BuildingMap
			ActionButtonsView
		}
		.padding(.horizontal, 15)
		.padding(.vertical, 10)
	}

	private var ActionButtonsView: some View {
		HStack {
			FavoriteButton
			ShareButton
		}
	}

	private var FavoriteButton: some View {
		Button(role: .none) {} label: {
			Image(systemName: "heart")
			Text("Favorite")
		}
		.buttonStyle(.bordered)
	}

	private var ShareButton: some View {
		Button(action: share) {
			Image(systemName: "square.and.arrow.up")
			Text("Share")
		}
		.buttonStyle(.bordered)
	}

	private var NewBuildingIndicator: some View {
		Group {
			if building.isNew {
				HStack {
					Image("newBuilding")
						.resizable(capInsets: EdgeInsets())
						.aspectRatio(contentMode: .fill).padding(2)
						.frame(width: 35, height: 35).background(.white).cornerRadius(35)
				}.frame(width: 45, height: 45).background(Color("Topbar")).cornerRadius(35)
			}
		}
	}

	private var BuildingDetailsView: some View {
		VStack(alignment: .leading) {
			HStack {
				Text(building.address)
					.font(.system(.caption, design: .default))
					.foregroundColor(Color.black)

				Spacer()

				Text("00km away") // Placeholder for distance calculation
					.font(.system(.caption, design: .default))
					.foregroundColor(Color.black)
			}

			VStack(alignment: .leading) {
				Text(building.name)
					.fontWeight(.semibold)
					.foregroundStyle(Color("Titles"))
					.font(.title2).padding(.vertical, 5)

				VStack(alignment: .leading) {
					Label("Category", systemImage: "building.2.crop.circle")
						.fontWeight(.bold)
						.padding(.vertical, 10)
						.font(.system(.body, design: .default))
					HStack {
						VStack(alignment: .center) {
							Image(iconForCategory(building.category))
								.resizable()
								.aspectRatio(contentMode: .fill)
								.frame(width: 30, height: 30)
								.clipShape(Circle())
						}
						.background {
							Circle()
								.fill(Color("MapIcon"))
								.stroke(Color("MapIcon"), lineWidth: 1)
						}
						.frame(width: 35, height: 35)
						.overlay(
							Circle()
								.stroke(
									colorForCategory(building.category),
									lineWidth: 2
								)
						)
						Text(building.category)
							.font(.system(.body, design: .default))
					}
				}

				Label("Description", systemImage: "text.justify")
					.fontWeight(.bold)
					.font(.system(.body, design: .default))
					.padding(.vertical, 10)
				Text(building.description)
					.font(.system(.body, design: .default))

				Label("Features", systemImage: "list.bullet")
					.fontWeight(.bold)
					.padding(.vertical, 10)
					.font(.system(.body, design: .default))

				LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
					if building.isShuttle {
						FeatureView(imageName: "shuttle", text: "Shuttle")
					}
					if building.isGuidedTour {
						FeatureView(imageName: "guidedTour", text: "Guided Tour")
					}
					if building.isAccessible {
						FeatureView(imageName: "accessibility", text: "Accessible")
					}
					if building.isOpenSunday {
						FeatureView(imageName: "sunday", text: "Opened Sundays")
					}
					if building.isFreeParking {
						FeatureView(imageName: "freeParking", text: "Free Parking")
					}
					if building.isBikeParking {
						FeatureView(imageName: "bikeracks", text: "Bike Rack")
					}
					if building.isPaidParking {
						FeatureView(imageName: "paidParking", text: "Paid Parking")
					}
					if building.isOpenSaturday {
						FeatureView(imageName: "saturday", text: "Open Saturdays")
					}
					if building.isFamilyFriendly {
						FeatureView(imageName: "familyFriendly", text: "Family Friendly")
					}
					if building.isPublicWashrooms {
						FeatureView(imageName: "washroom", text: "Public Washrooms")
					}
					if building.isOCTranspoNearby {
						FeatureView(imageName: "ocTranspo", text: "OC Transpo Nearby")
					}
				}
			}
		}
	}

	private var BuildingMap: some View {
		VStack(alignment: .leading) {
			Label("Map", systemImage: "map")
				.fontWeight(.bold)
				.padding(.vertical, 10)
				.font(.system(.body, design: .default))
			Map {
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
				}.tint(colorForCategory(building.category))
			}
		}
		.frame(height: 300)
		.padding(.top, selectedBuilding != nil ? 0 : 0)
		.animation(.easeInOut, value: selectedBuilding != nil)
		.mapControls {
			MapUserLocationButton()
			MapCompass()
			MapScaleView()
		}
	}

	private func imageName(from filename: String) -> String {
		let parts = filename.split(separator: ".")
		return parts.first.map { String($0) } ?? ""
	}

	private func share() {
		guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
		      let rootController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
		else {
			return
		}

		if let image = ShareManager.captureImage(of: self) {
			ShareManager.shareImage(image: image, from: rootController)
		}
	}
}

struct FeatureView: View {
	var imageName: String
	var text: String

	var body: some View {
		VStack(alignment: .center) {
			Image(imageName)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(maxWidth: 35, maxHeight: 30, alignment: .center)
			Spacer()

			Text(text)
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
				.font(.system(.body, design: .default)).multilineTextAlignment(.center)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
		.padding()
	}
}

#Preview {
	ContentView()
}
