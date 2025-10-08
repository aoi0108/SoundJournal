//
//  SoundJournalApp.swift
//  SoundJournal
//
//  Created by 平松蒼惟 on 2025/10/07.
//

import SwiftUI

@main
struct SoundJournalApp: App {
    @State private var isAppActive = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isAppActive {
                    ContentView()
                } else {
                    SplashScreenView()
                }
            }
            .onAppear {
                // スプラッシュ画面を2.5秒間表示
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.isAppActive = true
                    }
                }
            }
        }
    }
}
