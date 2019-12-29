# 🗣 Cuseme_iOS  💻

> 예슬이가 적어줄 blah blah....



예슬이가 적어줄 blah,,, blah...

------

### SOPT 25th APPJAM

- 개발 기간 : 2019년 12월 21일 ~ 2020년 1월 4일



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

👨🏻‍💻 [이승언](
