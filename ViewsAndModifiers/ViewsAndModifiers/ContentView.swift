//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Enzo Herrera on 9/1/21.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		Text("Hello World")
			.blueFunction()
	   }
}

struct makeBlueFont: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.largeTitle)
			.foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
	}
}

extension Text {
	func blueFunction() -> some View {
		self.modifier(makeBlueFont())
	}
}


//struct GridStack<Content: View>: View {
//
//	init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
//		self.rows = rows
//		self.columns = columns
//		self.content = content
//	}
//
//	let rows: Int
//	let columns: Int
//	let content: (Int, Int) -> Content
//
//	var body: some View {
//		VStack {
//			ForEach(0..<rows, id: \.self) { row in
//				HStack {
//					ForEach(0..<self.columns, id: \.self) { column in
//						self.content(row, column)
//					}
//				}
//			}
//		}
//	}
//
//}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}


