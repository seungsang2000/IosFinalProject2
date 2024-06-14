//
//  ExplanationViewController.swift
//  testMaker
//
//  Created by mac036 on 6/13/24.
//

import UIKit

class ExplanationViewController: UIViewController {
    var response: String? // JSON 형식의 응답을 저장하는 변수
    var userAnswer : Int?
    var certificateName: String?
    
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var choice4Label: UILabel!
    @IBOutlet weak var choice3Label: UILabel!
    @IBOutlet weak var choice2Label: UILabel!
    @IBOutlet weak var choice1Label: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let response = response {
                    parseResponse(response)
                }
        // Do any additional setup after loading the view.
    }
    
    func parseResponse(_ response: String){
        guard let data = response.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let question = json["문제"] as? String,
              let option1 = json["보기1"] as? String,
              let option2 = json["보기2"] as? String,
              let option3 = json["보기3"] as? String,
              let option4 = json["보기4"] as? String,
              let explain = json["해설"] as? String,
              let answer = json["정답"] as? Int else {
            print("Error parsing JSON")
            return
        }
        answerLabel.text="정답: " + String(answer)+"번"
        choice1Label.text="1. " + option1
        choice2Label.text="2. " + option2
        choice3Label.text="3. " + option3
        choice4Label.text="4. " + option4
        explanationLabel.text = explain
        
        
        if(userAnswer == 0){
            congratsLabel.text = "문제 해설"
            greenMake(num: answer)
        } else{
            if(answer == userAnswer){
                congratsLabel.text = "맞았습니다!"
                congratsLabel.textColor = UIColor.green
                greenMake(num: answer)
                
            } else{
                congratsLabel.text = "틀렸습니다"
                congratsLabel.textColor = UIColor.red
                redMake(num: userAnswer!)
                greenMake(num: answer)
            }
        }
        
        
        
        
        
    }
    
    @IBAction func nextQuestion(_ sender: Any) {
        print("Fetching questions for certificate: \(certificateName)")
        
        fetchQuizQuestions(for: certificateName!) { response in
            DispatchQueue.main.async {
                guard let response = response else {
                    return
                }
                guard let questionVC = self.storyboard?.instantiateViewController(identifier: "QuestionViewController") as? QuestionViewController else {
                    print("Failed to instantiate QuestionViewController")
                    return
                }
                // 답변을 전달하여 QuestionViewController에 표시
                questionVC.response = response
                questionVC.certificateName = self.certificateName
                self.present(questionVC, animated: true) {
                    print("Presented QuestionViewController with response: \(response)")
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
    
    func fetchQuizQuestions(for certificateName: String, completion: @escaping (String?) -> Void) {
            let apiKey = Bundle.main.infoDictionary?["APIKey"] as! String // APIKey 가림
            let model = "gpt-4o"

            let endpoint = "https://api.openai.com/v1/chat/completions"

            var request = URLRequest(url: URL(string: endpoint)!)
            request.httpMethod = "POST"
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let body: [String: Any] = [
                "model": model,
                "messages": [
                    [
                        "role": "system",
                        "content": "\(certificateName)을 따기 위한 자격증 시험에서 나올만한 4지 선다 문제를 1개만 내줘 답변은 json 형식으로{\"문제\": ?, \"보기1\": ?, \"보기2\": ?,\"보기3\": ?, \"보기4\": ?, \"정답\":?(Int형), \"해설\":?}으로 보내줘. 단, json안에 줄바꿈 없이 띄어쓰기 한칸만 써"
                    ]
                ],
                "max_tokens": 1000,
                "temperature": 0.7,
                "n": 1
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body)

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("No data received")
                    completion(nil)
                    return
                }

                // 로그로 API 응답 확인
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response JSON: \(responseString)")
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let choices = json["choices"] as? [[String: Any]],
                       let message = choices.first?["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        print("Received question: \(content)")
                        completion(content)
                    } else {
                        print("JSON parsing error: unexpected structure")
                        completion(nil)
                    }
                } catch {
                    print("JSON parsing error: \(error.localizedDescription)")
                    completion(nil)
                }
            }

            task.resume()
        }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
