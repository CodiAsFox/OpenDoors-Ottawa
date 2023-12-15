//
//  FormView.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-15.
//

import FirebaseFirestore
import SwiftUI

struct BuildingRecommendationForm: View {
	@EnvironmentObject var viewModel: BuildingsDataStore
	@Binding var recommendBuilding: Bool
	@Binding var showConfirmation: Bool
	@State private var buildingName: String = ""
	@State private var category: String = ""
	@State private var description: String = ""
	@State private var showAlert = false

	var body: some View {
		VStack {
			HStack {
				Text(t("Recommend a building"))
					.font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
					.foregroundColor(Color.white).padding()
				Spacer()
				Button(action: {
					recommendBuilding = false
				}) { Text(t("Close")).foregroundColor(Color.white).padding() }
			}
			.background(Color("Topbar"))

			Form {
				Section {
					TextField(t("Name of the Building"), text: $buildingName)
				} header: {
					Text("Name of the Building")
				}
				Section {
					Picker(t("Category"), selection: $category) {
						Text(t("All Categories")).tag("")
						ForEach(viewModel.categories.sorted(), id: \.self) { category in
							Text(category).tag(category)
						}
					}

				} header: {
					Text(t("Category"))
				}
				Section {
					TextField(t("Description"), text: $description, axis: .vertical)

				} header: {
					Text(t("Description"))
				}

				Button(t("Submit")) {
					submitRecommendation()
				}
			}
			.alert(isPresented: $showAlert) {
				Alert(
					title: Text("Something went wrong"),
					message: Text("Please try again later"),
					dismissButton: .default(Text("OK"))
				)
			}
		}
	}

	private func submitRecommendation() {
		if NetworkManager.shared.isConnected {
			let db = Firestore.firestore()
			db.collection("recommendations").addDocument(data: [
				"buildingName": buildingName,
				"category": category,
				"description": description,
			]) { error in
				if let error = error {
					print("Error adding document: \(error)")
					showAlert = true
				} else {
					print("Document added successfully")
					showConfirmation = true
					recommendBuilding = false
				}
			}
		} else {
			showAlert = true
		}
	}
}

#Preview {
	NavigationView {
		MoreView()
	}
	.environmentObject(BuildingsDataStore())
	.environmentObject(LanguageManager())
}
