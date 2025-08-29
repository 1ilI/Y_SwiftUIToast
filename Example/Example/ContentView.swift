//
//  ContentView.swift
//  Example
//
//  Created by Yue on 2025/8/27.
//

import SwiftUI
import Y_SwiftUIToast
import Combine

struct ContentView: View {
    @State private var date = Date()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {

                    let string0 = "文本 Toast，持续显示"
                    Button(string0) {
                        Y_Toast.show(text: string0)
                    }

                    let string1 = "文本 Toast，2s 消失"
                    Button(string1) {
                        Y_Toast.show(text: string1, duration: 2)
                    }

                    let string2 = "文本 Toast，5s 消失，点击 toast 移除"
                    Button(string2) {
                        Y_Toast.show(
                            text: string2,
                            canTapRemove: true,
                            duration: 6
                        )
                    }

                    let string3 = "文本 Toast，5s 消失，\n全屏遮盖，不允许移除"
                    Button(string3) {
                        Y_Toast.show(
                            text: string3,
                            isFullScreen: true,
                            duration: 5
                        )
                    }

                    let string4 = "文本 Toast，5s 消失，\n全屏遮盖，点任意移除"
                    Button(string4) {
                        Y_Toast.show(
                            text: string4,
                            isFullScreen: true,
                            canTapRemove: true,
                            duration: 5
                        )
                    }

                    let string5 = "全屏加载中动画，\n不允许移除，5s消失"
                    Button(string5) {
                        Y_Toast.showLoading("12345...", duration: 5)
                    }

                    let string6 = "默认成功系统icon"
                    Button(string6) {
                        Y_Toast.showSuccess(string6)
                    }

                    let string7 = "默认失败系统icon"
                    Button(string7) {
                        Y_Toast.showError(string7)
                    }

                    let string8 = "自定义文字上方控件"
                    Button(string8) {
                        Y_Toast.show(
                            text: string8,
                            customImage: {
                                ProgressView()
                                    .progressViewStyle(
                                        CircularProgressViewStyle(tint: .orange)
                                    )
                            },
                            isFullScreen: true,
                            canTapRemove: true,
                            duration: 2.0
                        )
                    }

                    Button("完全自定义 Alert 内容") {
                        Y_Toast.show(
                            customContent: {
                                VStack {
                                    Text("自定义Toast")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .font(.title)
                                }
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(10)
                            },
                            isFullScreen: true,
                            canTapRemove: true,
                            duration: 5,
                        )
                    }

                    Button("外部自由封装 Alert") {
                        Y_Toast.showMyAlert(date: $date)
                    }
                }
                .padding()
            }
            .navigationTitle("Y_SwiftUIToast 示例")
            .onAppear {
                // 开启输出调试信息
                Y_ToastManager.enableDebugLog()
            }
        }
    }
}

extension Y_Toast {
    public static func showMyAlert(date: Binding<Date>) {
        Y_ToastManager.shared.show(
            customContent: {
                VStack {
                    DatePicker(selection: date, displayedComponents: .date) {
                        Text("选择\n时间").lineLimit(2)
                    }
                }
                .padding()
                .frame(width: 210)
                .background(Color.orange)
                .cornerRadius(10)
            },
            isFullScreen: true,
            canTapRemove: true,
        )
    }
}

#Preview {
    ContentView()
}
