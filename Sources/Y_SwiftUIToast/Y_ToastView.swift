//
//  Y_ToastView.swift
//  MainUI
//
//  Created by Yue on 2024.
//

import SwiftUI

// MARK: - Toast内容视图
public struct Y_ToastView: View {
    let config: Y_ToastConfig
    
    public init(config: Y_ToastConfig) {
        self.config = config
    }
    
    public var body: some View {
        if let customContent = config.customContent {
            // 完全自定义内容，不添加任何默认样式
            AnyView(customContent())
        } else {
            // 默认样式的Toast内容
            VStack(spacing: 8) {
                // 图片渲染
                imageView
                
                // 文本内容
                if let text = config.text {
                    Text(text)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.8))
            )
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let imageType = config.image {
            // 上方图片/控件类型
            switch imageType {
                // 系统图标
            case .systemIcon(let systemName):
                Image(systemName: systemName)
                    .font(.system(size: 32))
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                // 用户图标
            case .imageName(let imageName):
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.white)
                // 加载中
            case .activityIndicator:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .frame(width: 32, height: 32)
            }
        } else if let customImage = config.customImage {
            // 自定义图像视图 - 这里确实需要AnyView来进行类型擦除
            AnyView(customImage())
        }
    }
}

// MARK: - Toast覆盖层视图
public struct Y_ToastOverlayView: View {
    @StateObject private var manager = Y_ToastManager.shared
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // 全屏透明遮盖层（仅在isFullScreen=true时显示）
            if manager.isPresenting,
               let config = manager.currentConfig,
               config.isFullScreen {
                Rectangle()
                    .fill(Color.clear)
                    .ignoresSafeArea(.all)
                    .contentShape(Rectangle())  // 明确定义可点击区域
                    .onTapGesture {
                        manager.handleTap()
                    }
            }
            
            // Toast内容
            if manager.isPresenting,
               let config = manager.currentConfig {
                Y_ToastView(config: config)
                    .transition(
                        .asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.8)),
                            removal: .opacity.combined(with: .scale(scale: 0.9))
                        )
                    )
                    .onTapGesture {
                        manager.handleTap()
                    }
                    .zIndex(1001)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: manager.isPresenting)
    }
}

#if DEBUG
struct Y_ToastView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // 纯文本Toast
            Y_ToastView(config: Y_ToastConfig(text: "这是一个提示消息"))
                .previewDisplayName("纯文本Toast")
            
            // 带图标Toast
            Y_ToastView(config: Y_ToastConfig(
                text: "操作成功",
                image: .systemIcon("checkmark.circle.fill")
            ))
            .previewDisplayName("带图标Toast")
            
            // 长文本Toast
            Y_ToastView(config: Y_ToastConfig(
                text: "这是一个很长的提示消息，用来测试多行文本的显示效果"
            ))
            .previewDisplayName("长文本Toast")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .previewLayout(.sizeThatFits)
    }
}
#endif
