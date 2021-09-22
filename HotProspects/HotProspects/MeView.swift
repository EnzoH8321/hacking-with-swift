//
//  MeView.swift
//  MeView
//
//  Created by Enzo Herrera on 9/16/21.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MeView: View {

	@State private var name = "Anonymous"
	@State private var emailAddress = "you@yoursite.com"
	//For filter
	let context = CIContext()
	let filter = CIFilter.qrCodeGenerator()

	func generateQRCode(from string: String) -> UIImage {
		//Our input for the method will be a string, but the input for the filter is Data, so we need to convert that.
		let data = Data(string.utf8)
		filter.setValue(data, forKey: "inputMessage")

		if let outputImage = filter.outputImage {
			if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
				return UIImage(cgImage: cgimg)
			}
		}

		//If conversion fails for any reason we’ll send back the “xmark.circle” image from SF Symbols. If that can’t be read – which is theoretically possible because SF Symbols is stringly typed – then we’ll send back an empty UIImage.

		return UIImage(systemName: "xmark.circle") ?? UIImage()
	}


	var body: some View {
		NavigationView {
			VStack {
				TextField("Name", text: $name)
					.textContentType(.name)
					.font(.title)
					.padding(.horizontal)

				TextField("Email address", text: $emailAddress)
					.textContentType(.emailAddress)
					.font(.title)
					.padding([.horizontal, .bottom])
				Image(uiImage: generateQRCode(from: "\(name)\n\(emailAddress)"))
					.interpolation(.none)
					.resizable()
					.scaledToFit()
					.frame(width: 200, height: 200)
				Spacer()
			}
			.navigationBarTitle("Your code")
		}
	}
}

struct MeView_Previews: PreviewProvider {
	static var previews: some View {
		MeView()
	}
}
