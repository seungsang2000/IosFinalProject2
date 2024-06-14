//
//  ViewController.swift
//  testMaker
//
//  Created by mac036 on 6/4/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var certificateNameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func testStartBtn(_ sender: UIButton) {
        guard let certificateName = certificateNameText.text, !certificateName.isEmpty else {
            let alert = UIAlertController(title: "에러", message: "자격증 이름을 입력해 주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        print("Fetching questions for certificate: \(certificateName)")
        
        fetchQuizQuestions(for: certificateName) { response in
            DispatchQueue.main.async {
                guard let response = response else {
                    return
                }
                
                if response == "null" {
                    let alert = UIAlertController(title: "에러", message: "\"" + certificateName + "\" 이라는 자격증 이름을 찾을 수 없습니다. 자격증 이름을 확인해 주세요", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                guard let questionVC = self.storyboard?.instantiateViewController(identifier: "QuestionViewController") as? QuestionViewController else {
                    print("Failed to instantiate QuestionViewController")
                    return
                }
                // 답변을 전달하여 QuestionViewController에 표시
                questionVC.response = response
                questionVC.certificateName = certificateName
                self.present(questionVC, animated: true) {
                    print("Presented QuestionViewController with response: \(response)")
                }
            }
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
                        "content": "\(certificateName)을 따기 위한 자격증 시험에서 나올만한 4지 선다 문제를 1개만 내줘 답변은 json 형식으로{\"문제\": ?, \"보기1\": ?, \"보기2\": ?,\"보기3\": ?, \"보기4\": ?, \"정답\":?(Int형), \"해설\":?}으로 보내줘. 단, json안에 줄바꿈 없이 띄어쓰기 한칸만 써. 만약 \(certificateName)이 자격증 이름이 아닌것 같다면 null이라는 단어만 보내줘"
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
        
    
    
}

