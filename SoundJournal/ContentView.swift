import SwiftUI
import AVFoundation

// 記録するデータの構造を定義
struct MoodRecord: Identifiable, Codable {
    let id: UUID
    let moodImageName: String
    let date: Date
}

// データを管理するためのクラス（保管庫）
class DataStore: ObservableObject {
    @Published var records: [MoodRecord] = []
    private static let userDefaultsKey = "moodRecords"

    init() {
        loadRecords()
    }

    func addRecord(moodImageName: String) {
        let newRecord = MoodRecord(id: UUID(), moodImageName: moodImageName, date: Date())
        records.append(newRecord)
        saveRecords()
    }

    private func saveRecords() {
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: Self.userDefaultsKey)
        }
    }

    private func loadRecords() {
        if let data = UserDefaults.standard.data(forKey: Self.userDefaultsKey) {
            if let decoded = try? JSONDecoder().decode([MoodRecord].self, from: data) {
                records = decoded
                return
            }
        }
        records = []
    }
}

struct ContentView: View {
    @StateObject private var dataStore = DataStore()
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isShowingHelp = false // HelpView表示用のState
    private let backgroundColor = Color(red: 240/255, green: 240/255, blue: 247/255)
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)

                VStack(spacing: 50) {
                    Text("今の気分は？")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)

                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(1...4, id: \.self) { index in
                            let moodImage = "button\(index)"
                            ImageButton(imageName: moodImage, backgroundColor: backgroundColor)
                                .onLongPressGesture(minimumDuration: 0.5, perform: {
                                    // 長押しが成功した時に記録
                                    dataStore.addRecord(moodImageName: moodImage)
                                }, onPressingChanged: { isPressing in
                                    // ボタンを押し始めた時に音を再生
                                    if isPressing {
                                        playSound(for: index)
                                    }
                                })
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { isShowingHelp = true }) {
                            Image(systemName: "questionmark.circle")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: DecoratedCalendarView(dataStore: dataStore)) {
                            Image(systemName: "calendar")
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingHelp) {
                HelpView()
            }
        }
    }

    private func playSound(for index: Int) {
        let soundName = getSoundName(for: index)
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("音源が見つかりません: \(soundName).mp3")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("再生できませんでした")
        }
    }
    
    private func getSoundName(for index: Int) -> String {
        switch index {
        case 1: return "sparkle"
        case 2: return "drop"
        case 3: return "negative"
        case 4: return "rain"
        default: return "drop"
        }
    }
}

struct ImageButton: View {
    let imageName: String
    let backgroundColor: Color

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: 120, height: 120)
                .shadow(color: .white.opacity(0.8), radius: 10, x: -5, y: -5)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 5, y: 5)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
