//
//  Y_Toast.swift
//  MainUI
//
//  Created by Yue on 2024.
//

import SwiftUI

// MARK: - Y_Toast全局API
@MainActor
public struct Y_Toast {
    // MARK: - 私有初始化
    private init() {}

    // MARK: - 显示Toast
    /// 显示Toast提示
    /// - Parameters:
    ///   - text: 显示的文本内容（必需）
    ///   - image: 文字上方的图片/控件（可选）
    ///   - isFullScreen: 是否显示全屏透明遮盖层，默认false
    ///   - canTapRemove: 是否允许点击移除Toast，默认false
    ///   - disableTransition: 取消转场动画，默认 false，不取消
    ///   - duration: 自动消失时间（秒），默认0.0表示不自动消失
    public static func show(
        text: String,
        image: Y_ToastImageType? = nil,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        disableTransition: Bool = false,
        duration: TimeInterval = 0.0
    ) {
        Y_ToastManager.shared.show(
            text: text,
            image: image,
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration
        )
    }

    // MARK: - 显示Toast（自定义文字上方控件）
    /// 显示带自定义图像的Toast提示
    /// - Parameters:
    ///   - text: 显示的文本内容（必需）
    ///   - customImage: 自定义文字上方视图构建器
    ///   - isFullScreen: 是否显示全屏透明遮盖层，默认false
    ///   - canTapRemove: 是否允许点击移除Toast，默认false
    ///   - disableTransition: 取消转场动画，默认 false，不取消
    ///   - duration: 自动消失时间（秒），默认0.0表示不自动消失
    public static func show<CustomImage: View>(
        text: String,
        @ViewBuilder customImage: @escaping () -> CustomImage,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        disableTransition: Bool = false,
        duration: TimeInterval = 0.0
    ) {
        Y_ToastManager.shared.show(
            text: text,
            customImage: customImage,
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration
        )
    }

    // MARK: - 显示Toast（完全自定义内容）
    /// 显示带完全自定义内容的Toast
    /// - Parameters:
    ///   - customContent: 完全自定义内容视图构建器
    ///   - isFullScreen: 是否显示全屏透明遮盖层，默认false
    ///   - canTapRemove: 是否允许点击移除Toast，默认false
    ///   - disableTransition: 取消转场动画，默认 false，不取消
    ///   - duration: 自动消失时间（秒），默认0.0表示不自动消失
    public static func show<CustomContent: View>(
        @ViewBuilder customContent: @escaping () -> CustomContent,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        disableTransition: Bool = false,
        duration: TimeInterval = 0.0
    ) {
        Y_ToastManager.shared.show(
            customContent: customContent,
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration
        )
    }

    // MARK: - 便捷显示方法

    /// 显示简单的文本Toast
    /// - Parameter text: 显示的文本
    public static func showText(
        _ text: String,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        disableTransition: Bool = false,
        duration: TimeInterval = 2.0
    ) {
        show(
            text: text,
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration
        )
    }

    /// 显示带图标的Toast
    /// - Parameters:
    ///   - text: 显示的文本
    ///   - image: 图像类型
    public static func showImage(
        _ text: String,
        image: Y_ToastImageType,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        disableTransition: Bool = false,
        duration: TimeInterval = 2.0
    ) {
        show(
            text: text,
            image: image,
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration
        )
    }

    /// 显示全屏Toast提示, 2 秒后移除
    /// - Parameters:
    ///   - text: 显示的文本
    ///   - image: 图像类型
    public static func showAutoDismiss(
        _ text: String,
        image: Y_ToastImageType? = nil,
        isFullScreen: Bool = true,
        canTapRemove: Bool = true,
        disableTransition: Bool = false,
        duration: TimeInterval = 2.0,
    ) {
        show(
            text: text,
            image: image,
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration
        )
    }

    /// 显示全屏遮盖的Toast
    /// - Parameters:
    ///   - text: 显示的文本
    ///   - canTapRemove: 是否可以点击移除，默认true
    public static func showFullScreen(
        _ text: String,
        canTapRemove: Bool = true,
        disableTransition: Bool = false,
        duration: TimeInterval = 0.0
    ) {
        show(
            text: text,
            isFullScreen: true,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration,
        )
    }

    /// 显示自动消失的Toast
    /// - Parameters:
    ///   - text: 显示的文本
    ///   - duration: 自动消失时间（秒）
    public static func showTimed(
        _ text: String,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        disableTransition: Bool = false,
        duration: TimeInterval,
    ) {
        show(
            text: text,
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration
        )
    }

    /// 显示成功提示Toast
    /// - Parameter text: 成功信息
    public static func showSuccess(
        _ text: String,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        disableTransition: Bool = false,
        duration: TimeInterval = 2.0
    ) {
        show(
            text: text,
            image: .systemIcon("checkmark.circle.fill"),
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration,
        )
    }

    /// 显示错误提示Toast
    /// - Parameter text: 错误信息
    public static func showError(
        _ text: String,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        disableTransition: Bool = false,
        duration: TimeInterval = 2.0
    ) {
        show(
            text: text,
            image: .systemIcon("xmark.circle.fill"),
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration,
        )
    }

    /// 显示警告提示Toast
    /// - Parameter text: 警告信息
    public static func showWarning(
        _ text: String,
        isFullScreen: Bool = true,
        canTapRemove: Bool = false,
        disableTransition: Bool = false,
        duration: TimeInterval = 2.0
    ) {
        show(
            text: text,
            image: .systemIcon("exclamationmark.triangle.fill"),
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration,
        )
    }

    /// 显示加载中Toast（默认全屏遮盖，不可点击移除）
    /// - Parameter text: 加载文本，默认"加载中..."
    public static func showLoading(
        _ text: String = "加载中...",
        isFullScreen: Bool = true,
        canTapRemove: Bool = false,
        disableTransition: Bool = false,
        duration: TimeInterval = 0.0
    ) {
        show(
            text: text,
            image: .activityIndicator,
            isFullScreen: isFullScreen,
            canTapRemove: canTapRemove,
            disableTransition: disableTransition,
            duration: duration,
        )
    }

    // MARK: - 移除Toast

    /// 手动移除当前显示的Toast
    public static func dismiss() {
        Y_ToastManager.shared.dismiss()
    }

    // MARK: - 状态查询

    /// 当前是否正在显示Toast
    public static var isPresenting: Bool {
        Y_ToastManager.shared.isPresenting
    }

    /// 获取当前Toast配置
    public static var currentConfig: Y_ToastConfig? {
        Y_ToastManager.shared.currentConfig
    }
}
