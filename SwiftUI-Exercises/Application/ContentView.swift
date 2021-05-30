//
//  ContentView.swift
//  SwiftUI-Exercises
//
//  Created by Deniz Mersinlioğlu on 29.05.2021.
//

import EnvironmentExercise
import ExerciseCore
import LayoutExercise
import SwiftUI
import UpdateViewExercise

// MARK: - ContentView

struct ContentView: View {

	// MARK: Render

	var body: some View {
		NavigationView {
			List {
				ExerciseLink(title: "Update View") { UpdateViewExercise() }
				ExerciseLink(title: "Environment") { EnvironmentExercise() }
				ExerciseLink(title: "Layout") { LayoutExercise() }
			}.navigationTitle("Exercises")
		}
	}

}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
