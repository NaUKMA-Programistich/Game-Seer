import SwiftUI

struct ChooserGameScreen: View {
    var body: some View {
        NavigationLink(
            destination: InfoGameScreen(),
            label: {
                Text("Chooser Games Screen")
            }
        )
    }
}

struct ChooserGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChooserGameScreen()
    }
}
