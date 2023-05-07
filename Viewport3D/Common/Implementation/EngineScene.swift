//
//  EngineScene.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 06.05.2023.
//

import Foundation

class EngineScene {
    var models: [Model] = []
    var camera: FPSCamera
    
    private var animeModel: Model!
    private var groundModel: Model!
    private let animeModelResourceName: String = "SVS61UZAH4OIDVNG1PSGCOM2D"
    
    init() {
        InputController.shared
        self.camera = FPSCamera()
        self.createAnimeModel()
        self.createGroundModel()
        
        setupCameraTransform(deltaTime: 0)
    }
    
    func update(size: CGSize) {
        self.camera.update(size: size)
    }
    
    func update(deltaTime: Float) {
        camera.update(deltaTime: deltaTime)
       
        setupTransformForGroundModel()
        setupTransformForAnimeModel()
    }
    
    private func setupCameraTransform(deltaTime: Float) {
        self.camera.transform.rotation = [0, sin(deltaTime), 0]
        self.camera.transform.position = [0, 1.5, -3]
    }
    
    private func setupTransformForAnimeModel() {
        animeModel.transform.position = [0,1.3,0]
        animeModel.transform.rotation = [0, 0 + Float(-90).degreesToRadians , 0]
    }
    
    private func setupTransformForGroundModel() {
        groundModel.transform.scale = 40
        groundModel.transform.rotation = [0, 0, 0]
    }
    
// MARK: - Model Creation
    
    private func createGroundModel() {
        self.groundModel = Model(device: Renderer.device, name: "plane")
        self.groundModel?.tiling = UInt32(64)
        models.append(groundModel)
    }
    
    private func createAnimeModel() {
        self.animeModel = Model(device: Renderer.device, name: animeModelResourceName)
        self.animeModel.tiling = UInt32(1)
        models.append(animeModel)
    }
}
