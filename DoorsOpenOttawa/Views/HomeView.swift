//
//  HomeView.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-23.
//

import SwiftData
import SwiftUI

struct HomeView: View {
	@ObservedObject var viewModel: BuildingsDataStore

	var body: some View {
		VStack(alignment: .leading) {
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

				HStack {
					Button {
						// call "Search"
					} label: {
						Image("search")
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(maxWidth: 18, maxHeight: 10, alignment: .center)
					}.accessibilityLabel("Search").padding(.trailing, 15)

					Button {
						// call "Search"
					} label: {
						Image("whiteFilterIconNew")
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(maxWidth: 20, maxHeight: 10, alignment: .center)
					}.accessibilityLabel("Filter")
				}
			}
			.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/)
			.padding()
			.background(Color("Topbar"))
//			VStack{
			////				TextField("Search countries", text: $viewModel.searchText)
			////					.padding(7)
			////					.background(Color(.systemGray6))
			////					.cornerRadius(10)
//			}

			ScrollView(.vertical, showsIndicators: true) {
				ForEach(viewModel.buildings) { building in
					NavigationLink(destination: BuildingDetails(buildingContainer: BuildingContainer(building: building))) {
						BuildingDetails(buildingContainer: BuildingContainer(building: building))
					}
				}
				.padding()
			}
		}

		.frame(
			maxWidth: .infinity,
			maxHeight: .infinity,
			alignment: .topLeading
		)
	}
}

struct BuildingDetails: View {
	@ObservedObject var buildingContainer: BuildingContainer
	var building: Building {
		buildingContainer.building
	}

	var body: some View {
		let filename = building.image
		let parts = filename.split(separator: ".")
		let imgName = parts.first.map { String($0) } ?? ""

		VStack {
			Image(imgName)
				.resizable()
				.accessibilityLabel("Image of \(building.imageDescription)")
				.aspectRatio(contentMode: .fill)
				.frame(height: 200, alignment: .center)
				.clipped()

			VStack(alignment: .leading) {
				HStack {
					Button(role: .none) {
						// call "Share"
					} label: {
						Image(systemName: "heart")
					}
					.buttonStyle(.bordered)
					.accessibilityLabel("Favorite")

					Button(role: .none) {
						// call "Share"
					} label: {
						Image(systemName: "square.and.arrow.up")
					}
					.buttonStyle(.bordered)
					.accessibilityLabel("Share")

					Spacer()

					if building.isNew {
						Image("newBuilding")
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(maxWidth: 35, maxHeight: 10, alignment: .center)
					}
				}
				VStack(alignment: .leading) {
					Text(building.name)
						.foregroundStyle(Color("Titles"))
						.font(.system(.headline, design: .default))

					HStack {
						Text(building.address)
							.font(.system(.caption, design: .default))
							.foregroundColor(Color.black)

						Spacer()

						Text("00km away")
							.font(.system(.caption, design: .default))
							.foregroundColor(Color.black)
					}
				}
			}
			.padding(.horizontal, 15)
			.padding(.vertical, 10)
		}

		.background(Color("boxBG"))
		.cornerRadius(15)
		.background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.white/*@END_MENU_TOKEN@*/)
	}
}

#Preview {
	ContentView()
}
