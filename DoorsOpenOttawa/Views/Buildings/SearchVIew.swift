//
//  SearchVIew.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-15.
//

import SwiftUI

struct SearchView: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@Binding var isSearching: Bool
	@Binding var isSearchVisible: Bool

	var body: some View {
		if isSearchVisible {
			VStack(alignment: .leading) {
				HStack {
					TextField(t("Building name"), text: $viewModel.searchText)
						.padding(7)
						.background(Color(.systemGray6))
						.foregroundColor(.black)
						.cornerRadius(10)
						.padding(.horizontal)

					Button(action: {
						isSearching = true
					}) {
						Text(t("Search"))
							.fontWeight(.bold)
							.foregroundColor(.white)
					}
					.padding(10)
					.background(Color("Topbar"))
					.cornerRadius(10)
				}
				.padding(.horizontal)
			}
			.padding(.vertical)
			.background(Color("AccentColor"))
		}
	}
}

#Preview {
	NavigationView {
		HomeView()
	}
	.environmentObject(BuildingsDataStore())
	.environmentObject(LanguageManager())
}
