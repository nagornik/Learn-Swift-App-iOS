//
//  ContentModel.swift
//  Learn App
//
//  Created by Anton Nagornyi on 10.05.2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ContentModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var loggedIn = false
    
    @Published var modules = [Module]()
    @Published var localModules = [Module]()
    
    @Published var currentModule: Module? {
        didSet {
            impact(type: .soft)
        }
    }
    var currentModuleIndex = 0
    
    @Published var currentLesson: Lesson? {
        didSet {
            impact(type: .soft)
        }
    }
    var currentLessonIndex = 0
    
    @Published var currentQuestion: Question? {
        didSet {
            impact(type: .soft)
        }
    }
    var currentQuestionIndex = 0
    
    @Published var codeText = NSAttributedString()
    
    @Published var currentContentSelected: Int?
    @Published var currentTestSelected: Int?
    
    var styleData: Data?
    
    init() {
        getLocalStyles()
    }
    
    // MARK: - Complete the lesson
    func completeLesson(inputLesson: Lesson = Lesson()) {
        guard currentModule != nil else {return}
        let user = UserService.shared.user

        var lesson = inputLesson
        
        if currentLesson != nil {
            lesson = currentLesson!
        }
        
        let finishedLesson = FinishedLesson()
        finishedLesson.module = currentModule!.category
        finishedLesson.lessonNumber = currentModule!.content.lessons.firstIndex(where: {$0.title == lesson.title})!
        finishedLesson.lessonTitle = lesson.title
        
        if user.finishedLessons.contains(where: {$0.lessonTitle == lesson.title}) {
            DispatchQueue.main.async {
                user.finishedLessons.removeAll(where: {$0.lessonTitle == lesson.title})
            }
        } else {
            DispatchQueue.main.async {
                user.finishedLessons.append(finishedLesson)
            }
        }
        
        saveData(writeToDatabase: true)
        
    }
    
    
    // MARK: - Save data
    func saveData(writeToDatabase: Bool = false) {
        
        if let loggedInUser = Auth.auth().currentUser {
            let user = UserService.shared.user
            user.lastModule = currentModuleIndex
            user.lastLesson = currentLessonIndex
            user.lastQuestion = currentQuestionIndex
            
            if writeToDatabase == true {
                let ref = db.collection("users").document(loggedInUser.uid)
                ref.setData(["lastModule" : user.lastModule, "lastLesson" : user.lastLesson, "lastQuestion" : user.lastQuestion, "name" : user.name], merge: true)
                
                let ref2 = ref.collection("finishedLessons")
                ref2.getDocuments(completion: { snapshot, error in
                    guard error == nil && snapshot != nil else { return }
                    for doc in snapshot!.documents {
                        let data = doc.data()
                        ref2.document(data["lessonTitle"] as! String).delete()
                    }
                    for lesson in user.finishedLessons {
                        ref2.document(lesson.lessonTitle).setData(["module" : lesson.module, "lessonNumber" : lesson.lessonNumber, "lessonTitle" : lesson.lessonTitle], merge: true)
                    }
                })
            }
            
        }
        
    }
    
    func getOtherStuff() {
        for item in modules {
            getDatabaseLessons(module: item) {
                self.modules.append(Module())
                self.modules.removeLast()
            }
            getDatabaseQuestions(module: item) {
                self.modules.append(Module())
                self.modules.removeLast()
            }
        }
    }
    
    // MARK: - Login check
    func checkLogin() {
        loggedIn = Auth.auth().currentUser != nil ? true : false
        getDatabaseModules()
        if loggedIn {
            getUserData()
        }
    }
    
    // MARK: - Get user data
    func getUserData() {
        guard Auth.auth().currentUser != nil else { return }
        let firebaseUser = Auth.auth().currentUser
        let db = Firestore.firestore()
        let ref = db.collection("users").document(firebaseUser!.uid)
        ref.getDocument { snapshot, error in
            guard error == nil && snapshot != nil else { return }
            let data = snapshot!.data()
            let user = UserService.shared.user
            user.name = data?["name"] as? String ?? ""
            user.lastModule = data?["lastModule"] as? Int ?? nil
            user.lastLesson = data?["lastLesson"] as? Int ?? nil
            user.lastQuestion = data?["lastQuestion"] as? Int ?? nil
        }
        ref.collection("finishedLessons").getDocuments { snapshot, error in
            guard error == nil && snapshot != nil else { return }
            let user = UserService.shared.user
            for doc in snapshot!.documents {
                let data = doc.data()
                let finishedLesson = FinishedLesson()
                finishedLesson.lessonTitle = data["lessonTitle"] as! String
                finishedLesson.module = data["module"] as! String
                finishedLesson.lessonNumber = data["lessonNumber"] as! Int
                user.finishedLessons.append(finishedLesson)
            }
        }
    }
    
    // MARK: - Get Database Modules
    func getDatabaseModules() {
        getLocalStyles()
        let collection = db.collection("modules")
        collection.getDocuments { snap, error in
            if error == nil && snap != nil {
                var modules = [Module]()
                for doc in snap!.documents {
                    var m = Module()
                    m.id = doc["id"] as! String
                    m.category = doc["category"] as! String
                    let contentMap = doc["content"] as! [String: Any]
                    m.content.id = contentMap["id"] as! String
                    m.content.description = contentMap["description"] as! String
                    m.content.image = contentMap["image"] as! String
                    m.content.time = contentMap["time"] as! String
                    let testMap = doc["test"] as! [String: Any]
                    m.test.id = testMap["id"] as! String
                    m.test.description = testMap["description"] as! String
                    m.test.image = testMap["image"] as! String
                    m.test.time = testMap["time"] as! String
                    modules.append(m)
                }
                DispatchQueue.main.async {
                    self.modules = modules
                    self.getOtherStuff()
                }
            }
        }
    }
    
    
    // MARK: - Get lessons
    func getDatabaseLessons(module: Module, completion: @escaping() -> Void) {
        let collection = db.collection("modules").document(module.id).collection("lessons")
        collection.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                var lessons = [Lesson]()
                for doc in snapshot!.documents {
                    var l = Lesson()
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    lessons.append(l)
                }
                for (index, m) in self.modules.enumerated() {
                    if m.id == module.id {
                        self.modules[index].content.lessons = lessons
                        completion()
                    }
                }
            }
        }
    }
    
    // MARK: - Get questions
    func getDatabaseQuestions(module: Module, completion: @escaping () -> Void) {
        let collection = db.collection("modules").document(module.id).collection("questions")
        collection.getDocuments { snap, err in
            guard snap != nil && err == nil else { return }
            var questions = [Question]()
            for doc in snap!.documents {
                var q = Question()
                q.id = doc["id"] as? String ?? ""
                q.content = doc["content"] as? String ?? ""
                q.correctIndex = doc["correctIndex"] as? Int ?? 0
                q.answers = doc["answers"] as? [String] ?? [String]()
                questions.append(q)
            }
            for (index, q) in self.modules.enumerated() {
                if q.id == module.id {
                    self.modules[index].test.questions = questions
                    completion()
                }
            }
        }
    }
    
    //MARK: - Get local data
    func getLocalStyles() {
        
//        if let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json") {
//            do {
//                let rawData = try Data(contentsOf: jsonUrl)
//                let decodedData = try JSONDecoder().decode([Module].self, from: rawData)
//                self.localModules = decodedData
//                print("yes")
//            } catch {
//                print("no")
//            }
//        }
        
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
    func beginModule(moduleId: String) {
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
        guard currentModule != nil else {
            return
        }
        
        currentQuestionIndex = 0
        
        if lessonId < currentModule!.content.lessons.count {
            currentLessonIndex = lessonId
        } else {
            currentLessonIndex = 0
        }
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(htmlString: currentLesson!.explanation)
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
        guard currentModule != nil else {
            return
        }
        currentLessonIndex += 1
        if currentLessonIndex < currentModule!.content.lessons.count {
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(htmlString: currentLesson!.explanation)
        } else {
            currentLesson = nil
            currentLessonIndex = 0
        }
        saveData()
    }
    
    //MARK: - Set next question
    
    func nextQuestion() {
        guard currentModule != nil else {
            return
        }
        currentQuestionIndex += 1
        if currentQuestionIndex < currentModule!.test.questions.count {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(htmlString: currentQuestion!.content)
        } else {
            currentQuestionIndex = 0
            currentQuestion = nil
        }
        saveData()
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
    
    //MARK: - Test navigation
    func beginTest(moduleId: String) {
        currentLessonIndex = 0
        beginModule(moduleId: moduleId)
        currentQuestionIndex = 0
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(htmlString: currentQuestion!.content)
        }
    }
    
    
}
