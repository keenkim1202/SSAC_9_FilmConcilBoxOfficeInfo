# SSAC_9_FilmConcilBoxOfficeInfo
한국영화진흥위원회 API를 통해 어제자 기준 일간  박스오피스 정보를 보여줍니다.

# Requirement
- APIKEY.plist에 [영화진흥위원회](https://www.kobis.or.kr/kobisopenapi/homepg/main/main.do)에서 발급받은 APIKEY 정보를 입력해주세요.

# Assigment
- [x] 참조이미지와 같이 화면 구성하기
- [x] 8자리로 이루어진 검색 날짜를 기준으로 어제자 박스오피스 정보를 가져옵니다. (순위, 영화제목, 공개날짜)
- [x] Alamofire를 통해 openWeather api의 json 형식으로 된 데이터를 가져왔습니다.
- [x] SwiftyJSON을 통해 JSON 형식의 데이터에서 원하는 정보를 파싱하여 tableView에 뿌려주었습니다.

# 추가 구현 사항 
- [x] APIKEY 정보를 숨김처리 하였습니다.
- [x] 검색어가 비어있을 때, 8자리가 아닐 때, 문자가 포함되어있을 때, 미래의 날짜일 때 textField를 비우고 경고문을 띄워주었습니다.
- [x] 앱 처음 실행 시, 검색정보가 아직 없으면 "원하는 날짜의 박스오피스 정보를 알고 싶다면?" 이라는 문구가 출력되도록 수정하였습니다. (실행영상에 미반영)
- [x] 추가 검색 시, 검색어가 잘못되었을 경우, "검색 결과가 없습니다 :(" 라느 문구가 출력됩니다. 다시 올바른 검색어 입력 시 해당 문구가 사라집니다.

|참조 이미지||구현 앱 UI|
|:---:|:---:|:--:|
|<img src="https://user-images.githubusercontent.com/59866819/139573324-54873733-14d5-4592-bcde-d8364ef706b8.png" />|<img width="120" src="https://user-images.githubusercontent.com/59866819/135194858-4405d3a0-0de3-4ca6-a594-3b08e0ae951b.png" />|<img width="58%" src="https://user-images.githubusercontent.com/59866819/139573286-d86f4547-b2c4-45df-9b25-dd1eda5d7d63.png" />|

# 실행 영상
<p align="center"><img width="30%" src="https://user-images.githubusercontent.com/59866819/139574173-cc1f6381-ca27-4a47-a5f9-f867250a826b.mp4" /></p>
