
import SwiftUI

struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    private let backgroundColor = Color(red: 240/255, green: 240/255, blue: 247/255)

    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Text("使い方ガイド")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                    .padding(.top, 40)

                VStack(alignment: .leading, spacing: 20) {
                    HelpRow(icon: "hand.point.up.left.fill", text: "ボタンを長押しして、今の気分を記録します。")
                    HelpRow(icon: "calendar", text: "画面右上のカレンダーアイコンから、過去の記録を振り返ることができます。")
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(backgroundColor)
                        .shadow(color: .white.opacity(0.8), radius: 10, x: -5, y: -5)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 5)
                )
                
                Spacer()

                Button(action: {
                    dismiss()
                }) {
                    Text("閉じる")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(backgroundColor)
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: .white, radius: 10, x: -10, y: -10)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }
}

struct HelpRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.gray)
                .frame(width: 40)
            Text(text)
                .foregroundColor(.secondary)
                .lineSpacing(5)
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
