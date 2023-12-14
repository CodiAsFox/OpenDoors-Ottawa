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
		VStack(alignment: .center) {
			HeaderView

			VStack(alignment: .center) {
				Button(action: {}) {
					Text(t("Recomend a building"))
						.padding(.vertical, 15)
						.frame(width: 250)
				}
				.buttonStyle(.borderedProminent)

				Button(action: {
					changeLanguage.toggle()
				}) {
					VStack {
						Text(t("Change the language"))
						Text(t("Changer la langue"))
							.font(.system(size: 13))
					}
					.padding(.vertical, 10)
					.frame(width: 250)
				}
				.buttonStyle(.bordered)
				.sheet(isPresented: $changeLanguage) {
					LanguageView
						.presentationDetents([.height(300), .large])
				}
			}
			ScrollView {
				Image("Author")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 120, alignment: .center)
					.padding()
				VStack {
					Text(t("Developed By:"))
						.font(.system(size: 13))
					Text(t("Taylor Ramirez"))
						.font(.title2)
						.padding(.bottom, 10)
					Text(t("author_bio"))

					Button(t("Learn more about it!")) {
						openWebPage(urlString: "https://mydinosaurlife.com")
					}.padding()
				}
				.padding()

				//			List {

				Spacer()
				//			}
				//			.listStyle(.plain)
				//			.background(Color.clear)
				//			.frame(height: 100)
				//
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
		}
	}

	var HeaderView: some View {
		HStack {
			Image("logo")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(maxWidth: 35, maxHeight: 10, alignment: .center)

			Text(t("More"))
				.font(.largeTitle)
				.fontWeight(.bold)
				.foregroundColor(Color.white)
			Spacer()
		}
		.padding()
		.background(Color("Topbar"))
	}

	var LanguageView: some View {
		VStack {
			Text(t("Language/Langue"))
				.font(.caption)
				.fontWeight(.bold)
				.foregroundColor(Color.black)
			Spacer()
			SelectLanguageView(languageChanged: $languageChanged)
		}
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
