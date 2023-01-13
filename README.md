# Keyneez-iOS
## 💙 키니즈(Keyneez) 소개
청소년의 일상을 다채롭고 풍부하게,  
**청소년 통합 인증 서비스**와 **다양한 활동&혜택 정보를 제공**하는 서비스입니다.

![A2 판넬 1@2x](https://user-images.githubusercontent.com/70744494/212153469-efeab9d1-927c-4937-8778-e27bf262510b.png)

</br>
<br>

## 👩‍💻🧑‍💻 참여 구성원
  
</br>


| 담당자 | <img src="https://user-images.githubusercontent.com/70744494/212338144-5fc34eb1-d3fe-4c39-a6bf-48f3a2e66222.png" width="200" height="260"><br><br>`박의서` | <img src="https://user-images.githubusercontent.com/70744494/212338199-75fe9273-aa84-4a8b-ac82-2235b607acba.png" width="200" height="260"> <br><br>`최효원` | <img src="https://user-images.githubusercontent.com/70744494/212338238-25256d68-5b2c-4e15-938c-5486513bba14.png" width="200" height="260"> <br><br> `정도현` |
| :-----: | -------------- | -------------- | -------------- |
| github | [@kpk0616](https://github.com/kpk0616) | [@wonniiii](https://github.com/wonniiii) | [@pastapeter](https://github.com/pastapeter) |

</br>
<br>

## ✨ 담당 뷰 및 기능
<details>
<summary>의서</summary>
<div markdown="1">

- 공통 커스텀 탭바 : UITabBar 이용, BazierPath 로 커스텀
- Home : Segmented Control 과 CollectionView 이용
- 상세 인포 : 스크롤 뷰
- 저장 뷰 : 콜렉션 뷰
- 검색 뷰 : PerformBatchUpdate, CollectionView 이용
- 각 뷰 이미지 : 킹피셔 이용해 이미지 캐싱

</div>
</details>

<details>
<summary>효원</summary>
<div markdown="1">

- 랜딩페이지

⇒ PageControl로 Indicator를 만들었고 Scroll View를 이용해서 이미지만 슬라이드 되도록 구현하였습니다. 회원가입과 로그인 스타일은 프로젝트에서 많이 쓰이는 스타일이라서 따로 extension을 만들어서 재사용해주었습니다.

- 회원가입(다날 휴대폰 인증 뷰  + 성향 태그 뷰 + 정보 확인 및 관심사 태그 뷰)
    
    ⇒ 앱잼 단위에서는 다날 API를 이용하지 않고 더미데이터로 돌아가게 하였고, 성향 태그는 UIImage로 넣어서 클릭되면 이미지가 변경되게 구현했습니다. 정보 확인 및 관심사 태그는 CollectionView를 이용하여 제작해주었고, 세미나 카카오 심화 과제처럼 Index 알고리즘을 따로 만들어서 클릭한 순서에 따라 Index가 변경되게 하였습니다. 
    
- 젤리 생성 뷰
    
    ⇒ 유저가 선택한 성향과 관심사를 바탕으로 젤리가 생성이 되고, 서버에서 받아온 정보를 바탕으로 캐릭터 타입과, 젤리 이미지, 아이템을 변경되게 해주었습니다. 나의 아이템 부분은 CollectionView로 구현하였고, 캐릭터 타입을 클릭하면 커스텀한 View인 BottomSheet이 나오도록 구현했습니다.\
    
- 간편 비밀번호 설정 뷰
    
    ⇒ 마지막 단계 토스트 메시지는 Toast-Swift 라이브러리를 사용하였고, 밑에 번호판은 CollectionView로 만들었습니다. Cell이 클릭될 때마다 진행 이미지가 바뀌도록 짜주었고, 첫번째로 입력한 비밀번호를 dataBind하여 다음화면에서 입력한 비밀번호와 같을 때 홈 뷰로 넘어가도록 만들어주었습니다.

</div>
</details>

<details>
<summary>도현</summary>
<div markdown="1">

OCR 카메라 기능을 구현하였습니다. AVFoundation을 사용해서 카메라, preview view를 커스텀하였습니다. 

BottomSheetViewController를 구현하였으며, PresentationStyle을 커스텀하여서 만들어습니다.

IDViewController를 구현하면서, User에 맞게 변화하는 플로우를 사용하기 위해서, View와 VC를 나눠서 구현하였습니다.

</div>
</details>

<br><br>

## 🔥 어려웠던 부분 및 극복 과정

<details>
<summary>의서</summary>
<div markdown="1">

서버에서 다른 통신은 다 되는데 전체조회 통신이 안 되는 문제가 발생했다. 포스트맨을 이용해 토큰값을 넣고 헤더에 Content-Type 까지 잘 넣어서 리퀘스트를 보냈음에도 전체조회에서 계속해서 타임아웃 에러가 발생했다.
서버측과 포스트맨을 똑같이 대조해서 보내봐도 안 되고, 차이점을 찾지 못했다. 근데 서버측 컴퓨터에서는 동작하고, 클라측 컴퓨터에서는 동작하지 않았다. 코드에서도 서버와 통신은 잘 되는데 전체조회 부분에서만 타임 아웃 에러가 계속해서 발생했다.
알고보니 서버 측에서 회원가입이 이루어진 후 성향 체크 로직을 거쳐야지만 전체 조회가 이루어지도록 처리를 해 주었기 때문에 에러가 발생하는 것이었다. 포스트맨을 이용해 발급받은 토큰을 이용해 성향 체크 API 에 리퀘스트를 날린 후, 해당 토큰을 적용시키니 문제가 해결되었다.

</div>
</details>

<details>
<summary>효원</summary>
<div markdown="1">

랜딩페이지를 그냥  ViewController를 4개 만들어서 PageViewController로 ViewController자체를 바뀌게 만들려고 했는데 뭔가 비효율적인 것 같아서 조금 더 효율적으로 만들 수 있는 방법을 찾는데 어려움이 있었습니다. 그래서 많은 블로그를 찾아봐서 PageControl과 ScollView를 이용하여 ViewController를 1개만 만들어서 그 안에서 다 처리해주었습니다.

</div>
</details>

<details>
<summary>효원</summary>
<div markdown="1">

iOS기기 Camera I/O가 될떄, Camera buffer 에 존재하는 프레임을 기반으로 자동OCR 기능 구현, 프레임 기반으로 들어오는 camerabuffer의 값을 원하는 사진 크기로 자르는 것, 수동OCR 기능 구현이 어려웠습니다. 카메라 버퍼에서 들어오는 프레임의 크기와 현재 휴대폰화면의 크기를 비교하고, 비례대로 잘랐습니다. 자른 것은 OCR을 활용해서 필요한 정보를 추출합니다. 

또한 카메라는 백그라운드 스레드에서 동작하는데, 해당 카메라 i/o동작과 사진 프로세싱하는 것을 스레드를 나눠야합니다. 따라서 사진 프로세싱하는 동작과 카메라 I/O를 나누면서 프로세싱할때, 카메라 I/O을 block했습니다. 사진 프로세싱하는 버퍼가 다 차면 카메라 블럭시키는 과정을 DispatchSemaphore을 사용해서 블럭시켰습니다.

</div>
</details>

<br><br>

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
 Google MLKit | OCR 기능 구현 | 6.25.0
 
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




