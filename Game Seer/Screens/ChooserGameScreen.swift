import SwiftUI
import PhotosUI

struct ChooserGameScreen: View {
    @State private var pickedImage: PhotosPickerItem?
    @State private var chooserImage: Data?
    @State private var isGetInfoOpen: Bool = false

    var body: some View {
        VStack {
            ImageView()
            Spacer()
            HStack {
                PhotoPickerView()
                Spacer()
                GetInfoButton()
            }
        }
        .onChange(of: pickedImage) { image in
            Task {
                guard let data = try? await pickedImage?.loadTransferable(type: Data.self) else { return }
                chooserImage = data
            }
        }
        .padding()
        .sheet(isPresented: $isGetInfoOpen) {
            InfoGameScreen(image: chooserImage)
        }
    }

    @ViewBuilder
    func ImageView() -> some View {
        if let image = chooserImage, let uiImage = UIImage(data: image) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        }
        else {
            Image(systemName: "arrow.down.doc")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50, alignment: .center)
        }
    }

    @ViewBuilder
    func PhotoPickerView() -> some View {
        PhotosPicker(selection: $pickedImage, matching: .images) {
            Text("Choose Image")
        }
    }

    @ViewBuilder
    func GetInfoButton() -> some View {
        Button("Get Info") {
            isGetInfoOpen = true
        }
    }
}

struct ChooserGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChooserGameScreen()
    }
}
