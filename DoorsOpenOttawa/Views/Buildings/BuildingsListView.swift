//
//  BuildingsListView.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-15.
//

import Lottie
import SwiftUI

struct BuildingsListView: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@Binding var selectedBuilding: Building?
	@Binding var isSearching: Bool
	var onlyFavs = false

	var body: some View {
		VStack {
			if viewModel.ready {
				if viewModel.filteredBuildings.isEmpty && (isSearching || filtersAreApplied()) {
					VStack {
						LottieView(lottieFile: "Sad", loopMode: .playOnce).frame(width: 200, height: 200)
						Text(t("Nothing found."))
							.font(.title)
							.fontWeight(.bold)
							.padding()
					}.frame(width: 350)
				} else if buildingList.isEmpty {
					if onlyFavs == true {
						VStack {
							LottieView(lottieFile: "EmptyAnimation", loopMode: .playOnce).frame(width: 200, height: 200)
							Text(t("Nothing saved."))
								.font(.title)
								.fontWeight(.bold)
								.padding()
						}.frame(width: 350)
					} else {
						VStack {
							LottieView(lottieFile: "NoConnection", loopMode: .playOnce)
								.aspectRatio(contentMode: .fit)
								.frame(width: 230)
							Text(t("Something went wrong"))
								.font(.title)
								.fontWeight(.bold)
								.padding()
						}.frame(width: 350)
					}
				} else {
					List {
						ForEach(buildingList, id: \.id) { building in
							BuildingDetails(buildingContainer: BuildingContainer(building: building)).background {
								NavigationLink(destination: BuildingsView(building: building, selectedBuilding: $selectedBuilding)) {
									EmptyView()
								}.opacity(0)
							}
						}.listRowInsets(EdgeInsets())
					}
					.listStyle(.grouped)
				}

			} else {
				VStack {
					LottieView(lottieFile: "Loading", loopMode: .loop).frame(width: 150, height: 50)
				}
			}
		}
	}

	private var buildingList: [Building] {
		let buildings = isSearching ?
			viewModel.buildings.filter { viewModel.searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(viewModel.searchText) } :
			(viewModel.filteredBuildings.isEmpty ? viewModel.buildings : viewModel.filteredBuildings)

		return onlyFavs ? buildings.filter { $0.isFavorite == true } : buildings
	}

	private func filtersAreApplied() -> Bool {
		return viewModel.isShuttleFilter || viewModel.isPublicWashroomsFilter
	}
}

#Preview {
	NavigationView {
		HomeView()
	}
	.environmentObject(BuildingsDataStore())
	.environmentObject(LanguageManager())
}

struct LottieVie1w: UIViewRepresentable {
	var animationFileName: String
	let loopMode: LottieLoopMode

	func updateUIView(_: UIViewType, context _: Context) {}

	func makeUIView(context _: Context) -> Lottie.LottieAnimationView {
		let animationView = LottieAnimationView(name: animationFileName)
		animationView.loopMode = loopMode
		animationView.contentMode = .center
		animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		animationView.play()
		return animationView
	}
}

struct LottieView: UIViewRepresentable {
	var lottieFile: String
	var loopMode: LottieLoopMode = .playOnce
	var animationView = LottieAnimationView()

	func makeUIView(context _: UIViewRepresentableContext<LottieView>) -> UIView {
		let view = UIView()

		animationView.animation = LottieAnimation.named(lottieFile)
		animationView.contentMode = .scaleAspectFill
		animationView.loopMode = loopMode

		animationView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(animationView)

		NSLayoutConstraint.activate([
			animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
			animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
		])

		return view
	}

	func updateUIView(_: UIView, context _: UIViewRepresentableContext<LottieView>) {
		animationView.play()
	}
}
