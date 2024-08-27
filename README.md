<div align=center>

  # ToDoRim - 할일 관리, 미리 알림
  
  ![image](https://github.com/SuniDev/ToDoRim-MVC/assets/56523702/979cc449-be04-45d2-9282-33dd8ddd21b2)

  ToDoRim은 감성적인 테마를 더한 **할 일 관리 및 시간·위치 알림 설정 앱** 입니다. <br>
  iOS 개발 1년 차에 처음으로 기획부터 개발, 배포까지 혼자 진행한 앱 프로젝트입니다. <br>
  2019년에 MVC 아키텍처로 개발한 이 프로젝트를 2024년에 버그 수정과 성능 개선 리팩토링 작업을 진행하였습니다. <br><br>

  📆<br>
  개발 : 2019. 08 - 2019. 10<br>
  운영 : 2019. 11 - 2020. 02<br>
  리팩토링 : 2024. 08. 10 - 2024. 08 27
  <br><br>
  [![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FSuniDev%2FToDoRim&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
    
  ### [📱App Store 다운로드 바로가기](https://apps.apple.com/kr/app/todorim-할일관리-미리알림/id1483006749)

<br><br>

</div>

## 📱 화면구성 및 주요기능
### [메인]
- 그룹별 할 일 관리
- 그룹마다 감성적인 그라데이션 배경을 선택 가능
- 그룹별 할 일 완료 상태를 퍼센트로 확인
<image src="https://github.com/user-attachments/assets/3941b26c-933f-46d9-806f-761ea16a0a4b" width=200 />

### [그룹 상세]
- 쉽고 간편한 할 일 관리
- 한 번의 탭으로 할 일 완료 체크
- (+)버튼을 눌러 새 할 일 추가
- 왼쪽으로 스와이프하여 수정 또는 삭제
<image src="https://github.com/user-attachments/assets/43afcbc6-c66f-4376-9dcf-b5e0e30d7cb5" width=200 />

### [그룹 추가]
- 그라데이션 배경으로 나만의 감성적인 테마 그룹 만들기
<image src="https://github.com/user-attachments/assets/201a2e90-bea9-4c5a-b4dd-e0f81647ddab" width=200 />

### [할일 추가]
- 시간 알림 설정 : 매일, 매주, 매월 반복 알림 설정 가능
- 위치 알림 설정 : 특정 장소에 도착하거나 출발할 때 알림 설정 가능 / 반경을 지정하여 세부 설정 가능
<image src="https://github.com/user-attachments/assets/0fd4fe96-0a22-48ef-8dc7-a0f8efdf254f" width=200 />
<image src="https://github.com/user-attachments/assets/18ab7ee9-809a-4e89-8bc0-6c0f9b05c6b2" width=200 />

<br>

## ⚒️ 사용 기술
### 개발환경
<img src="https://img.shields.io/badge/iOS-000000?style=flat-square&logo=apple&logoColor=white"/> <img src="https://img.shields.io/badge/Xcode-147EFB?style=flat-square&logo=xcode&logoColor=white"/>
<br>

### 언어 및 프레임워크
<img src="https://img.shields.io/badge/Swift5-F05138?style=flat-square&logo=swift&logoColor=white"/> <img src="https://img.shields.io/badge/UIKit-2396F3?style=flat-square&logo=uikit&logoColor=white"/>
<br>
- MapKit, CoreLocation, StoreKit, AppTrackingTransparency, MessageUI, SafariServices

### 아키텍처 및 디자인 패턴
- MVC
  <br><br>
![MVC](https://github.com/user-attachments/assets/4f46e6ad-529b-49a1-ba3d-cc95a2e67727)
  <br><br>
- 각 Model/View/Controller의 역할 및 구조
  <br><br>
![View](https://github.com/user-attachments/assets/eb24c526-719e-44f7-a59b-2b9afd7b4d24)
![Controller](https://github.com/user-attachments/assets/f06b2c9c-055b-4e9b-ac82-b9f01d20fee5)
![Model](https://github.com/user-attachments/assets/4f7cdcf7-9254-4836-b136-3510e6f88cea)
<br><br>

### SPM(Swift Package Manager)으로 라이브러리 관리
- Realm: 데이터베이스 관리 시스템을 사용하여 오프라인 데이터 관리 및 동기화 기능 구현.
- Firebase: Google Analytics 및 Crashlytics를 활용하여 앱 모니터링 및 오류 추적 기능 개발. / RemoteConfig를 사용하여 앱 버전 관리 및 동적 구성 지원.
- Hero: 뷰 간 전환 애니메이션을 간소화하고 시각적 전환 효과를 강화하여 사용자 경험 향상.
- GoogleMobileAds: Google AdMob을 사용한 광고 통합을 통해 수익 창출 기능 개발.

### Github 오픈 소스 라이브러리 커스텀
- Geotify: 위치 기반 알림 기능을 구현하여 사용자에게 특정 위치에서 알림을 전송하는 기능 추가.
- TextFieldEffects: 시각적으로 매력적인 텍스트 필드 효과를 적용하여 UI/UX 개선.
- FAPaginationLayout: 커스터마이징된 페이징 레이아웃을 통해 사용자에게 보다 매끄러운 스크롤 경험 제공.

<br>

## 🏠 프로젝트 개발 히스토리
[[iOS/ToyProject] 1인 앱 개발 : 기획부터 배포까지 -ToDoRim](https://sunidev.tistory.com/29)
