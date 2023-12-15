//
//  MoreView.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-11.
//

import SwiftUI

struct MoreView: View {
	@State private var languageChanged: Bool = false
	@EnvironmentObject var lang: LanguageManager
	@State private var changeLanguage = false

	var body: some View {
		HStack {
			List {
				Section {
					SelectLanguageView(languageChanged: $languageChanged)
				} header: {
					Text(t("Settings"))
				}
				Section {
					Button(action: { changeLanguage.toggle() }) {
						HStack(alignment: .center) {
							Text(t("Recomend a building"))
							Spacer()
							Image(systemName: "chevron.forward").foregroundColor(/*@START_MENU_TOKEN@*/ .gray/*@END_MENU_TOKEN@*/)
						}
					}
					.sheet(isPresented: $changeLanguage) {
						recomentBuilding
							.presentationDetents([.height(300), .large])
					}
				} header: {
					Text(t("Feedback"))
				}
				Section {
					VStack {
						Image("Author")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 120, alignment: .center)

						Text(t("Developed By:"))
							.font(.system(size: 13))
						Text(t("Taylor Ramirez"))
							.font(.title2)
							.padding(.bottom, 10)
						Text(t("author_bio"))
						Button(t("Learn more about it!")) {
							openWebPage(urlString: "https://mydinosaurlife.com")
						}
						.buttonStyle(.borderedProminent)
					}.padding()

				} header: {
					Text(t("About"))
				}
			}
			.listStyle(.sidebar)
			.listSectionSpacing(.compact)
		}
		.navigationTitle(t("More"))
		.toolbarColorScheme(.dark, for: .navigationBar)
		.toolbarBackground(
			Color("Topbar"),
			for: .navigationBar
		)
		.toolbarBackground(.visible, for: .navigationBar)
	}

	var recomentBuilding: some View {
		Text("AAAA")
	}

	func openWebPage(urlString: String) {
		guard let url = URL(string: urlString) else {
			print("Invalid URL")
			return
		}

		// Check if the device can open the URL
		if UIApplication.shared.canOpenURL(url) {
			UIApplication.shared.open(url)
		} else {
			print("Can't open URL on this device")
		}
	}
}

#Preview {
	ContentView()
		.environmentObject(BuildingsDataStore())
		.environmentObject(LanguageManager())
}
