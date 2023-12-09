//
//  ShareManager.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-11-30.
//

import Foundation
import SwiftUI
import UIKit

class ShareManager: NSObject {
	static func captureImage<V: View>(of view: V) -> UIImage? {
		let controller = UIHostingController(rootView: view)
		let view = controller.view

		let targetSize = controller.view.intrinsicContentSize
		view?.bounds = CGRect(origin: .zero, size: targetSize)
		view?.backgroundColor = .clear

		let renderer = UIGraphicsImageRenderer(size: targetSize)
		return renderer.image { _ in
			view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
		}
	}

	static func shareImage(image: UIImage, from controller: UIViewController) {
		let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		controller.present(activityVC, animated: true)
	}
}
