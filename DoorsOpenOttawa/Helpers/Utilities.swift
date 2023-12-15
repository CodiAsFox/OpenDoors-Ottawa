//
//  Utils.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-15.
//

import Foundation
import SwiftUI

func colorForCategory(_ category: String) -> Color {
	switch category {
	case t("Academic Institutions"): return .yellow
	case t("Business and/or Foundations"): return .blue
	case t("Community and/or Care centres"): return .green
	case t("Embassies"): return .pink
	case t("Functional buildings"): return .red
	case t("Galleries and Theatres"): return .purple
	case t("Government buildings"): return .mint
	case t("Museums, Archives and Historic Sites"): return .orange
	case t("Other"): return .teal
	case t("Religious buildings"): return .brown
	case t("Sports and Leisure buildings"): return .black
	default: print("Error: Unknown color category: \(category)")
		return .gray
	}
}

func iconForCategory(_ category: String) -> String {
	switch category {
	case t("Academic Institutions"): return "academic"
	case t("Business and/or Foundations"): return "business"
	case t("Community and/or Care centres"): return "community"
	case t("Embassies"): return "embassy"
	case t("Functional buildings"): return "utilities"
	case t("Galleries and Theatres"): return "theatre"
	case t("Government buildings"): return "government"
	case t("Museums, Archives and Historic Sites"): return "museum"
	case t("Other"): return "other"
	case t("Religious buildings"): return "religious"
	case t("Sports and Leisure buildings"): return "sports"

	default: print("Error: Unknown icon category: \(category)")
		return "other"
	}
}

struct CategoryView: View {
	var imageName: String
	var text: String

	var body: some View {
		HStack(alignment: .center) {
			Image(imageName)
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(maxWidth: 35, maxHeight: 30, alignment: .center)
				.accessibility(hidden: true)

			Text(t(text))
				.font(.system(.body, design: .default))
		}
	}
}
