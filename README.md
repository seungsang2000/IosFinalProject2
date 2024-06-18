# 자격증 문제생성 앱

## :bookmark: 목차
+ [개요](#pushpin-개요)
+ [설명](#clipboard-프로젝트-설명)
+ [적용 기술](#screwdriver-적용-기술)
+ [시스템 구조도](#gear-시스템-구조도)
+ [실행화면](#camera-실행화면)

</br>
</br>

## :pushpin: 개요
자격증은 개인의 전문성과 능력을 나타내는 중요한 지표에 해당하며, 대학생에게 있어서 가장 중요한 항목들 중 하나입니다. 저 또한 이러한 자격증을 준비하면서, 자격증을 공부하고 문제 풀이하는 과정에서 부족한 점을 많이 느꼈고 이를 보완하기 위하여 자동으로 원하는 자격증에 대해 시험 문제를 만들어 주는 앱을 만들어 보았습니다.

</br>
</br>


## :clipboard: 프로젝트 설명
+ 사용자가 취득하고자 하는 자격증이름을 입력받아 openai api를 통해 문제로 만든다.
+ openai의 응답을 바탕으로 4지선다형 문제를 제시하고, 사용자가 답변 선택 시 정답여부와 해설을 표시한다.
+ 에러 처리를 지원한다.
  + 자격증 미입력시 에러 메세지
  + 잘못된 자격증 이름 입력시 검증 후 에러 메세지
  + 네크워크 오류 등으로 인한 문제 생성 오류시 초기 화면으로 돌아감.


</br>
</br>


## :camera: 실행화면

<details>
<summary>초기화면</summary>
![1](https://github.com/seungsang2000/IosFinalProject2/assets/74907427/66d6e700-6a17-42f2-b1d2-557865e6f943)

</details>



</br>
</br>

## :screwdriver: 적용 기술
<ul>
  <li>Language: <img src="https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white"></li>
  
  <li> tool: <img src="https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white"></li>
</ul>

</br>
</br>


