//
//  Y_ToastModifier.swift
//  MainUI
//
//  Created by Yue on 2024.
//

import SwiftUI

// MARK: - Toast覆盖层ViewModifier
public struct Y_ToastOverlayModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        ZStack {
            // 原始内容
            content
            
            // Toast覆盖层
            Y_ToastOverlayView()
                .allowsHitTesting(true)
        }
    }
}

// MARK: - View扩展
public extension View {
    /// 添加Y_Toast覆盖层到视图
    /// 应该在应用的根视图级别调用，确保Toast显示在所有内容之上
    /// 
    /// 使用示例：
    /// ```swift
    /// ContentView()
    ///     .y_addToastOverlay()
    /// ```
    func y_addToastOverlay() -> some View {
        self.modifier(Y_ToastOverlayModifier())
    }
}
