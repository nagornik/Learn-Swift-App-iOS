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
    
    // List of modules
    @Published var modules = [Module]()
    @Published var localModules = [Module]()
    
    //Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    @Published var codeText = NSAttributedString()
    
    @Published var currentContentSelected: Int?
    @Published var currentTestSelected: Int?
    
    var styleData: Data?
    
    init() {
        getLocalStyles()
    }
    
    
    func completeLesson(inputLesson: Lesson = Lesson()) {
//        guard currentLesson != nil else {return}
        let user = UserService.shared.user

        var lesson = inputLesson
        
        if currentLesson != nil {
            lesson = currentLesson!
        }
        
        if user.completedLessons.contains(lesson.title) {
            user.completedLessons.removeAll(where: {$0 == lesson.title})
        } else {
            user.completedLessons.append(lesson.title)
        }
        
        saveData(writeToDatabase: true)
        
    }
    
//    func checkIfLessonCompleted() -> Bool {
//        guard currentLesson != nil else {return false}
//        if UserService.shared.user.completedLessons.contains(currentLesson!.title) {
//            return true
//        } else {
//            return false
//        }
//    }
    
    // MARK: - Save data
    func saveData(writeToDatabase: Bool = false) {
        
        if let loggedInUser = Auth.auth().currentUser {
            let user = UserService.shared.user
            user.lastModule = currentModuleIndex
            user.lastLesson = currentLessonIndex
            user.lastQuestion = currentQuestionIndex
            
            if writeToDatabase == true {
                let ref = db.collection("users").document(loggedInUser.uid)
                ref.setData(["lastModule" : user.lastModule, "lastLesson" : user.lastLesson, "lastQuestion" : user.lastQuestion, "completedLessons" : user.completedLessons, "name" : user.name], merge: true)
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
            user.completedLessons = data?["completedLessons"] as? [String] ?? []
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
//                DispatchQueue.main.async {
                    self.modules = modules
                    self.getOtherStuff()
//                }
            }
        }
    }
    
    // MARK: - Push to Firebase
//    func pushToFirebase(modules: [Module]) {
//
//        let db = Firestore.firestore()
//
//        let cloudModules = db.collection("modules")
//
//        for module in modules {
//
//            let content = module.content
//            let test = module.test
//
//            // Add the module
//            let cloudModule = cloudModules.addDocument(data: [
//                "category": module.category
//            ])
//
//            cloudModule.updateData([
//                "id": cloudModule.documentID,
//                "content": [
//                    "image": content.image,
//                    "time": content.time,
//                    "description": content.description,
//                    "count": content.lessons.count,
//                    "id": cloudModule.documentID
//                ],
//                "test": [
//                    "image": test.image,
//                    "time": test.time,
//                    "description": test.description,
//                    "count": test.questions.count,
//                    "id": cloudModule.documentID
//                ]
//            ])
//
//            // Add the lessons
//            for lesson in content.lessons {
//                let cloudLesson = cloudModule.collection("lessons").addDocument(data: [
//                    "title": lesson.title,
//                    "video": lesson.video,
//                    "duration": lesson.duration,
//                    "explanation": lesson.explanation
//                ])
//
//                cloudLesson.updateData(["id": cloudLesson.documentID])
//            }
//
//            // Add the questions
//            for question in test.questions {
//                let cloudQuestion = cloudModule.collection("questions").addDocument(data: [
//                    "content": question.content,
//                    "correctIndex": question.correctIndex,
//                    "answers": question.answers
//                ])
//
//                cloudQuestion.updateData(["id": cloudQuestion.documentID])
//            }
//
//        }
//
//    }
    
    
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
        if let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let rawData = try Data(contentsOf: jsonUrl)
                let decodedData = try JSONDecoder().decode([Module].self, from: rawData)
                self.localModules = decodedData
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
    
    //MARK: - Get remote data
    
//    func getRemoteData(completion: @escaping () -> Void) {
//        
//        if let url = URL(string: "https://nagornik.github.io/Learn-App/data2.json") {
//            let request = URLRequest(url: url)
//            let dataTask = URLSession.shared.dataTask(with: request) { data, responce, error in
//                guard error == nil else {
//                    return
//                }
//                do {
//                    let onlineData = try JSONDecoder().decode([Module].self, from: data!)
//                    DispatchQueue.main.async {
//                        self.modules += onlineData
//                    }
//                } catch {}
//            }
//            dataTask.resume()
//        }
//    }
    
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
