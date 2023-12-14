//
//  BuildingDetails.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-01.
//

import SwiftUI

struct BuildingDetails: View {
	@EnvironmentObject var lang: LanguageManager
	@EnvironmentObject var dataStore: BuildingsDataStore
	@ObservedObject var buildingContainer: BuildingContainer
	@State private var showingShareSheet = false

	private var building: Building {
		buildingContainer.building
	}

	var body: some View {
		VStack {
			ZStack(alignment: .topTrailing) {
				BuildingImageView.padding(3)
				NewBuildingIndicator
			}
			BuildingInfoView
		}
		.padding(0)
		.background(Color("boxBG"))
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
				HStack {
					Image("newBuilding")
						.resizable(capInsets: EdgeInsets())
						.aspectRatio(contentMode: .fill).padding(2)
						.frame(width: 35, height: 35).background(.white).cornerRadius(35)
				}.frame(width: 45, height: 45).background(Color("Topbar")).cornerRadius(35)
			}
		}.padding(.top, 3).padding(.trailing, 3)
	}

	private var BuildingDetailsView: some View {
		VStack(alignment: .leading) {
			Text(building.name)
				.foregroundStyle(Color("Titles"))
				.font(.system(.headline, design: .default))

			HStack {
				Text(building.address)
					.font(.system(.caption, design: .default))

				Spacer()

				if let distance = dataStore.distanceFromUser(to: building) {
					Text(String(format: t("%.2f km away"), distance))
						.font(.system(.caption, design: .default))
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

#Preview {
	ContentView()
		.environmentObject(BuildingsDataStore())
		.environmentObject(LanguageManager())
}
