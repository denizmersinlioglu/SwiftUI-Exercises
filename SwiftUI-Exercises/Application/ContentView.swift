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

struct Exercise<Content>: View where Content: View {
    // MARK: Properties
    
    let title: String
    let content: Content
    
    // MARK: Render
    
    var body: some View {
        NavigationLink(
            destination: content,
            label: { Text(title) })
    }
}

struct ContentView: View {
    // MARK: Render
    
    var body: some View {
        NavigationView {
            List {
                Exercise(title: "Update View", content: UpdateViewExercise())
                Exercise(title: "Environment", content: EnvironmentExercise())
                Exercise(title: "Layout", content: LayoutExercise())
            }.navigationTitle("Exercises")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
