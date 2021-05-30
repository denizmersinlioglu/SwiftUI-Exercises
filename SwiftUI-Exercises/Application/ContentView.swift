//
//  ContentView.swift
//  SwiftUI-Exercises
//
//  Created by Deniz Mersinlioğlu on 29.05.2021.
//

import SwiftUI
import UpdateViewExercise
import EnvironmentExercise
import LayoutExercise
import ExerciseCore

// MARK: - Content

struct ContentView: View {
    // MARK: Render
    
    var body: some View {
        NavigationView {
            List {
                ExerciseLink(title: "Update View") { UpdateViewExercise()}
                ExerciseLink(title: "Environment") { EnvironmentExercise()}
                ExerciseLink(title: "Layout") { LayoutExercise()}
            }.navigationTitle("Exercises")
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
