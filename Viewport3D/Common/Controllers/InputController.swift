//
//  InputController.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 07.05.2023.
//

import GameController

class InputController {
    static let shared: InputController = InputController()
    
    var keyPressed: Set<GCKeyCode> = []
    var leftMouseDown = false
    var mouseDelta: CGPoint = .zero
    var mouseScroll: CGPoint = .zero
    
    private init() {
        NotificationCenter.default.addObserver(forName: .GCKeyboardDidConnect, object: nil, queue: nil) { notification in
            let keyboard = notification.object as? GCKeyboard
            keyboard?.keyboardInput?.keyChangedHandler = { _,_,keyCode, pressed in
                if pressed {
                    self.keyPressed.insert(keyCode)
                } else {
                    self.keyPressed.remove(keyCode)
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: .GCMouseDidConnect, object: nil, queue: nil) { notification in
            let mouse = notification.object as? GCMouse
            mouse?.mouseInput?.leftButton.pressedChangedHandler = { _,_,pressed in
                self.leftMouseDown = pressed
            }
            
            mouse?.mouseInput?.mouseMovedHandler = { _, deltaX, deltaY in
                self.mouseDelta = CGPoint(x: CGFloat(deltaX), y: CGFloat(deltaY))
            }
            
            mouse?.mouseInput?.scroll.valueChangedHandler = { _, xValue, yValue in
                self.mouseScroll.x = CGFloat(xValue)
                self.mouseScroll.y = CGFloat(yValue)
            }
        }
        
#if os(macOS)
            NSEvent.addLocalMonitorForEvents(matching: [.keyUp, .keyDown]) { _ in nil }
#endif
    }
}
