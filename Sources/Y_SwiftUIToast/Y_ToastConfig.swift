//
//  Y_ToastConfig.swift
//  MainUI
//
//  Created by Yue on 2024.
//

import SwiftUI

// MARK: - 基础图像类型枚举
public enum Y_ToastImageType: Equatable {
    /// 系统SF Symbol图标
    case systemIcon(String)
    /// 本地图片资源名称
    case imageName(String)
    /// 加载中
    case activityIndicator
}

// MARK: - Toast配置数据结构
public struct Y_ToastConfig: Equatable {
    /// 显示的文本内容（可选，当有customContent时可为空）
    public let text: String?
    
    /// 基础图像类型（可选）
    public let image: Y_ToastImageType?
    
    /// 自定义图像视图构建器（可选）
    public let customImage: (() -> any View)?
    
    /// 完全自定义内容视图构建器（可选，优先级最高）
    public let customContent: (() -> any View)?
    
    /// 是否显示全屏透明遮盖层
    public let isFullScreen: Bool
    
    /// 是否允许点击移除Toast
    public let canTapRemove: Bool
    
    /// 自动消失时间（秒），0.0表示不自动消失
    public let duration: TimeInterval
    
    /// 传统图像的初始化方法
    public init(
        text: String,
        image: Y_ToastImageType? = nil,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        duration: TimeInterval = 0.0
    ) {
        self.text = text
        self.image = image
        self.customImage = nil
        self.customContent = nil
        self.isFullScreen = isFullScreen
        self.canTapRemove = canTapRemove
        self.duration = duration
    }
    
    /// 自定义图像的初始化方法
    public init<CustomImage: View>(
        text: String,
        @ViewBuilder customImage: @escaping () -> CustomImage,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        duration: TimeInterval = 0.0
    ) {
        self.text = text
        self.image = nil
        self.customImage = customImage
        self.customContent = nil
        self.isFullScreen = isFullScreen
        self.canTapRemove = canTapRemove
        self.duration = duration
    }
    
    /// 完全自定义内容的初始化方法
    public init<CustomContent: View>(
        @ViewBuilder customContent: @escaping () -> CustomContent,
        isFullScreen: Bool = false,
        canTapRemove: Bool = false,
        duration: TimeInterval = 0.0
    ) {
        self.text = nil
        self.image = nil
        self.customImage = nil
        self.customContent = customContent
        self.isFullScreen = isFullScreen
        self.canTapRemove = canTapRemove
        self.duration = duration
    }
    
    /// Equatable实现
    public static func == (lhs: Y_ToastConfig, rhs: Y_ToastConfig) -> Bool {
        return lhs.text == rhs.text &&
               lhs.image == rhs.image &&
               lhs.isFullScreen == rhs.isFullScreen &&
               lhs.canTapRemove == rhs.canTapRemove &&
               lhs.duration == rhs.duration &&
               // customImage和customContent无法比较，只检查是否都为nil或都不为nil
               (lhs.customImage == nil) == (rhs.customImage == nil) &&
               (lhs.customContent == nil) == (rhs.customContent == nil)
    }
}

