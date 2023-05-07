//
//  EngineScene.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 06.05.2023.
//

import Foundation

class EngineScene {
    var animeModel: Model!
    var groundModel: Model!
    var models: [Model] = []
    
    private var deltaTime: Float = 0.0
    
    private let animeModelResourceName: String = "SVS61UZAH4OIDVNG1PSGCOM2D"
    
    init() {
        self.createAnimeModel()
        self.createGroundModel()
    }
    
    func update() {        
        setupTransformForGroundModel()
        setupTransformForAnimeModel()
    }
    
    private func setupTransformForAnimeModel() {
        animeModel.transform.position = [0,1.3,0]
        animeModel.transform.rotation = [0, 0 + Float(-90).degreesToRadians , 0]
    }
    
    private func setupTransformForGroundModel() {
        groundModel.transform.scale = 40
        groundModel.transform.rotation = [0, 0, 0]
    }
    
// MARK: - Logic setup
    
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
