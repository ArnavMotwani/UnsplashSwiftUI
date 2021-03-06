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
    var orientation: Orientations // Filter by photo orientation. (Valid values:  landscape, portrait, squarish)
    var textColor: Color // Color of the text hotlinked to image on Unsplash
    var textBackgroundColor: Color // Color of text background (opacity set to 0.2 automatically)
    var aspectRatio: ContentMode // aspect ratio's content mode (.fit or .fill)
    
    //Unsplash API data
    @ObservedObject var api : UnsplashAPI
    
    //MARK: Init
    public init(clientId: String, query: String = "", orientation: Orientations = .none, textColor: Color = .white, textBackgroundColor: Color = .black, aspectRatio: ContentMode = .fit){
        self.clientId = clientId
        self.query = query
        self.orientation = orientation

        
        self.textColor = textColor
        self.textBackgroundColor = textBackgroundColor
        self.aspectRatio = aspectRatio
        
        let url = URL(string: "https://api.unsplash.com/")!
        
        guard var components = URLComponents(url: url.appendingPathComponent("photos/random"), resolvingAgainstBaseURL: true)
        else { fatalError("Couldn't append path component")}

        components.queryItems = [URLQueryItem(name: "client_id", value: clientId)]
        if query != "" {components.queryItems?.append(URLQueryItem(name: "query", value: query))}
        if orientation != .none {components.queryItems?.append(URLQueryItem(name: "orientation", value: orientation.rawValue))}
        
        self.api = UnsplashAPI(components: components)
    }
    
    //MARK: Body
    public var body: some View {
        Group {
            //Detecting API status
            switch self.api.state {
            case .loading:
                //Placeholder
                Text("Loading")
            case .loaded(let unsplashData):
                //MARK: Main View
                ZStack(alignment: .bottomTrailing) {
                    //MARK: Remote IMage
                    AsyncImage(
                        url: URL(string: unsplashData.urls!.raw!)!, //Remote image URL
                        placeholder: { //Placerholder while image loads
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image(systemName: "photo")
                                        .imageScale(.large)
                                    Spacer()
                                }
                                Spacer()
                            } //Placeholder ends
                        },
                        image: { Image(uiImage: $0).resizable() }
                    )
                    .aspectRatio(contentMode: aspectRatio)
                    //MARK: Text(Hotlink)
                    HStack(spacing: 0){
                        Text("Photo by ")
                            .font(.subheadline)
                            .foregroundColor(textColor)
                        
                        //Link to original image on Unsplash
                        Link(destination: URL(string: unsplashData.links!.html!)!, label: {
                            Text(unsplashData.user!.name!)
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
            }
        }
        .onAppear {
            self.api.request() //Request to the API
        }
    }
}

