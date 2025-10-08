import SwiftUI

struct SplashScreenView: View {
    private let backgroundColor = Color(red: 240/255, green: 240/255, blue: 247/255)
    @State private var scale = 0.7
    @State private var opacity = 0.5

    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            Image("icon2")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        self.scale = 1.0
                        self.opacity = 1.0
                    }
                }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
