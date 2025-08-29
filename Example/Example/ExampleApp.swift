//
//  ExampleApp.swift
//  Example
//
//  Created by Yue on 2025/8/27.
//

import SwiftUI
import Y_SwiftUIToast

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                // 可在根页增加全局 toast 入口
                .y_addToastOverlay()
        }
    }
}
