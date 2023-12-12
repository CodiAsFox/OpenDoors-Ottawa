//
//  LanguageManager.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-11.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
	@Published var lang: String {
		didSet {
			UserDefaults.standard.set(lang, forKey: "SelectedLanguage")
			NotificationCenter.default.post(name: .languageChanged, object: nil)
		}
	}

	init() {
		if let savedLanguage = UserDefaults.standard.string(forKey: "SelectedLanguage") {
			lang = savedLanguage
		} else {
			lang = "en"
		}
	}

	func getLocalizedString(for key: String) -> String {
		let path = Bundle.main.path(forResource: lang, ofType: "lproj")
		let bundle = Bundle(path: path!) ?? Bundle.main
		return bundle.localizedString(forKey: key, value: nil, table: nil)
	}
}

extension Notification.Name {
	static let languageChanged = Notification.Name("languageChanged")
}

func t(_ key: String) -> String {
	let languageManager = LanguageManager()
	return languageManager.getLocalizedString(for: key)
}

struct SelectLanguageView: View {
	@Binding var languageChanged: Bool
	@EnvironmentObject var languageManager: LanguageManager

	let languages: [(name: String, identifier: String)] = [
		("English", "en"),
		("French", "fr-CA"),
	]

	var body: some View {
		Picker("Language", selection: $languageManager.lang) {
			ForEach(languages, id: \.identifier) { language in
				Text(language.name).tag(language.identifier)
			}
		}
		.onChange(of: languageManager.lang) {
			languageChanged.toggle()
		}
		.pickerStyle(SegmentedPickerStyle())
		.frame(width: 200)
	}
}
