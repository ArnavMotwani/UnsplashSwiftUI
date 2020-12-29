import SwiftUI

@available(iOS 14, OSX 10.15, *)
public struct UnsplashRandom: View {
    var clientId: String
    var query: String
    var orientation: String
    @ObservedObject var api : UnsplashAPI
    
    public init(clientId: String, query: String = "", orientation: String = ""){
        self.clientId = clientId
        self.query = query
        self.orientation = orientation
        self.api = UnsplashAPI(clientId: clientId, query: query, orientation: orientation)
    }
    
    public var body: some View {
        Group {
            switch self.api.state {
            case .loading:
                Text("Loading")
            case .loaded(let unsplashData):
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(
                        url: URL(string: unsplashData.urls!.raw!)!,
                        placeholder: {
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image(systemName: "photo")
                                        .imageScale(.large)
                                    Spacer()
                                }
                                Spacer()
                            }
                        },
                        image: { Image(uiImage: $0).resizable() }
                    )
                    .aspectRatio(contentMode: .fit)
                    
                    HStack(spacing: 0){
                        
                        Text("Photo by ")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Link(destination: URL(string: unsplashData.links!.html!)!, label: {
                            Text(unsplashData.user!.name!)
                                .font(.subheadline)
                                .underline()
                                .bold()
                                .foregroundColor(.white)
                        })
                        
                        Text(" on ")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Link(destination: URL(string: "https://unsplash.com")!, label: {
                            Text("Unsplash")
                                .font(.subheadline)
                                .underline()
                                .bold()
                                .foregroundColor(.white)
                        })
                    }
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.black).opacity(0.2))
                    .padding(5)
                }
            }
        }
        .onAppear {
            print("Requesting")
            self.api.request()
        }
    }
}

