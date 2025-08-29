//
//  Y_ToastManager.swift
//  MainUI
//
//  Created by Yue on 2024.
//

import SwiftUI

// MARK: - Toast状态管理器
@MainActor
public class Y_ToastManager: ObservableObject {
    /// 单例实例
    public static let shared = Y_ToastManager()

    /// 是否正在显示Toast
    @Published public var isPresenting = false

    /// 当前Toast配置
    @Published public var currentConfig: Y_ToastConfig?

    /// 当前的自动消失任务
    private var autoHideTask: Task<Void, Never>?

    // MARK: - 私有初始化
    private init() {}

    // MARK: - 显示Toast（基础图像类型）
    public func show(
        text: String,
        image: Y_ToastImageType? = nil,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        duration: TimeInterval = 0.0
    ) {
        if text.isEmpty { return }
        debugLog("显示Toast - text: \(text)")

        // 取消之前的自动隐藏任务（替换模式）
        autoHideTask?.cancel()
        autoHideTask = nil

        // 创建新的配置
        let config = Y_ToastConfig(
            text: text,
            image: image,
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            duration: duration
        )

        // 更新状态并设置自动消失
        showWithConfig(config, duration: duration)
    }
    
    // MARK: - 显示Toast（自定义图像）
    public func show<CustomImage: View>(
        text: String,
        @ViewBuilder customImage: @escaping () -> CustomImage,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        duration: TimeInterval = 0.0
    ) {
        if text.isEmpty { return }
        debugLog("显示自定义图像Toast - text: \(text)")

        // 取消之前的自动隐藏任务（替换模式）
        autoHideTask?.cancel()
        autoHideTask = nil

        // 创建新的配置
        let config = Y_ToastConfig(
            text: text,
            customImage: customImage,
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            duration: duration
        )

        // 更新状态并设置自动消失
        showWithConfig(config, duration: duration)
    }
    
    // MARK: - 显示Toast（完全自定义内容）
    public func show<CustomContent: View>(
        @ViewBuilder customContent: @escaping () -> CustomContent,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        duration: TimeInterval = 0.0
    ) {
        debugLog("显示自定义内容Toast")

        // 取消之前的自动隐藏任务（替换模式）
        autoHideTask?.cancel()
        autoHideTask = nil

        // 创建新的配置
        let config = Y_ToastConfig(
            customContent: customContent,
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            duration: duration
        )

        // 更新状态并设置自动消失
        showWithConfig(config, duration: duration)
    }
    
    // MARK: - 内部通用显示方法
    private func showWithConfig(_ config: Y_ToastConfig, duration: TimeInterval) {
        // 更新状态
        self.currentConfig = config
        self.isPresenting = true

        // 设置自动消失（如果duration > 0）
        if duration > 0 {
            autoHideTask = Task { [weak self] in
                do {
                    // 使用Task.sleep进行延时
                    try await Task.sleep(
                        nanoseconds: UInt64(duration * 1_000_000_000)
                    )

                    // 检查任务是否被取消
                    if !Task.isCancelled {
                        await MainActor.run {
                            self?.dismiss()
                        }
                    }
                } catch {
                    // Task被取消或其他错误，忽略
                    debugLog("自动消失任务被取消或出错: \(error)")
                }
            }
        }
    }

    // MARK: - 手动移除Toast
    public func dismiss() {
        debugLog("移除Toast")
        // 取消自动隐藏任务
        autoHideTask?.cancel()
        autoHideTask = nil

        // 更新状态
        withAnimation(.easeInOut(duration: 0.3)) {
            self.isPresenting = false
        }

        // 延迟清理配置，确保动画完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.currentConfig = nil
        }
    }

    // MARK: - 点击处理
    public func handleTap() {
        guard let config = currentConfig, config.canTapRemove else {
            debugLog("点击但不允许移除")
            return
        }

        debugLog("点击移除Toast")
        dismiss()
    }

    deinit {
        debugLog("🗑️ Y_ToastManager: 正在释放")
        forceCleanupForDeinit()
    }

    private nonisolated func forceCleanupForDeinit() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.autoHideTask?.cancel()
            self.autoHideTask = nil
        }
    }
}

// MARK: - Toast 打印调试
public extension Y_ToastManager {
    /// 静态调试开关 - 控制是否输出调试日志
    nonisolated(unsafe) static var logEnabled: Bool = false
    
    /// 开启调试日志输出
    nonisolated static func enableDebugLog() {
        Y_ToastManager.logEnabled = true
    }
    
    /// 关闭调试日志输出
    nonisolated static func disableDebugLog() {
        Y_ToastManager.logEnabled = false
    }
}

// MARK: - 条件编译的日志函数（全局）
#if DEBUG
internal func debugLog(_ message: String) {
    if Y_ToastManager.logEnabled {
        print("🎯 Y_Toast: \(message)")
    }
}
#else
internal func debugLog(_ message: String) {}
#endif
