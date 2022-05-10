//
//  ContentModel.swift
//  Learn App
//
//  Created by Anton Nagornyi on 10.05.2022.
//

import Foundation

class ContentModel: ObservableObject {
    
    // List of modules
    @Published var modules = [Module]()
    
    //Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    var styleData: Data?
    
    init() {
        
        getLocalData()
        
    }
    
    //MARK: - Get data
    func getLocalData() {
        if let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let rawData = try Data(contentsOf: jsonUrl)
                let decodedData = try JSONDecoder().decode([Module].self, from: rawData)
                self.modules = decodedData
                print("yes")
            } catch {
                print("no")
            }
        }
        
        if let htmlUrl = Bundle.main.url(forResource: "style", withExtension: "html") {
            do {
                let rawStyle = try Data(contentsOf: htmlUrl)
                styleData = rawStyle
                print("style yes")
            } catch {
                print("style no")
            }
        }
        
    }
    
    //MARK: - Module navigation
    func beginModule(moduleId: Int) {
        for index in 0..<modules.count {
            if modules[index].id == moduleId {
                currentModuleIndex = index
                break
            }
        }
        currentModule = modules[currentModuleIndex]
    }
    
    
}
