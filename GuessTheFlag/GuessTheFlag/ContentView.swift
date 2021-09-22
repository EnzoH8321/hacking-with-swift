//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Enzo Herrera on 8/31/21.
//

//Make the other two buttons fade out to 25% opacity.
//And if you tap on the wrong flag? Well, that’s down to you – get creative!

import SwiftUI

struct ContentView: View {
	@State private var showingScore = false
	@State private var scoreTitle = ""
	@State private var userScore = 0
	
	@State var countries = ["estonia", "france", "germany", "ireland", "italy", "nigeria", "poland", "russia", "spain", "uk", "us"].shuffled()
	@State var correctAnswer = Int.random(in: 0...2)
	
	struct ButtonView: View {
		
		@State private var shouldFlip = false
		@State private var shouldOpacity = true
		
		var arrayNumber: Int
		var buttonFunc: (Int) -> ()
		var countriesArray: [String]
		
		var body: some View {
			Button(action: {
				
			
				buttonFunc(arrayNumber)
				shouldOpacity.toggle()
				shouldFlip.toggle()
				
				if (shouldOpacity) {
					shouldOpacity = false
				}
				
				
			}) {
				Image(countriesArray[arrayNumber])
					.renderingMode(.original)
					.clipShape(Capsule())
					.overlay(Capsule().stroke(Color.black, lineWidth: 1))
					.shadow(color: .black, radius: 2)
					.rotation3DEffect(
						shouldFlip ? .degrees(.zero) : .degrees(360),
						axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/,
						anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
						anchorZ: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/,
						perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
					)
					.opacity(shouldOpacity ? 0.5 : 1)
					.animation(/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/)
			}
		}
				
	}
	

	var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
				.edgesIgnoringSafeArea(.all)
			VStack(spacing: 30) {
				VStack {
					Text("Tap the flag of")
						.foregroundColor(.white)
					
					Text(countries[correctAnswer])
						.foregroundColor(.white)
						.font(.largeTitle)
						.fontWeight(.black)
				}
				
				ForEach(0..<3) { element in
					ButtonView(arrayNumber: element, buttonFunc: flagTapped, countriesArray: countries)
				}

				Text("Your score is \(userScore)")
					.foregroundColor(.white)
				Spacer()
			}
		}.alert(isPresented: $showingScore) {
			Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Continue")) {
				self.askQuestion()
			})
		}
	}
	
	func flagTapped(_ number: Int) {
		
		if number == correctAnswer {
			scoreTitle = "Correct"
			userScore += 1
			
		} else {
			scoreTitle = "Wrong, that is the flag of \(countries[number])"
			userScore -= 1
			
		}
		
		showingScore = true

	}
	
	func askQuestion() {
		countries.shuffle()
		correctAnswer = Int.random(in: 0...2)
	}
	
	struct ContentView_Previews: PreviewProvider {
		static var previews: some View {
			ContentView()
		}
	}
}

