//
//  UpdateViewExercise.swift
//  SwiftUI-Exercises
//
//  Created by Deniz Mersinlioğlu on 29.05.2021.
//

import SwiftUI

var baseURL = "https://picsum.photos"

struct Photo: Codable, Identifiable {
    let id, author: String
    let width, height: Int
    let url, download_url: String
}

struct ActivityIndicator: UIViewRepresentable {
    
    // MARK: Properties
    // No need to make it @Binding, it is a read-only property.
    var shouldAnimate: Bool
    
    // MARK: Life Cycle
    
    func makeUIView(context: Context) -> some UIActivityIndicatorView {
        UIActivityIndicatorView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        shouldAnimate ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

final class Remote<T>: ObservableObject {
    // MARK: Properties
    
    @Published var result: Result<T, Error>? = nil
    var loading: Bool { value == nil }
    var value: T? { try? result?.get() }
    
    private var alreadyFetched: Bool = false
    
    let url: URL
    let transform: (_ data: Data) -> T?
    
    // MARK: Life Cycle
    
    init(url: URL, transform: @escaping (_ data: Data) -> T?) {
        self.url = url
        self.transform = transform
    }
    
    // MARK: Actions
    
    func load() {
        guard value == nil && !alreadyFetched else { return }
        self.alreadyFetched = true
        print("load \(url)")
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.global(qos: .background).async {
                var transformed: T?
                if let data = data { transformed = self?.transform(data) }
                
                DispatchQueue.main.async {
                    if let transformed = transformed {
                        self?.result = .success(transformed)
                    } else if let error = error{
                        self?.result = .failure(error)
                    }
                }
            }
        }.resume()
    }
    
    func offload() {
        print("offload \(url)")
        self.alreadyFetched = false
        self.result = nil
    }
}

struct AuthorList: View {
    // MARK: Properties
    
    @ObservedObject var loader = Remote(
        url: URL(string: "\(baseURL)/v2/list")!,
        transform: { try? JSONDecoder().decode([Photo].self, from: $0) }
    )
    
    // MARK: Render
    
    var body: some View {
        Group {
            if (loader.loading) {
                ActivityIndicator(shouldAnimate: loader.loading)
                    .onAppear(perform: loader.load)
            } else {
                List {
                    ForEach(loader.value!) { PhotoItem($0) }
                }
            }
        }.navigationTitle("Authors")
    }
}

struct PhotoView: View {
    // MARK: Properties
    
    @ObservedObject var loader: Remote<UIImage>
    
    // MARK: Life Cycle
    
    init(_ url: URL) {
        loader = Remote(
            url: url,
            transform: {UIImage(data: $0)}
        )
    }
    
    // after XCode 12 all the body properties has @ViewBuilder property wrapper built in.
    var body: some View {
        if (loader.loading) {
            ActivityIndicator(shouldAnimate: loader.loading)
                .onAppear(perform: loader.load)
        } else {
            Image(uiImage: loader.value!)
                .resizable()
                .aspectRatio(loader.value!.size, contentMode: .fit)
                .onDisappear(perform: loader.offload)
        }
    }
}

struct PhotoItem: View {
    // MARK: Properties
    
    var photo: Photo
    @ObservedObject var loader: Remote<UIImage>
    
    // MARK: Life Cycle
    
    init(_ photo: Photo) {
        self.photo = photo
        let url = URL(string: photo.download_url)!
        let id = url.pathComponents[2]
        
        self.loader = Remote(
            url: URL(string: "\(baseURL)/id/\(id)/40/40")!,
            transform: { UIImage(data: $0) }
        )
    }
    
    // MARK: Render
    
    var body: some View {
        HStack {
            Group {
                if (loader.loading) {
                    ActivityIndicator(shouldAnimate: loader.loading)
                        .frame(width: 40, height: 40, alignment: .center)
                } else {
                    Image(uiImage: loader.value!)
                        .resizable()
                        .aspectRatio(loader.value!.size, contentMode: .fill)
                        .frame(width: 40, height: 40, alignment: .center)
                        .clipped()
                        .cornerRadius(4)
                    
                }
            }.padding(.all, 5)
            
            NavigationLink(
                destination: PhotoView(URL(string: photo.download_url)!),
                label: { Text(photo.author) }
            )
        }.onAppear(perform: loader.load)
    }
}

public struct UpdateViewExercise: View {
    // MARK: Render
    
    public var body: some View {
        AuthorList()
    }
    
    // MARK: Life Cycle
    
    // Struct default initializer is internal.
    public init() {}
}

// MARK: - Preview

struct UpdateViewExercise_Previews: PreviewProvider {
    static var previews: some View {
        UpdateViewExercise()
    }
}

