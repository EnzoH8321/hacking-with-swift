//
//  ContentView.swift
//  Instafilter
//
//  Created by Enzo Herrera on 9/12/21.
//
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

//class ImageSaver: NSObject {
//	func writeToPhotoAlbum(image: UIImage) {
//		UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
//
//	}
//
//	@objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
//		print("Save finished!")
//	}
//
//
//}

struct ContentView: View {
	@State private var image: Image?
	@State private var filterIntensity: Double = 0.5
	@State private var filterRadius = 0.5
	@State private var filterScaleKey = 0.5
	@State private var showingImagePicker = false
	@State private var inputImage: UIImage?
	@State private var showingFilterSheet = false
	@State private var currentFilterName = ""
	//For images
	@State private var currentFilter: CIFilter = CIFilter.sepiaTone()
	let context = CIContext()
	//STORE intermediate UIImage
	@State private var processedImage: UIImage?
	//Show Alert
	@State private var showSaveButton: Bool = false
	//Show sliders
	@State private var disMissIntensitySlider = true
	@State private var disMissRadiusSlider = true
	@State private var disMissScaleKeySlider = true

	func loadImage() {
		guard let inputImage = inputImage else {
			return
		}
		let beginImage = CIImage(image: inputImage)
		//Sets current filter to CIImage
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		applyProcessing()
	}

	//Processes Filter
	func applyProcessing() {

		//only sets the intensity key if it’s supported by the current filter.
		let inputKeys = currentFilter.inputKeys
		if inputKeys.contains(kCIInputIntensityKey) {
			currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
			disMissIntensitySlider = false
		}
		if inputKeys.contains(kCIInputRadiusKey) {
			currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
			disMissRadiusSlider = false
		}
		if inputKeys.contains(kCIInputScaleKey) {
			currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey)
			disMissScaleKeySlider = false
		}

		guard let outputImage = currentFilter.outputImage else { return }
		//Turns CIImage to CGIIMAGE
		if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
			let uiImage = UIImage(cgImage: cgimg)
			image = Image(uiImage: uiImage)
			processedImage = uiImage
		}
	}

	// Changes filter then calls loadImage
	func setFilter(_ filter: CIFilter) {
		currentFilter = filter
		loadImage()
	}

	struct GenericSliderStruct {
		var filterValue: Binding<Double>
		var applyFunction: () -> Void

		var value: Binding<Double> {
			get {
				self.filterValue
			}
			set(newValue) {
				self.filterValue = newValue
				applyFunction()
			}
		}
	}

	var body: some View {

		let intensity = GenericSliderStruct(filterValue: $filterIntensity, applyFunction: applyProcessing)

		//		let radius = GenericSliderStruct(in: filterRadius, in: applyProcessing)
		//
		//		let scaleKey = GenericSliderStruct(in: filterScaleKey, in: applyProcessing)

		//		let scaleKey = Binding<Double>(
		//			get: {
		//				self.filterScaleKey
		//			},
		//			set: {
		//				self.filterScaleKey = $0
		//				self.applyProcessing()
		//			}
		//		)
		return NavigationView {
			VStack {
				Text("\(currentFilterName)")
					.font(.title)
				ZStack {
					Rectangle()
						.fill(Color.secondary)

					// display the image
					if image != nil {
						image?
							.resizable()
							.scaledToFit()

					} else {
						Text("Tap to select a picture")
							.foregroundColor(.white)
							.font(.headline)
					}
				}
				.onTapGesture {
					self.showingImagePicker = true				}

				HStack {
					Text("Intensity")
					Slider(value: intensity.value)
						.disabled(disMissIntensitySlider)
				}.padding(.vertical)

				//				HStack {
				//					Text("Radius")
				//					Slider(value: radius.value)
				//						.disabled(disMissRadiusSlider)
				//				}.padding(.vertical)
				//				HStack {
				//					Text("Scale")
				//					Slider(value: scaleKey.value)
				//				}.padding(.vertical)
				//					.disabled(disMissScaleKeySlider)
				HStack {
					Button("Change Filter") {
						self.showingFilterSheet = true
					}

					Spacer()

					Button("Save") {
						guard let processedImage = self.processedImage else {
							return showSaveButton = true

						}

						let imageSaver = ImageSaver()

						imageSaver.successHandler = {
							print("Success!")
						}

						imageSaver.errorHandler = {
							print("Oops: \($0.localizedDescription)")
						}

						imageSaver.writeToPhotoAlbum(image: processedImage)
					}
				}
			}
			.padding([.horizontal, .bottom])
			.navigationBarTitle("Instafilter")
			.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
				ImagePicker(image: self.$inputImage)
			}.actionSheet(isPresented: $showingFilterSheet) {
				ActionSheet(title: Text("Select a filter"), buttons: [
					.default(Text("Crystallize")) {
						self.setFilter(CIFilter.crystallize())
						currentFilterName = "Crystallize"
					},
					.default(Text("Edges")) {
						self.setFilter(CIFilter.edges())
						currentFilterName = "Edges"
					},
					.default(Text("Gaussian Blur")) {
						self.setFilter(CIFilter.gaussianBlur())
						currentFilterName = "Gaussian Blur"
					},
					.default(Text("Pixellate")) {
						self.setFilter(CIFilter.pixellate())
						currentFilterName = "Pixellate"
					},
					.default(Text("Sepia Tone")) {
						self.setFilter(CIFilter.sepiaTone())
						currentFilterName = "Sepia Tone"
					},
					.default(Text("Unsharp Mask")) {
						self.setFilter(CIFilter.unsharpMask())
						currentFilterName = "Unsharp Mask"
					},
					.default(Text("Vignette")) {
						self.setFilter(CIFilter.vignette())
						currentFilterName = "Vignette"
					},
					.cancel()
				])
			}
			.alert(isPresented: $showSaveButton) {
				Alert(title: Text("Error"), message: Text("Please add an image to save"), dismissButton: .default(Text("Got It")))
			}


		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
