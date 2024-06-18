//
//  QuestionListViewController.swift
//  IosFinalProject2
//
//  Created by mac036 on 6/18/24.
//

import UIKit
import FirebaseFirestore

class QuestionListViewController: UIViewController {

    
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var choice4Label: UILabel!
    @IBOutlet weak var choice3Label: UILabel!
    @IBOutlet weak var choice2Label: UILabel!
    @IBOutlet weak var choice1Label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var db: Firestore!
    var questions: [Question] = []
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            db = Firestore.firestore()
            loadQuestions()
            
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuestionCell")
        }
        
        func loadQuestions() {
            db.collection("questions").getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.questions = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let question = data["question"] as? String,
                           let option1 = data["option1"] as? String,
                           let option2 = data["option2"] as? String,
                           let option3 = data["option3"] as? String,
                           let option4 = data["option4"] as? String,
                           let answer = data["answer"] as? Int,
                           let explanation = data["explanation"] as? String,
                           let userAnswer = data["userAnswer"] as? Int {
                            
                            let questionObject = Question(question: question, option1: option1, option2: option2, option3: option3, option4: option4, answer: answer, explanation: explanation, userAnswer: userAnswer)
                            
                            self.questions.append(questionObject)
                        }
                    }
                    self.tableView.reloadData()
                    if self.questions.count > 0 {
                        self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
                        self.tableView(self.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                    }                    
                }
            }
        }
    
    
    
    @IBAction func mainMenuButton(_ sender: UIButton) {
        guard let stopTest = self.storyboard?.instantiateViewController(identifier: "ViewController") else {return}
        if let window = UIApplication.shared.windows.first{
            window.rootViewController = stopTest
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.5, animations: nil)
        }
    }
    

}

extension QuestionListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
        
        let question = questions[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(indexPath.row + 1). \(question.question)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuestion = questions[indexPath.row]
        
        choice1Label.text = selectedQuestion.option1
        choice2Label.text = selectedQuestion.option2
        choice3Label.text = selectedQuestion.option3
        choice4Label.text = selectedQuestion.option4
        explanationLabel.text = selectedQuestion.explanation
        makeAllSkyBlue()
        if(selectedQuestion.answer == selectedQuestion.userAnswer){
            greenMake(num: selectedQuestion.answer)
            
        } else{
            redMake(num: selectedQuestion.userAnswer)
            greenMake(num: selectedQuestion.answer)
        }
    }
    
    func makeAllSkyBlue(){
        choice1Label.backgroundColor = UIColor(red: 90/255, green: 254/255, blue: 255/255, alpha: 1.0)
        choice2Label.backgroundColor = UIColor(red: 90/255, green: 254/255, blue: 255/255, alpha: 1.0)
        choice3Label.backgroundColor = UIColor(red: 90/255, green: 254/255, blue: 255/255, alpha: 1.0)
        choice4Label.backgroundColor = UIColor(red: 90/255, green: 254/255, blue: 255/255, alpha: 1.0)
    }
    
    func greenMake(num: Int){
        if(num == 1){
            choice1Label.backgroundColor = UIColor.green
        } else if(num == 2){
            choice2Label.backgroundColor = UIColor.green
        } else if(num == 3){
            choice3Label.backgroundColor = UIColor.green
        } else if(num == 4){
            choice4Label.backgroundColor = UIColor.green
        }
    }
    
    func redMake(num: Int){
        if(num == 1){
            choice1Label.backgroundColor = UIColor.red
        } else if(num == 2){
            choice2Label.backgroundColor = UIColor.red
        } else if(num == 3){
            choice3Label.backgroundColor = UIColor.red
        } else if(num == 4){
            choice4Label.backgroundColor = UIColor.red
        }
    }
    
}





struct Question {
    let question: String
    let option1: String
    let option2: String
    let option3: String
    let option4: String
    let answer: Int
    let explanation: String
    let userAnswer: Int
    
    init(question: String, option1: String, option2: String, option3: String, option4: String, answer: Int, explanation: String, userAnswer: Int) {
            self.question = question
            self.option1 = option1
            self.option2 = option2
            self.option3 = option3
            self.option4 = option4
            self.answer = answer
            self.explanation = explanation
            self.userAnswer = userAnswer
        }
}

