
import SwiftUI

struct InfoGameScreen: View {
    let image: Data?
    
    @State private var game: Game?
    private let service: GamesService = .shared

    var body: some View {
        if game == nil {
            LoadingView()
                .onAppear(perform: processGames)
        }
        else {
            ScrollView {
                GameView(game: game!)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 235/255, green: 230/255, blue: 224/255))
        }
    }

    @ViewBuilder
    func GameView(game: Game) -> some View {
        VStack(spacing: 0) {
            Header(game: game)
            
            DividerWithCustomVerticalPaddings(value: 8)
            
            InfoBlock(title: "Description:", textInfo: game.description)
            
            ScreenshotList(game: game)
             
            DividerWithCustomVerticalPaddings(value: 8)
            
            InfoFieldsBody(game: game)
        }
        .padding()

    }
    
    @ViewBuilder
    func ScreenshotList(game: Game) -> some View{
        TitleText(text: "Game screenshots:")
        ScrollView(.horizontal){
            LazyHStack{
                ForEach(game.screenshots){screenshot in
                    AsyncImage(url: URL(string: screenshot.pathThumbnail)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure(let error):
                            Text("Failed to load image: \(error.localizedDescription)")
                        default:
                            EmptyView()
                        }
                    }
                    .frame(width: 256, height: 144)
                }
            }
        }
    }
    
    @ViewBuilder
    func InfoFieldsBody(game: Game) -> some View{
        TitleText(text: "Supported platforms:")
        ForEach(Array(game.platforms.keys), id: \.self ) { key in
            if(game.platforms[key] == true){
                HStack{
                    Text(key)
                        .font(.body)
                        .foregroundColor(Color.black)
                    Spacer()
                }
            }
        }
        DividerWithCustomVerticalPaddings(value: 8)
        InfoBlock(title: "Supported languages:", textInfo: game.languages)
        GameLinkView(linkName: "For more info visit steam store page", id: game.id)
    }
    
    @ViewBuilder
    func Header(game: Game) -> some View{
        VStack{
            HStack{
                Spacer()
                Text(game.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.black)
                Spacer()
            }
            Image(uiImage: UIImage(data: image ?? Data()) ?? UIImage())
                .resizable()
                .scaledToFit()
                .overlay(
                    Rectangle()
                        .stroke(Color.white, lineWidth: 4)
                )
            HStack {
                Text("Confidence percentage: \(game.percentage)")
                    .font(.body)
                    .foregroundColor(Color.black)
                Spacer()
                
            }
        }
    }
    
    @ViewBuilder
    func InfoBlock(title: String, textInfo: String) -> some View{
        VStack{
            TitleText(text: title)
            HStack{
                Text(textInfo)
                    .font(.body)
                    .foregroundColor(Color.black)
                Spacer()
            }
            DividerWithCustomVerticalPaddings(value: 8)
        }
    }

    @ViewBuilder
    func LoadingView() -> some View {
        ProgressView()
    }
    
    @ViewBuilder
    func DividerWithCustomVerticalPaddings(value: CGFloat) -> some View{
        Divider()
            .padding([.vertical], value)
    }
    
    @ViewBuilder
    func GameLinkView(linkName: String, id:Int) -> some View{
        HStack {
            if let url = URL(string: "https://store.steampowered.com/app/\(id)") {
                Link(linkName, destination: url)
                    .font(.body)
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    func TitleText(text: String) -> some View{
        HStack{
            Text(text)
                .font(.title2)
                .foregroundColor(Color.black)
            Spacer()
        }
    }


    private func processGames() {
        service.processImage(image: image) {self.game = $0 }
    }
}

struct InfoGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        InfoGameScreen(image: Data())
    }
}
