//
//  MKPointAnnotation-ObservableObject.swift
//  MKPointAnnotation-ObservableObject
//
//  Created by Enzo Herrera on 9/15/21.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
	public var wrappedTitle: String {
		get {
			self.title ?? "Unknown value"
		}

		set {
			title = newValue
		}
	}

	public var wrappedSubtitle: String {
		get {
			self.subtitle ?? "Unknown value"
		}

		set {
			subtitle = newValue
		}
	}
}
