//
//  QuestionViewController.swift
//  testMaker
//
//  Created by mac036 on 6/4/24.
//

import UIKit

class QuestionViewController: UIViewController {
    
    var response: String? // JSON 형식의 응답을 저장하는 변수
    var certificateName: String?

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option1Button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let response = response {
                    parseResponse(response)
                }
    }
    
    func parseResponse(_ response: String) {
            guard let data = response.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let question = json["문제"] as? String,
                  let option1 = json["보기1"] as? String,
                  let option2 = json["보기2"] as? String,
                  let option3 = json["보기3"] as? String,
                  let option4 = json["보기4"] as? String,
                  let answer = json["정답"] as? Int else {
                print("Error parsing JSON")
                return
            }
            
            // 문제 라벨에 표시
            questionLabel.text = question
            
            // 보기 버튼에 텍스트 설정
            option1Button.setTitle("1. " + option1, for: .normal)
            option2Button.setTitle("2. " + option2, for: .normal)
            option3Button.setTitle("3. " + option3, for: .normal)
            option4Button.setTitle("4. " + option4, for: .normal)
        }
    
    @IBAction func backBtn(_ sender: Any) {
        guard let stopTest = self.storyboard?.instantiateViewController(identifier: "ViewController") else {return}
        if let window = UIApplication.shared.windows.first{
            window.rootViewController = stopTest
            window.makeKeyAndVisible()
            UIView.transition(with: window, duration: 0.5, animations: nil)
        }
    }
    
    
    @IBAction func answer1Button(_ sender: UIButton) {
        goExplanation(num: 1)
    }
    
    @IBAction func answer2Button(_ sender: UIButton) {
        goExplanation(num: 2)
    }
    
    @IBAction func answer3Button(_ sender: UIButton) {
        goExplanation(num: 3)
    }
    
    @IBAction func answer4Button(_ sender: UIButton) {
        goExplanation(num: 4)
    }
    
    @IBAction func noAnswerbutton(_ sender: UIButton) {
        goExplanation(num: 0)
    }
    

    
    func goExplanation(num:Int){
        guard let questionVC = self.storyboard?.instantiateViewController(identifier: "ExplanationViewController") as? ExplanationViewController else {
            return
        }
        questionVC.response = response
        questionVC.userAnswer = num
        questionVC.certificateName = certificateName
        print("certificateName: " + (certificateName ?? "none"))
        self.present(questionVC, animated: true)
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
