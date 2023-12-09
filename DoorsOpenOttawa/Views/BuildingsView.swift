//
//  BuildingsView.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-26.
//

import SwiftUI

struct BuildingsView: View {
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
			.navigationBarItems(trailing: Button("Close") {
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
		HStack {
//			ActionButtonsView
			BuildingDetailsView
		}
		.padding(.horizontal, 15)
		.padding(.vertical, 10)
	}

	private var ActionButtonsView: some View {
		HStack {
			FavoriteButton
			ShareButton
			NewBuildingIndicator
		}
	}

	private var FavoriteButton: some View {
		Button(role: .none) {} label: {
			Image(systemName: "heart")
		}
		.buttonStyle(.bordered)
		.accessibilityLabel("Favorite")
	}

	private var ShareButton: some View {
		Button(action: share) {
			Image(systemName: "square.and.arrow.up")
		}
		.buttonStyle(.bordered)
		.accessibilityLabel("Share")
	}

	private var NewBuildingIndicator: some View {
		Group {
			if building.isNew {
				Image("newBuilding")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(maxWidth: 35, maxHeight: 10, alignment: .center)
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
					Text(building.category)
						.font(.system(.body, design: .default))
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
					FeatureView(imageName: "satuday", text: "Open Saturdays")
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
		VStack {
			Image(imageName).resizable()
				.aspectRatio(contentMode: .fill)
				.frame(maxWidth: 35, maxHeight: 10, alignment: .center)
			Text(text)
				.font(.system(.body, design: .default))
		}
	}
}

#Preview {
	ContentView()
}
