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
    
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    @Published var lessonDescription = NSAttributedString()
    
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
    
    //MARK: - Lesson navigation
    func beginLesson(lessonId: Int) {
        if lessonId < currentModule!.content.lessons.count {
            currentLessonIndex = lessonId
        } else {
            currentLessonIndex = 0
        }
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        lessonDescription = addStyling(htmlString: currentLesson!.explanation)
    }
    
    //MARK: - Is there a next lesson
    func hasNextLesson() -> Bool {
        if currentLessonIndex + 1 < currentModule?.content.lessons.count ?? 0 {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Set next lesson
    func setNextLesson() {
        currentLessonIndex += 1
        if currentLessonIndex < currentModule!.content.lessons.count {
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            lessonDescription = addStyling(htmlString: currentLesson!.explanation)
        } else {
            currentLesson = nil
            currentLessonIndex = 0
        }
    }
    
    //MARK: - Add styling
    private func addStyling(htmlString: String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        
        if styleData != nil {
            data.append(self.styleData!)
        }
        
        data.append(Data(htmlString.utf8))
        
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
            
        }
        
        
        return resultString
    }
    
}
