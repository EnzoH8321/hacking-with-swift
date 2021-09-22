//
//  ImagePicker.swift
//  ImagePicker
//
//  Created by Enzo Herrera on 9/12/21.
//

//UIKIT AND COORDINATORS GUIDE FOR CORE IMAGE

/*
We created a SwiftUI view that conforms to UIViewControllerRepresentable.
We gave it a makeUIViewController() method that created some sort of UIViewController, which in our example was a UIImagePickerController.
We added a nested Coordinator class to act as a bridge between the UIKit view controller and our SwiftUI view.
We gave that coordinator a didFinishPickingMediaWithInfo method, which will be triggered by UIKit when an image was selected.
Finally, we gave our ImagePicker an @Binding property so that it can send changes back to a parent view.
 */



import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

	@Environment(\.presentationMode) var presentationMode
	@Binding var image: UIImage?

	func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

	}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
		let parent: ImagePicker

		//Make the image variable whatever the user selected
		func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
			if let uiImage = info[.originalImage] as? UIImage {
					parent.image = uiImage
				}

				parent.presentationMode.wrappedValue.dismiss()
		}

		init(_ parent: ImagePicker) {
			self.parent = parent
		}
	}
}
