# Keyneez-iOS

**도원결의.(정도현의 도. 최효원의 원. 박의서의 의.)**

<br>

## 🍀 서비스 이름과 소개 

| 서비스명   | 서비스 소개
| -------- | :-----: | 
| 키니즈(Keyneez) | 청소년증 인증을 통해 청소년만이 누릴 수 있는 혜택과 문화생활을 제공하는 서비스  |

</br>
<br>

## 👩‍💻🧑‍💻 참여 구성원

|  담당자  | 구현 기능 |
| :-----: | -------------- |
| `박의서` | TabBar, 인포 기능 |
| `최효원` | Design System, 로그인, 회원가입 기능 |
| `` | BaseVC, ID, OCR |

</br>
<br>

## 📖 라이브러리

라이브러리 | 사용 목적 | Version |
:---------:|:----------:|:---------: 
 FloatingPanel | ViewController 간편화 | 2.5.5
 Floaty | UIButton 간편화 | master
 Kingfisher | 이미지 서버 통신 | 7.4.1
 SnapKit | UI Layout | 5.6.0 
 Then | UI 선언 | 3.0.0 
 Moya | 서버 통신 | 15.0.3 
 Toast | 토스트 알림 View 간편화 | 5.0.1
 
 </br>
 <br>

## 🛠 코딩 컨벤션

```
- Indentation 2칸으로
- 최대 줄 길이 99줄
- MARK 최대한 많이 사용하기
- get 은 웬만하면 붙이지 않기
- 폴더링은 뷰 별로 나누기
- Constant는 해당 뷰 내에서 만들어 사용하기
- 에러는 맨 위에서 처리해주기
- else 구문 최대한 지양하기
```
</br>
<br>

## 🌊 Git Flow 전략

<details>
<summary> 🪵 Branch 전략 </summary>
<div markdown="1">

- `main` : 개발이 완료된 산출물이 저장될 공간
- `develop` : feature 브랜치에서 구현된 기능들이 merge될 브랜치
- `feature` : 기능을 개발하는 브랜치, 이슈별/작업별로 브랜치를 생성하여 기능을 개발한다
- `release` : 릴리즈를 준비하는 브랜치, 릴리즈 직전 QA 기간에 사용한다
- `hotfix` : 버그를 수정하는 브랜치

</div>
</details>

<details>
<summary> 📝 작성방식 </summary>
<div markdown="1">

- 역할/#(이슈번호)

</div>
</details>

<details>
<summary> 💬 Commit Message </summary>
<div markdown="1">

- [Hotfix] : issue나, QA에서 급한 버그 수정에 사용
- [Fix] : 버그, 오류 해결
- [Add] : Feat 이외의 부수적인 코드 추가, 라이브러리 추가, 새로운 파일 생성 시
- [Style] : 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우
- [Feat] : 새로운 기능 구현
- [Del] : 쓸모없는 코드 삭제
- [Docs] : README나 WIKI 등의 문서 개정
- [Mod] : storyboard 파일만 수정한 경우
- [Chore] : 코드 수정, 내부 파일 수정, 빌드 업무 수정, 패키지 매니저 수정
- [Correct] : 주로 문법의 오류나 타입의 변경, 이름 변경 등에 사용합니다.
- [Move] : 프로젝트 내 파일이나 코드의 이동
- [Rename] : 파일 이름 변경이 있을 때 사용합니다.
- [Improve] : 향상이 있을 때 사용합니다.
- [Refactor] : 전면 수정이 있을 때 사용합니다
- [Init] : Initial Commit

</div>
</details>

</br>
<br>

## 🗂 프로젝트 폴더링 Convention

```
└── Keyneez
    ├── Keyneez
    │   ├── Application
    │   │   ├── Assets.xcassets
    │   │   │   ├── AccentColor.colorset
    │   │   │   └── AppIcon.appiconset
    │   │   └── Base.lproj
    │   ├── Auth
    │   │   ├── SignIn
    │   │   └── SignUp
    │   ├── Global
    │   │   ├── Color
    │   │   ├── Font
    │   │   ├── NetworkLayer
    │   │   └── Views
    │   └── Tab
    │       ├── Home
    │       ├── ID
    │       ├── Like
    │       └── MyPage
    ├── Keyneez.xcodeproj
    │   ├── project.xcworkspace
    │   │   ├── xcshareddata
    │   │   │   └── swiftpm
    │   │   │       └── configuration
    │   │   └── xcuserdata
    │   │       └── jungpeter.xcuserdatad
    │   └── xcuserdata
    │       └── jungpeter.xcuserdatad
    │           └── xcschemes
    ├── KeyneezTests
    └── KeyneezUITests
    
```

</br>




