//
//  Window + Extension.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.05.2023.
//


// MARK: - iOS

#if os(iOS)

import UIKit

typealias Application = UIApplication

extension Application {
    func isWindowSelected() -> Bool {
        var state = false
        
        for scene in UIApplication.shared.connectedScenes {
            if scene.activationState == .foregroundActive {
                state = true
            } else {
                state = false
            }
        }
        
        return state
    }
}

#endif

// MARK: - macOS

#if os(macOS)

import Cocoa

typealias Application = NSApplication

extension Application {
    func isWindowSelectd() -> Bool {
        var state = false

        if NSApplication.shared.isActive {
            state = true
        }
        
        return state
    }
}

#endif

