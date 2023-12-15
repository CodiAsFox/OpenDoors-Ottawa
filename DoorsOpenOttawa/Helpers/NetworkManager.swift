//
//  NetworkManager.swift
//  DoorsOpenOttawa
//
//  Created by Tay on 2023-12-15.
//

import Network

class NetworkManager {
	static let shared = NetworkManager()
	private let monitor: NWPathMonitor
	private let queue = DispatchQueue(label: "NetworkMonitor")

	private init() {
		monitor = NWPathMonitor()
	}

	func startMonitoring() {
		monitor.start(queue: queue)
	}

	func stopMonitoring() {
		monitor.cancel()
	}

	var isConnected: Bool {
		monitor.currentPath.status == .satisfied
	}
}
