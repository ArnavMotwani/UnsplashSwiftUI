import SwiftUI

public struct UnsplashRandom: View {
    
    //MARK: Parameters
    //Required parameters
    var clientId: String //Unsplash API access key
    
    public enum Orientations: String{
        case landscape = "landscape"
        case portrait = "portrait"
        case squarish = "squarish"
        case none = ""
    }
    
    //Optional parameters
    var query: String // Limit selection to photos matching a search term.
    var orientation: String // Filter by photo orientation. (Valid values:  landscape, portrait, squarish)
    var textColor: Color // Color of the text hotlinked to image on Unsplash
    var textBackgroundColor: Color // Color of text background (opacity set to 0.2 automatically)
    var aspectRatio: ContentMode // aspect ratio's content mode (.fit or .fill)
    
    @StateObject private var api = UnsplashApi()
    
    //MARK: Init
    public init(clientId: String, query: String = "", orientation: Orientations = .none, textColor: Color = .white, textBackgroundColor: Color = .black, aspectRatio: ContentMode = .fit) {
        self.clientId = clientId
        self.query = query
        self.orientation = orientation.rawValue
        
        self.textColor = textColor
        self.textBackgroundColor = textBackgroundColor
        self.aspectRatio = aspectRatio
    }
    
    //MARK: Body
    public var body: some View {
        //MARK: Main View
        VStack {
            switch api.state {
            case .loaded(let unsplashData): // Fetched image data
                AsyncImage(url: URL(string: unsplashData.urls.raw )!) { phase in
                    
                    switch(phase) {
                    case .success(let image): // Loaded image
                        ZStack(alignment: .bottomTrailing) {
                            
                            //MARK: Remote Image
                            image.resizable().aspectRatio(contentMode: aspectRatio)
                            
                            //MARK: Text(Hotlink)
                            HStack(spacing: 0){
                                Text("Photo by ")
                                    .font(.subheadline)
                                    .foregroundColor(textColor)
                                
                                //Link to original image on Unsplash
                                Link(destination: URL(string: unsplashData.links.html )!, label: {
                                    Text(unsplashData.user.name )
                                        .font(.subheadline)
                                        .underline()
                                        .bold()
                                        .foregroundColor(textColor)
                                })
                                
                                Text(" on ")
                                    .font(.subheadline)
                                    .foregroundColor(textColor)
                                
                                //Link to Unsplash
                                Link(destination: URL(string: "https://unsplash.com")!, label: {
                                    Text("Unsplash")
                                        .font(.subheadline)
                                        .underline()
                                        .bold()
                                        .foregroundColor(textColor)
                                })
                            }
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 7.5).foregroundColor(textBackgroundColor).opacity(0.2))
                            .padding(5)
                        }
                        
                    case .failure(let error): // Failed to load image
                        Text(error.localizedDescription)
                        
                    case .empty:
                        ProgressView()
                        
                    @unknown default:
                        EmptyView()
                    }
                }
                
            case .loading: // Fetching image data
                ProgressView()
                
            case .idle:
                EmptyView()
                
            case .failed(let error): // Failed to fetch image data
                Text(error.localizedDescription)
            }
        }
        .task {
            await api.fetchImage(clientId: clientId, query: query, orientation: orientation)
        }
    }
}

