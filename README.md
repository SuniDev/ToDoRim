<div align="center">

# ToDoRim

**날짜 & 위치 기반 알림을 지원하는 감성적인 할일 관리 앱**

![image](https://github.com/SuniDev/ToDoRim-MVC/assets/56523702/979cc449-be04-45d2-9282-33dd8ddd21b2)

<br/>

![iOS](https://img.shields.io/badge/iOS-16.0+-000000?style=flat-square&logo=apple&logoColor=white)
![Swift](https://img.shields.io/badge/Swift-5.5+-F05138?style=flat-square&logo=swift&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-MVC+Service_Layer-007ACC?style=flat-square)
![App Store](https://img.shields.io/badge/App_Store-Released-0D96F6?style=flat-square&logo=app-store&logoColor=white)
![Rating](https://img.shields.io/badge/Rating-⭐_4.6/5.0-FFD700?style=flat-square)
![Downloads](https://img.shields.io/badge/Downloads-12.5K+-34C759?style=flat-square)

<br/>

[<img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" height="50">](https://apps.apple.com/kr/app/todorim-%ED%95%A0%EC%9D%BC%EA%B4%80%EB%A6%AC-%EB%AF%B8%EB%A6%AC%EC%95%8C%EB%A6%BC/id1483006749)

</div>

<br/>

## 📊 Achievements & Impact

| **App Store 평점** | **누적 다운로드** | **누적 세션** | **앱스토어 노출** |
|:---:|:---:|:---:|:---:|
| ⭐ **4.6 / 5.0** | **12.5K+** | **113K+** | **633K+** |
| 47개 평가 | 100% Organic | 1인당 평균 9회+ | ASO 최적화 |

<br/>

**🚀 Growth Highlights**

- **Viral Peak (2020.09)**: 전월 대비 약 2배 성장, 월간 다운로드 **1,200건** 및 일간 활성 기기 **640대** 달성
- **PMF 검증**: 출시 초기부터 월 평균 **700명+** 신규 유저 유입으로 시장 수요 확인
- **안정적 운영**: 1만+ 유저 베이스 대상 앱 안정성 관리 및 크래시율 모니터링

> *"단순하면서 직관적인 앱. 매일 사용하고 있습니다!"* — App Store Review

<br/>

## 📖 About

**ToDoRim**은 iOS 개발 1년 차에 기획부터 개발, 배포까지 1인으로 완수한 프로젝트입니다.

그룹별 할일 관리에 **감성적인 그라데이션 테마**를 더하고, **날짜/위치 기반 알림**으로 일상의 리마인더를 놓치지 않도록 설계했습니다. 2019년 최초 출시 후, 2024년에 Realm 스키마 마이그레이션과 성능 개선을 포함한 대규모 리팩토링을 진행하여 현재까지 운영 중입니다.

| 개발 | 리팩토링 | 운영 |
|:---:|:---:|:---:|
| 2019.08 - 2019.10 | 2024.08 | 2019.11 ~ 현재 |

<br/>

## 📱 Screenshots

| 메인 화면 | 그룹 상세 | 그룹 추가 |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/3941b26c-933f-46d9-806f-761ea16a0a4b" width="200"/> | <img src="https://github.com/user-attachments/assets/43afcbc6-c66f-4376-9dcf-b5e0e30d7cb5" width="200"/> | <img src="https://github.com/user-attachments/assets/201a2e90-bea9-4c5a-b4dd-e0f81647ddab" width="200"/> |
| 그룹별 완료율 시각화 | 스와이프로 수정/삭제 | 그라데이션 테마 선택 |

| 시간 알림 설정 | 위치 알림 설정 | 설정 |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/0fd4fe96-0a22-48ef-8dc7-a0f8efdf254f" width="200"/> | <img src="https://github.com/user-attachments/assets/18ab7ee9-809a-4e89-8bc0-6c0f9b05c6b2" width="200"/> | <img src="https://github.com/user-attachments/assets/d34a68bf-9f88-4a30-8259-9626ca21dc4e" width="200"/> |
| 매일/매주/매월 반복 | Geofencing 반경 설정 | 프리미엄 구독 |

<br/>

## ✨ Key Features

### 🔔 정교한 로컬 알림 시스템

**날짜 알림**과 **위치 알림(Geofencing)**을 동시에 지원하는 하이브리드 알림 시스템

- `UserNotifications` + `UNCalendarNotificationTrigger`로 4가지 반복 모드 구현 (일회성, 매일, 매주, 매월)
- `CoreLocation`의 `CLCircularRegion`을 활용한 반경 기반 위치 알림
- 진입(Entry) / 이탈(Exit) 조건 분기 및 재진입 시 반복 알림 지원
- 할일 수정/삭제 시 알림 자동 정리 및 재등록 (`identifier` 기반 생명주기 관리)

### 💾 Realm 기반 데이터 영속화 & 마이그레이션

Schema Version 3까지 관리되는 안정적인 로컬 DB 환경

- 레거시 모델 → 신규 모델 자동 변환 마이그레이션 로직
- 중첩 List 구조를 정규화된 1:N 관계(FK 방식)로 개선하여 쿼리 성능 향상
- 기존 사용자의 불편 없는 데이터 전환 지원

### 🎨 시각화 & 커스터마이징 UI

사용자 경험을 고려한 인터랙티브 UI/UX

- `UIProgressView`를 활용한 그룹별 할일 완료율 시각화
- `Hero` 라이브러리 기반 Shared Element Transition 애니메이션
- `MadokaTextField` 커스텀 입력 필드 (`@IBDesignable` 활용)

### 📈 데이터 기반 운영 & 수익화

Firebase를 활용한 체계적인 앱 운영

- **60개+** 커스텀 이벤트 정의로 사용자 행동 추적 (Firebase Analytics)
- Remote Config를 통한 강제/권장 업데이트 원격 제어
- Google AdMob 전면 광고 + IAP 광고 제거 모델

<br/>

## 🛠 Tech Stack

| 구분 | 기술 | 상세 |
|:---|:---|:---|
| **Language** | **Swift 5.5+** | 100% Swift (Objective-C 없음) |
| **Minimum Target** | **iOS 16.0+** | - |
| **Architecture** | **MVC + Service-Storage Layer** | ViewController 비대화 방지를 위한 계층 분리 |
| **Database** | **RealmSwift** | Schema Version 3, 마이그레이션 지원 |
| **Backend** | **Firebase** | Analytics, Remote Config, Crashlytics |
| **Monetization** | **Google-Mobile-Ads-SDK** | 전면 광고(Interstitial) |
| **UI/Animation** | **Hero**, TextFieldEffects | Shared Element Transition |
| **Native Frameworks** | UserNotifications, CoreLocation, StoreKit | 알림, 위치, IAP |

<br/>

## 🏗 Architecture & Design

### Service-Storage 패턴 기반 MVC

ViewController의 비대화를 방지하기 위해 비즈니스 로직과 데이터 접근 계층을 분리했습니다.

```
┌─────────────────────────────────────────────────────────────┐
│                      ViewController                         │
│                  (UI 이벤트 처리 & 화면 전환)                    │
└─────────────────────────┬───────────────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          ▼                               ▼
┌─────────────────────┐       ┌─────────────────────┐
│    Service Layer    │       │    Manager Layer    │
│     (비즈니스 로직)    │       │     (앱 전역 기능)     │
│                     │       │                     │
│ • HomeService       │       │ • NotificationMgr   │
│ • WriteTodoService  │       │ • AnalyticsManager  │
└─────────┬───────────┘       │ • RealmManager      │
          │                   └─────────────────────┘
          ▼
┌─────────────────────┐
│    Storage Layer    │
│   (DB CRUD 추상화)    │
│                     │
│ • GroupStorage      │
│ • TodoStorage       │
└─────────────────────┘
```

### 프로젝트 구조

```
Todorim/
├── App/                    # AppDelegate, SceneDelegate
├── Models/                 # Group, Todo, Legacy Models
├── Services/               # 비즈니스 로직 (HomeService, WriteTodoService)
├── Storage/                # DB 접근 계층 (GroupStorage, TodoStorage)
├── Managers/               # 싱글톤 매니저 (Realm, Analytics, Notification)
├── ViewControllers/
│   ├── Home/               # 메인 화면
│   ├── Write/              # 그룹/할일 작성
│   ├── Detail/             # 그룹 상세
│   └── SearchLocation/     # 위치 검색
├── Views/
│   ├── Cells/              # 테이블/컬렉션 셀
│   └── CustomViews/        # 커스텀 UI 컴포넌트
├── Utils/                  # 유틸리티, 상수, 확장
└── Resources/              # 스토리보드, 에셋, 다국어
```

<br/>

## 🔧 Trouble Shooting & Challenges

### 1. Realm 스키마 마이그레이션 - 중첩 구조 정규화

**Situation**  
초기 버전의 `DataGroup` 모델 내부에 할일 리스트가 중첩되어 있어 데이터 쿼리 유연성이 저하되고, 특정 할일만 조회/수정하는 작업이 비효율적이었습니다.

**Task**  
기존 사용자의 데이터 손실 없이, 중첩 구조를 정규화된 1:N 관계로 마이그레이션해야 했습니다.

**Action**  
`RealmManager`에서 `enumerateObjects`를 활용한 마이그레이션 블록을 구현하여, 구 모델 데이터를 순회하며 신규 모델로 매핑했습니다.

```swift
migration.enumerateObjects(ofType: "DataGroup") { oldObject, _ in
    guard let oldObject = oldObject,
          let groupId = oldObject["groupNo"] as? Int,
          let tasks = oldObject["taskList"] as? List<MigrationObject> else { return }
    
    // 신규 Group 모델 생성
    let newGroup = migration.create("Group")
    newGroup["groupId"] = groupId
    newGroup["title"] = oldObject["title"]
    // 색상 인덱스 → Hex String 변환
    newGroup["colorHex"] = convertColorIndexToHex(oldObject["appColorNo"] as? Int ?? 0)
    
    // 중첩된 Task → 독립적인 Todo 테이블로 분리
    for task in tasks {
        let newTodo = migration.create("Todo")
        newTodo["todoId"] = task["taskNo"]
        newTodo["groupId"] = groupId  // FK 설정
        newTodo["title"] = task["taskTitle"]
        newTodo["isCompleted"] = task["isDone"]
    }
}
```

**Result**  
- 쿼리 성능 개선: 특정 그룹의 할일만 필터링하는 쿼리 속도 향상
- 데이터 무결성 강화: FK 기반 관계로 데이터 일관성 보장
- 기존 사용자 데이터 100% 보존

---

### 2. 알림 권한 상태별 분기 처리 UX 최적화

**Situation**  
사용자가 알림을 설정하려 할 때, 시스템 권한 상태(`notDetermined`, `authorized`, `denied`)에 따라 다른 대응이 필요했습니다.

**Task**  
권한 상태에 따른 명확한 UX 플로우를 구현하고, 권한 거부 시에도 자연스럽게 설정으로 유도해야 했습니다.

**Action**  
`WriteTodoService`에서 권한 상태별 분기 처리를 구현하고, Analytics로 사용자 행동을 추적했습니다.

```swift
func checkNotificationPermission(completion: @escaping (PermissionStatus) -> Void) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        DispatchQueue.main.async {
            switch settings.authorizationStatus {
            case .notDetermined:
                // 최초 요청 → 시스템 권한 팝업
                self.requestNotificationPermission(completion: completion)
            case .authorized:
                completion(.authorized)
            case .denied:
                // 거부 상태 → 설정 페이지 유도 Alert
                completion(.deniedWithSettingsGuide)
                AnalyticsManager.shared.log(.permissionDenied)
            default:
                completion(.unknown)
            }
        }
    }
}
```

**Result**  
- 권한 요청 수락률 추적 가능 (`TAP_PERMISSION_PUSH_YES/NO` 이벤트)
- 거부 사용자도 설정 → 앱 → 알림 경로로 자연스럽게 유도
- 알림 관련 CS 문의 감소

<br/>

## 💭 Project Review

### 성장한 점

- **1인 풀사이클 경험**: 기획 → 디자인 → 개발 → 배포 → 운영까지 전 과정을 경험하며 제품 개발의 전체 흐름을 이해
- **데이터 기반 의사결정**: Firebase Analytics로 60개+ 이벤트를 추적하며 사용자 행동 기반 개선 경험
- **대규모 사용자 대응**: 1만+ 유저 베이스를 운영하며 앱 안정성과 버전 관리의 중요성 체득
- **마이그레이션 설계 역량**: Realm 스키마 버전 관리를 통해 기존 사용자 데이터를 안전하게 전환하는 경험

### 아쉬운 점 & 향후 개선 계획

| 현재 상태 | 개선 계획 |
|:---|:---|
| `@escaping` 클로저 기반 비동기 처리 | `async/await` 도입으로 가독성 향상 및 Callback Hell 제거 |
| Realm 객체 VC 직접 접근 | DTO 패턴 + `@MainActor` 적용으로 스레드 안전성 강화 |
| Singleton 직접 참조 | Protocol 기반 DI로 테스트 용이성 확보 |
| MVC 아키텍처 | TCA 또는 MVVM으로 아키텍처 현대화 검토 |

<br/>

## 📚 Related Links

- **📱 App Store**: [ToDoRim 다운로드](https://apps.apple.com/kr/app/todorim-%ED%95%A0%EC%9D%BC%EA%B4%80%EB%A6%AC-%EB%AF%B8%EB%A6%AC%EC%95%8C%EB%A6%BC/id1483006749)
- **📝 개발 히스토리**: [1인 앱 개발: 기획부터 배포까지](https://sunidev.tistory.com/29)
- **📧 Contact**: suniapps919@gmail.com

<br/>

---

<div align="center">

**Made with ❤️ by Suni**

</div>
