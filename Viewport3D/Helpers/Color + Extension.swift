//
//  Color + Extension.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 24.04.2023.
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#endif

class MultiplatformColor {
    
#if os(iOS)
    public static let blue: Color  =  {
        return Color(uiColor: UIColor.blue)
    }()
#elseif os(macOS)
    public static let blue: Color  =  {
        return Color(nsColor: NSColor.blue)
    }()
#endif
    
#if os(iOS)
    public static let red: Color  =  {
        return Color(uiColor: UIColor.red)
    }()
#elseif os(macOS)
    public static let red: Color  =  {
        return Color(nsColor: NSColor.red)
    }()
#endif
    
#if os(iOS)
    public static let green: Color  =  {
        return Color(uiColor: UIColor.green)
    }()
#elseif os(macOS)
    public static let green: Color  =  {
        return Color(nsColor: NSColor.green)
    }()
#endif
    
}
