//
//  TransparentFullScreenCover.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/14/23.
//

import UIKit
import SwiftUI
import Foundation

private struct FullScreenCoverBackgroundRemovalView: UIViewRepresentable {
    
    private class BackgroundRemovalView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .black.withAlphaComponent(0.35)
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        return BackgroundRemovalView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
}

private struct TransparentNonAnimatableFullScreenModifier<FullScreenContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let fullScreenContent: () -> (FullScreenContent)
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { _, _ in
                UIView.setAnimationsEnabled(true)
            }
            .fullScreenCover(isPresented: $isPresented,
                             content: {
                ZStack {
                    fullScreenContent()
                }
                .background(FullScreenCoverBackgroundRemovalView())
                .onAppear {
                    if !UIView.areAnimationsEnabled {
                        UIView.setAnimationsEnabled(true)
                    }
                }
                .onDisappear {
                    if !UIView.areAnimationsEnabled {
                        UIView.setAnimationsEnabled(true)
                    }
                }
            })
    }
}

extension View {
    func transparentNonAnimatingFullScreenCover<Content: View>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View {
        modifier(TransparentNonAnimatableFullScreenModifier(isPresented: isPresented, fullScreenContent: content))
    }
}
