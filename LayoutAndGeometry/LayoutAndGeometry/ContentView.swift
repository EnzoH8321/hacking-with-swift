//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Enzo Herrera on 9/20/21.
//

//Rules of SwiftUI
//parent proposes a size for the child
//the child uses that to determine its own size
//parent uses that to position the child appropriately

//Want to know where this view is on the screen? Use the global space.
//Want to know where this view is relative to its parent? Use the local space.
//What to know where this view is relative to some other view? Use a custom space.

import SwiftUI

struct OuterView: View {
	var body: some View {
		VStack {
			Text("Top")
			InnerView()
				.background(Color.green)
			Text("Bottom")
		}
	}
}

struct InnerView: View {
	var body: some View {
		HStack {
			Text("Left")
			GeometryReader { geo in
				Text("Center")
					.background(Color.blue)
					.onTapGesture {
						print("Global center: \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY)")
						print("Custom center: \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY)")
						print("Local center: \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY)")
					}
			}
			.background(Color.orange)
			Text("Right")
		}
	}
}

struct ContentView: View {
	let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

	var body: some View {
		//For example, we could update our Twitter code to use .midAccountAndName, then tell the account and name to use their center position for the guide. To be clear, that means “align these two views so their centers are both on the .midAccountAndName guide”.
		//		HStack(alignment: .midAccountAndName) {
		//			VStack {
		//				Text("@twostraws")
		//					.alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
		//				Image("pepe")
		//					.resizable()
		//					.frame(width: 64, height: 64)
		//			}
		//
		//			VStack {
		//				Text("Full name:")
		//				Text("PAUL HUDSON")
		//					.alignmentGuide(.midAccountAndName) { d in d[VerticalAlignment.center] }
		//					.font(.largeTitle)
		//			}
		//		}

		GeometryReader { fullView in
				  ScrollView(.vertical) {
					  ForEach(0..<50) { index in
						  GeometryReader { geo in
							  Text("Row #\(index)")
								  .font(.title)
								  .frame(width: fullView.size.width)
								  .background(self.colors[index % 7])
								  .rotation3DEffect(.degrees(Double(geo.frame(in: .global).minY) / 5), axis: (x: 0, y: 1, z: 0))
						  }
						  .frame(height: 40)
					  }
				  }
			  }
		  }
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

extension VerticalAlignment {
	//The AlignmentID protocol has only one requirement, which is that the conforming type must provide a static defaultValue(in:) method that accepts a ViewDimensions object and returns a CGFloat specifying how a view should be aligned if it doesn’t have an alignmentGuide() modifier.
	struct MidAccountAndName: AlignmentID {
		static func defaultValue(in d: ViewDimensions) -> CGFloat {
			d[.top]
		}
	}

	static let midAccountAndName = VerticalAlignment(MidAccountAndName.self)
}

