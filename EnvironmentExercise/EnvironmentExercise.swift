//
//  EnvironmentExercise.swift
//  EnvironmentExercise
//
//  Created by Deniz Mersinlioğlu on 29.05.2021.
//

import SwiftUI

// MARK: - Debug

extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}

// MARK: - Environment Usage

struct KnobShape: Shape {
    // MARK: Properties
    
    var pointerSize: CGFloat
    var pointerWidth: CGFloat = 0.1
    
    // MARK: Render
    
    func path(in rect: CGRect) -> Path {
        let pointerHeight = rect.height * pointerSize
        let pointerWidth = rect.width * self.pointerWidth
        let circleRect = rect.insetBy(dx: pointerHeight, dy: pointerHeight)
        return Path { p in
            p.addEllipse(in: circleRect)
            p.addRect(CGRect(x: rect.midX - pointerWidth/2,
                             y: 0, width: pointerWidth,
                             height: pointerHeight + 2))
        }
    }
}

struct Knob: View {
    // MARK: Properties
    
    @Binding var value: Double // should be between 0 and 1
    @Environment(\.knobPointerSize) var envPointerSize // You can get environment value with keyPath
    @Environment(\.knobColor) var envKnobColor
    var pointerSize: CGFloat? = nil // Optionally give a chance to set pointer size in construction.
    var knobColor: Color = .black
    
    // MARK: Render
    
    var body: some View {
        KnobShape(pointerSize: pointerSize ?? envPointerSize)
            .fill(envKnobColor ?? knobColor)
            .rotationEffect(Angle(degrees: value * 330))
            .onTapGesture {
                withAnimation(.default) {
                    self.value = self.value < 0.5 ? 1 : 0
                }
            }
    }
}

struct PointerSizeKey: EnvironmentKey {
    static var defaultValue: CGFloat = 0.1 // Environment Key infers its associated type with this declaration.
}

extension EnvironmentValues {
    // You also create a key path here in order to use with Views .environment method.
    var knobPointerSize: CGFloat {
        get { self[PointerSizeKey.self] }
        set { self[PointerSizeKey.self] = newValue }
    }
}

extension View {
    func knobPointerSize(_ size: CGFloat) -> some View {
        // Takes a keyPath and value to set environment.
        // Environment values and Objects propagates down to the children in the view tree.
        environment(\.knobPointerSize, size)
    }
}

// MARK: - Dependency Injection

/// Dummy class to exercise dependency injection via environment.
/// Environment property will only triggers a re-render when new value type set to another value.
/// In reference type, environment object wont trigger a re-render when a property is changed.
/// So we need to use `.environmentObject(_:)` modifier with an `ObservableObject` and use `@EnvironmentObject` property wrapper.
/// This type of usage will cause re-render when `.objectWillChange` publisher publish some changes/
final class DatabaseConnection: ObservableObject {
    
    // MARK: Properties
    
    @Published var isConnected: Bool = false
    
    // MARK: Actions
    
    func connect() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1,
                                      qos: .userInteractive,
                                      flags: .noQoS) { [weak self] in
            self?.isConnected = true
        }
    }
    
    func disconnect() {
        isConnected = false
    }
}

struct MyView: View {
    // MARK: Properties
    
    // Here will crash if you forgot to insert object to the environment.
    @EnvironmentObject var connection: DatabaseConnection
    
    // MARK: Render
    
    var body: some View {
        VStack {
            Text(connection.isConnected ? "Connected" : "Disconnected")
        }.onAppear(perform: connection.connect)
    }
}

struct DatabaseConnectionView: View {
    // MARK: Render
    
    var body: some View {
        NavigationView {
            MyView()
        }
        .environmentObject(DatabaseConnection()) // Note that type of the object is used as EnvironmentKey
    }
}

// MARK: - Preferences

// All the ancestors of a view can access preferences of their children.
// Multiple children can set different values for same preference key.
// So we need to decide some way to handle multiple values - select + aggregate?
struct MyNavigationTitleKey: PreferenceKey {
    // Give some default value to use if none of children set it.
    static var defaultValue: String? = nil
    
    // The way if handling multiple values for same preference key.
    // Note that previous `value` is inout, means you can modify it.
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = value ?? nextValue() // Get the first non-nil value
    }
}

// Sometimes we may need to collect all the preference values.
struct MyTabItemKey: PreferenceKey {
    static var defaultValue: [String] = []
    
    static func reduce(value: inout [String], nextValue: () -> [String]) {
        value.append(contentsOf: nextValue())
    }
}

extension View {
    func myNavigationTitle(_ title: String) -> some View {
        // Takes a key and value, sets the preference and propagates it to its ancestors.
        preference(key: MyNavigationTitleKey.self, value: title)
    }
}

struct MyNavigationView<Content>: View where Content: View {
    // MARK: Properties
    
    let content: Content
    @State private var title: String? = nil
    
    // MARK: Render

    // Note that, when navigationView first rendered title is nil.
    // When the children gets rendered, they propagates their preference values to the ancestors.
    // Navigation view will react to these changes by setting state and gets re-rendered with new title.
    var body: some View {
        VStack {
            Text(title ?? "").font(.largeTitle)
            // Adds an action when specified preference key value is changed.
            content.onPreferenceChange(MyNavigationTitleKey.self,
                                       perform: { self.title = $0 } )
        }
    }
}

// MARK: - Exercise

struct ColorKey: EnvironmentKey {
    static var defaultValue: Color? = nil
}

extension EnvironmentValues {
    var knobColor: Color? {
        get { self[ColorKey.self] }
        set { self[ColorKey.self] = newValue }
    }
}

extension View {
    func knobColor(_ color: Color?) -> some View {
        environment(\.knobColor, color)
    }
}

public struct EnvironmentExercise: View {
    // MARK: Properties
    
    @State var value: Double = 0.5
    
    // MARK: Life Cycle
    
    public init() {}
    
    // MARK: Render
    
    public var body: some View {
        VStack {
            MyNavigationView(content: Text("My navigation content, I set the title")
                                .myNavigationTitle("Hello world")
                                .background(Color.gray)
            )
            Knob(value: $value)
                .frame(width: 100, height: 100)
                .knobPointerSize(0.3)
            HStack {
                Text("Value")
                Slider(value: $value, in: 0...1)
            }
            HStack {
                DatabaseConnectionView()
                    .frame(width: 200, height: 200)
            }
            Text("Hello World")
                .transformEnvironment(\.font) { dump($0) }
        }
        .knobColor(.red) // Note that this environment value inserted down below all the view tree.
        .padding()
        .environment(\.font, Font.headline)
        .debug()
    }
}
