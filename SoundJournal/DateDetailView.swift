
import SwiftUI

struct DateDetailView: View {
    @ObservedObject var dataStore: DataStore
    let date: Date
    
    @Environment(\.dismiss) var dismiss
    private let backgroundColor = Color(red: 240/255, green: 240/255, blue: 247/255)
    
    // 選択された日付の記録をフィルタリング
    private var recordsForDate: [MoodRecord] {
        dataStore.records.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // ヘッダー（日付と閉じるボタン）
                HStack {
                    Text(date, style: .date)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .padding(12)
                            .background(backgroundColor)
                            .clipShape(Circle())
                            .shadow(color: .white.opacity(0.8), radius: 8, x: -4, y: -4)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 4, y: 4)
                    }
                }
                .padding([.top, .horizontal])
                
                // 記録がなければメッセージを表示
                if recordsForDate.isEmpty {
                    Spacer()
                    Text("この日の記録はありません")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    // 記録のリスト
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(recordsForDate) { record in
                                MoodRecordRow(record: record)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

// 記録の各行を表示するニューモーフィズムカード
struct MoodRecordRow: View {
    let record: MoodRecord
    private let backgroundColor = Color(red: 240/255, green: 240/255, blue: 247/255)

    var body: some View {
        HStack(spacing: 20) {
            Image(record.moodImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
            Text(record.date, style: .time)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Spacer()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(color: .white.opacity(0.8), radius: 8, x: -4, y: -4)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 4, y: 4)
    }
}

// プレビュー用のダミーデータ
struct DateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dataStore = DataStore()
        // ダミーデータを追加
        dataStore.addRecord(moodImageName: "button1")
        dataStore.addRecord(moodImageName: "button3")
        
        return DateDetailView(dataStore: dataStore, date: Date())
    }
}
