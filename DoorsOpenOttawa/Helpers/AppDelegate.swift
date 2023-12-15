//
//  AppDelegate.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-15.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		FirebaseApp.configure()
		Auth.auth().signInAnonymously { _, error in
			if let error = error {
				print("Error signing in anonymously: \(error.localizedDescription)")
				return
			}
		}
		return true
	}
}
