//
//  EngineScene.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 06.05.2023.
//

import Foundation

class MainScene: EngineScene {
    typealias CamerType = FPSCamera
    
    convenience init() {
        self.init(camera: FPSCamera())
    }
    
    override init(camera: EngineScene.CameraType) {
        super.init(camera: camera)
    }
    
    override func setupCameraTransform(deltaTime: Float) {
        guard let camera = self.camera as? FPSCamera else { return }
        //fps camera
        camera.transform.rotation = [0, sin(deltaTime), 0]
        camera.transform.position = [0, 2, -3]
    }
}
