//
//  DataService.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-27.
//

import Foundation
import SwiftUI

// class BuildingDataService {
//	func fetchData(completion: @escaping (Result<[Building], NetworkError>) -> Void) {
//		guard let url = URL(string: "https://raw.githubusercontent.com/shah0150/data/main/countries_data.json") else {
//			completion(.failure(.invalidURL))
//			return
//		}
//
//		URLSession.shared.dataTask(with: url) { data, _, error in
//			DispatchQueue.main.async {
//				if let error = error {
//					print("Network request error: \(error.localizedDescription)")
//					completion(.failure(.requestFailed(error: error)))
//					return
//				}
//
//				guard let data = data else {
//					completion(.failure(.requestFailed(error: nil)))
//					return
//				}
//
//				do {
//					let countries = try JSONDecoder().decode([Building].self, from: data)
//					var regions = [String]()
//					countries.forEach { country in
//
//						if !regions.contains(country.region) {
//							regions.append(country.region)
//						}
//					}
//
//					completion(.success(countries))
//				} catch {
//					print("Decoding error: \(error)")
//					completion(.failure(.decodingError(error: error)))
//				}
//			}
//		}.resume()
//	}
// }
//
// enum NetworkError: Error {
//	case invalidURL
//	case requestFailed(error: Error?)
//	case decodingError(error: Error)
//
//	var localizedDescription: String {
//		switch self {
//		case .invalidURL:
//			return "Invalid URL."
//		case let .requestFailed(error):
//			return "Network request failed: \(error?.localizedDescription ?? "Unknown error")."
//		case let .decodingError(error):
//			return "JSON decoding failed: \(error.localizedDescription)."
//		}
//	}
// }
//
// extension URL {
//	func loadImage(completion: @escaping (Result<Data, Error>) -> Void) {
//		URLSession.shared.dataTask(with: self) { data, _, error in
//			if let error = error {
//				completion(.failure(error))
//				return
//			}
//			if let data = data {
//				completion(.success(data))
//			}
//		}.resume()
//	}
// }
//
// extension View {
//	func errorAlert(isPresented: Binding<Bool>, error: Error) -> some View {
//		alert(isPresented: isPresented) {
//			Alert(
//				title: Text("Error"),
//				message: Text(error.localizedDescription),
//				dismissButton: .default(Text("OK"))
//			)
//		}
//	}
// }
