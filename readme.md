![cume](https://user-images.githubusercontent.com/39257919/71553942-423e6f80-2a5b-11ea-972f-364c5b896b60.png)
# 🗣 CUSE ME_iOS  💻

### 발달장애인을 위한 카드형 의사소통도구, 큐즈미

------

발달장애인들에게 세상은 넓고 깊은 바다와 같습니다.
<br> 말이 통하지 않는 사람들로 가득한 세상은 그들에겐 함부로 나아가기 어렵고, 무서운 곳이니까요.
<br> **우리는 발달장애인들도 넓은 세상을 자유롭게 헤엄칠 수 있기를 바랍니다.** 
<br> 우리와 최소한의 의사소통이 가능하다면, 발달장애인의 세상도 조금은 넓어지지 않을까요?

```
💕	약자가 배제되지 않는 세상을 꿈꿉니다.
	일상에서 말이 통하지 않는다는 이유로 세상을 포기하지 않았으면 좋겠습니다.
```
```
💕	이 앱을 마주할 모든 사용자를 생각했습니다.
	발달장애인 뿐만 아니라 보호자, 이 앱을 마주할 비장애인들을 모두 고려한 UX
```
```
💕	기존 앱보다 사용성을 높였습니다.
	TTS(Text To Speach), 음성 녹음, 카드 공유 기능
```

------

### SOPT 25th APPJAM

- 개발 기간 : 2019년 12월 24일 ~ 2020년 1월 4일



### 📄 Service Work Flow
![큐즈미_워크플로우-1](https://user-images.githubusercontent.com/43192041/71722846-ccc50b80-2e6d-11ea-9385-5c8e0f581dba.png)


### 📱 실행 화면
- **발달장애인 홈 (카드 클릭 전)**
![KakaoTalk_Photo_2020-01-03-23-23-07-9](https://user-images.githubusercontent.com/43192041/71728341-3221f800-2e80-11ea-8ac3-ca2b4246c435.jpeg)

- **발달 장애인 홈 (카드 클릭)**
![KakaoTalk_Photo_2020-01-03-23-23-07-8](https://user-images.githubusercontent.com/43192041/71728390-4c5bd600-2e80-11ea-9257-541e0838e78a.jpeg)

- **관리자 모드**
![KakaoTalk_Photo_2020-01-03-23-23-07-7](https://user-images.githubusercontent.com/43192041/71728453-71e8df80-2e80-11ea-9707-12a898b254d9.jpeg)

- **사용자 홈 (카드 데이터 존재)**
![KakaoTalk_Photo_2020-01-03-23-23-07-6](https://user-images.githubusercontent.com/43192041/71728475-875e0980-2e80-11ea-855a-3bc6e1e5a91a.jpeg)

- **사용자 홈 (카드 데이터 없음)**
![KakaoTalk_Photo_2020-01-03-23-23-07-2](https://user-images.githubusercontent.com/43192041/71728578-d2781c80-2e80-11ea-9151-49e6ea8f566b.jpeg)


-  **사용자 홈 Custom Tabbar**![KakaoTalk_Photo_2020-01-03-23-23-07-5](https://user-images.githubusercontent.com/43192041/71728490-9349cb80-2e80-11ea-9b00-178e1d4ddf6f.jpeg)

- **카드 내려받기**
![KakaoTalk_Photo_2020-01-03-23-23-07-4](https://user-images.githubusercontent.com/43192041/71728547-b4aab780-2e80-11ea-8c58-5f9c40fa11f5.jpeg)

- **카드 추가**
![KakaoTalk_Photo_2020-01-03-23-23-07-3](https://user-images.githubusercontent.com/43192041/71728607-ea4fa080-2e80-11ea-959f-e1fcc15b1bc6.jpeg)

- **설정**
![KakaoTalk_Photo_2020-01-03-23-23-07-1](https://user-images.githubusercontent.com/43192041/71728284-04d54a00-2e80-11ea-9bc3-c88d11e0e868.jpeg)



### 🖥 개발 환경 및 사용한 라이브러리

##### 개발 환경

* Swift 5
* Target OS : iOS 11~



##### 사용한 라이브러리

* Kingfisher (5.8.3) : S3 저장소 URL 로부터 이미지를 다운로드하고 캐싱하기 위한 라이브러리

  ```
  let url = URL(string: "https://example.com/image.png")
  imageView.kf.setImage(with: url)
  ```

* Alamofire (4.9.0) : Swift 로 작성된 HTTP 네트워킹 라이브러리

	```
	func userName(completion: @escaping (ResposeObject<User>?, Error?) -> Void) {
        
        let id = "example"
        let url = URL(string: "https://example.com/user/id")
            
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON {
                response in
                
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(ResponseObject<User>.self, from: data)
                            completion(result, nil)
                        } catch (let error) {
                            print("getMyRentalList(catch): \(error.localizedDescription)")
                            completion(nil, error)
                        }
                    }
                case .failure(let e):
                    print("getMyRentalList(failure): \(e.localizedDescription)")
                    completion(nil, e)
                }
        }
	  }
	```
* lottie-ios : 벡터 기반의 애니메이션을 JSON으로 랜더링하고 실시간으로 동작하게하는 라이브러리


### 📋 기능 소개
 기능     | 개발 여부     | 기타사항  | 담당
:-----:|:-------:|------- |:---:
Lottie |○|  Home 화면 배경 |이승언
카드 정렬 |○| 사용자 설정, 빈도, 이름 |이승언,신유진
음성 재생 |○| 음성 데이터가 있을 경우 | 이승언
TTS |○|  음성 데이터가 없을 경우 텍스트를 바탕으로 생성|이승언
Pinch |△|  카드 크기 확대 및 축소|이승언
카드 관리 |○| 삭제, 숨김  (다중 선택 가능) / 수정 |이승언
카드 순서 변경 |○| 카드 Drag & Drop|이승언
카드 검색 |○| 카드 제목 및 내용 검색|  이승언,신유진
카드 다운로드 |△| 일련번호를 이용하여 다운로드 |이승언, 뷰:신유진
새 카드 생성 |○| |이승언,뷰:신유진
이미지 추가 |○| 새 카드 생성시 카메라롤에서 사진 추가|이승언
카드 수정 |△| |이승언
음성 녹음 |○| 서버에 파일 저장 |이승언
음성 스트리밍 |○| |이승언
설정 정보 변경 |○| 연락처, 비밀번호 업데이트|이승언, 뷰:신유진
UUID generator keychain |○|  |이승언

### 🔎문제점과 해결방안
* **사용자 홈의 가운데 floating menu 문제**
Tabbar Controller를 Customize시켜 해결 
[HomeHelperTabBarController.swift](https://github.com/CuseMe/CuseMe_iOS/blob/master/CuseMe_iOS/Pages/HomeHelper/HomeHelperTabBarController.swift)



* **collectionview delegate 에서 tts나 음성 메모가 출력 중일 때 중복으로 셀이 터치되는 문제**  
~~~
guard !synthesizer.isSpeaking && !streamingPlayer.isPlaying else { return }


extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
~~~
* **녹음 중 시간 Progress bar Customize 하기**
~~~
override func viewDidLoad() {
        super.viewDidLoad()
        
        //init path
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 43, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        //Draw the Circle
        timeLayer.path = circularPath.cgPath
        timeLayer.strokeColor = UIColor(red:251/255, green:109/255, blue:106/255, alpha:1.0).cgColor
        timeLayer.lineWidth = 2
        timeLayer.strokeEnd = 0
        timeLayer.lineCap = CAShapeLayerLineCap.round
        timeLayer.fillColor = UIColor.clear.cgColor
        timeLayer.position = CGPoint(x: 188, y: 723)
        timeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        backgroundLayer.position = CGPoint(x: 188, y: 723)
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.lineWidth = 2
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor(red:229/255, green:229/255, blue:229/255, alpha:1.0).cgColor
        
        //add layers to view
        view.layer.addSublayer(backgroundLayer)
        view.layer.addSublayer(timeLayer)}
~~~

### 😁 개발
👩🏻‍💻 [신유진](https://github.com/jellyb3ar)

👨🏻‍💻 [이승언](https://github.com/wookeon)

