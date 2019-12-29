# 🗣 CUSE ME_iOS  💻

### 발달장애인을 위한 카드형 의사소통도구, 큐즈미

------

발달장애인들에게 세상은 넓고 깊은 바다와 같습니다.
말이 통하지 않는 사람들로 가득한 세상은 그들에겐 함부로 나아가기 어렵고, 무서운 곳이니까요.
**우리는 발달장애인들도 넓은 세상을 자유롭게 헤엄칠 수 있기를 바랍니다.
** 우리와 최소한의 의사소통이 가능하다면, 발달장애인의 세상도 조금은 넓어지지 않을까요?

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



### 📄 서비스 워크 플로우



### 📱 실행 화면



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



### 📋 기능

1. 발달 장애인이 사용하는 홈 (homeDisabled)

2. 홈 미리보기 (preview)

3. 카드 관리 (management)

4. 카드 생성 (createCard)

5. 카드 다운로드 (downloadCard)

6. 카드 상세보기 (detailCard)

7. 카드 수정 (editCard)

8. 설정 (settings)

   

### 😁 개발

👩🏻‍💻 [신유진](https://github.com/jellyb3ar)

👨🏻‍💻 [이승언](https://github.com/wookeon)
