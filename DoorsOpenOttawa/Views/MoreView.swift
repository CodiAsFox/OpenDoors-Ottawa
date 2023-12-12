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

	var body: some View {
		VStack(alignment: .leading) {
			HeaderView
			LanguageView
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	}

	var HeaderView: some View {
		HStack {
			Image("logo")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(maxWidth: 35, maxHeight: 10, alignment: .center)

			Text("More")
				.font(.largeTitle)
				.fontWeight(.bold)
				.foregroundColor(Color.white)
			Spacer()
		}
		.padding()
		.frame(maxWidth: .infinity)
		.background(Color("Topbar"))
	}

	var LanguageView: some View {
		HStack {
			Text(t(for: "language_toggle"))
				.font(.headline)
				.fontWeight(.bold)
				.foregroundColor(Color.black)

			Spacer()

			SelectLanguageView(languageChanged: $languageChanged)

		}.padding()
	}
}

#Preview {
	ContentView()
}
