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
            
#if os(macOS)
            NSEvent.addLocalMonitorForEvents(matching: [.keyUp, .keyDown]) { _ in nil }
#endif
        }
    }
}
