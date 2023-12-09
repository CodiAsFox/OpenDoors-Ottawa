//
//  BuildingDetails.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-01.
//

import SwiftUI

struct BuildingDetails: View {
	@ObservedObject var buildingContainer: BuildingContainer
	@State private var showingShareSheet = false

	private var building: Building {
		buildingContainer.building
	}

	var body: some View {
		VStack {
			BuildingImageView
			BuildingInfoView
		}
		.background(Color("boxBG"))
		.cornerRadius(15)
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
		VStack(alignment: .leading) {
			ActionButtonsView
			BuildingDetailsView
		}
		.padding(.horizontal, 15)
		.padding(.vertical, 10)
	}

	private var ActionButtonsView: some View {
		HStack {
			FavoriteButton
			ShareButton
			Spacer()
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
			Text(building.name)
				.foregroundStyle(Color("Titles"))
				.font(.system(.headline, design: .default))

			HStack {
				Text(building.address)
					.font(.system(.caption, design: .default))
					.foregroundColor(Color.black)

				Spacer()

				Text("00km away") // Placeholder for distance calculation
					.font(.system(.caption, design: .default))
					.foregroundColor(Color.black)
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

#Preview {
	ContentView()
}
