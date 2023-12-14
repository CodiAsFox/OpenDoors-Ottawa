//
//  SavedView.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-12.
//

import SwiftUI

struct SavedView: View {
	var body: some View {
		VStack(alignment: .center) {
			HeaderView
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
	}

	var HeaderView: some View {
		HStack {
			Image("logo")
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(maxWidth: 35, maxHeight: 10, alignment: .center)

			Text(t("Saved"))
				.font(.largeTitle)
				.fontWeight(.bold)
				.foregroundColor(Color.white)
			Spacer()
		}
		.padding()
		.background(Color("Topbar"))
	}
}

#Preview {
	SavedView()
}
