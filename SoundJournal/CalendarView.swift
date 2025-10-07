import SwiftUI

// DateをIdentifiableにするためのラッパー
struct DateWrapper: Identifiable {
    let id = UUID()
    let date: Date
}

// デザインを適用したカレンダー画面のメインビュー
struct DecoratedCalendarView: View {
    @ObservedObject var dataStore: DataStore
    @State private var selectedDate: DateWrapper? // タップされた日付を保持するState
    private let backgroundColor = Color(red: 240/255, green: 240/255, blue: 247/255)

    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                // カレンダービュー本体
                CalendarView(dataStore: dataStore, selectedDate: $selectedDate)
                    .padding()
                    .background(backgroundColor)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 10, y: 10)
                    .shadow(color: .white, radius: 10, x: -10, y: -10)
            }
            .padding()
        }
        .navigationTitle("カレンダー")
        .navigationBarTitleDisplayMode(.inline)
        // selectedDateに値がセットされたら、DateDetailViewをシートとして表示
        .sheet(item: $selectedDate) { wrapper in
            DateDetailView(dataStore: dataStore, date: wrapper.date)
        }
    }
}

// UIKitのUICalendarViewをSwiftUIで使えるようにするためのラッパー
fileprivate struct CalendarView: UIViewRepresentable {
    @ObservedObject var dataStore: DataStore
    @Binding var selectedDate: DateWrapper?
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.availableDateRange = DateInterval(start: .distantPast, end: Date())
        
        // 日付をタップできるように、selectionBehaviorを設定
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = selection
        
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        uiView.reloadDecorations(forDateComponents: [uiView.visibleDateComponents], animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // デリゲートメソッドを処理するためのCoordinator
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        // 日付の装飾を決定する
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            guard let date = dateComponents.date else { return nil }
            let recordsForDate = parent.dataStore.records.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            
            if !recordsForDate.isEmpty {
                return .default()
            }
            
            return nil
        }
        
        // 日付がタップされたときに呼ばれる
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let date = dateComponents?.date else { return }
            let recordsForDate = parent.dataStore.records.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            if !recordsForDate.isEmpty {
                // DateをDateWrapperでラップしてStateを更新
                parent.selectedDate = DateWrapper(date: date)
            }
        }
    }
}