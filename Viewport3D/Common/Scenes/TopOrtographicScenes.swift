//
//  TopOrtographicScenes.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.05.2023.
//

import Foundation

class TopOrtographicScenes: EngineScene {
    typealias CameraType = OrthographicCamera
    
    convenience init() {
        self.init(camera: OrthographicCamera())
    }
    
    override init(camera: EngineScene.CameraType) {
        super.init(camera: camera)
    }
    
    override func setupCameraTransform(deltaTime: Float) {
        guard let camera = self.camera as? OrthographicCamera else { return }
        
        camera.transform.position = [0, 0, -3]
        camera.transform.rotation = [Float(90).degreesToRadians, 0, 0]
    }
}
