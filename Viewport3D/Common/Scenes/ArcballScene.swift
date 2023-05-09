//
//  ArcballScene.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.05.2023.
//

import Foundation

class ArcballScene: EngineScene {
    typealias CamerType = ArcballCamera
    
    convenience init() {
        self.init(camera: ArcballCamera())
    }
    
    override init(camera: EngineScene.CameraType) {
        super.init(camera: camera)
    }
    
    override func setupCameraTransform(deltaTime: Float) {
        guard let camera = self.camera as? ArcballCamera else { return }
        //acrabal camere
        camera.transform.rotation = [0, sin(deltaTime), 0]
        camera.transform.position = [0, 1.5, -2]
        camera.distance = length(camera.transform.position)
        camera.target = [0, 1.2, 0]
    }
}
