# MyBlog
- **링크** - [My Blog](http://13.124.213.24:8080/Myblog/index/index.jsp)
- 계정 1 - ID: guest / PW: 1234  
- 계정 2 - ID: foot / PW: 1234  

<br>

## 프로젝트 소개
일상과 생각을 자유롭게 나누고, 익명으로 질문과 답변을 통해 소통할 수 있는 공간을 제공하는 블로그입니다.  

<br>

## 개발 기간
2024.09.11 - 2024.10.02

<br>
  
## 멤버 구성
개인 프로젝트

<br>

## 개발 환경
- `java 13`
- `jdk 13.0.2`
- **IDE** : Eclipse
- **Database** : MySQL
  
<br>

## 주요 기능

### <인덱스>

![1](https://github.com/user-attachments/assets/35169cdf-cb70-4048-915c-0e32a1079550)
1. 모든 사용자의 블로그를 확인할 수 있는 인덱스 페이지로 이동합니다.
2. 비회원은 회원가입을, 회원은 로그인을 진행할 수 있습니다.
3. 글, 블로그명, 별명을 선택하여 원하는 내용으로 검색할 수 있습니다.
4. 친구 수 상위 3명의 이용자를 표시합니다.
5. 좋아요 수 상위 3개의 일상글을 보여줍니다.

<br><br>

### <회원가입>

![image](https://github.com/user-attachments/assets/07f2c5fd-4e9a-484f-b7f1-a2798454fb7c)


회원가입 시 아이디, 비밀번호, 이메일, 별명, 블로그명을 입력합니다. <br>
아이디는 중복될 수 없으므로 중복 체크를 진행합니다.

<br><br>

### <로그인>

![로그인](https://github.com/user-attachments/assets/a8d2635e-31d7-47e9-9d00-2c74850508ec)

아이디와 비밀번호를 입력한 후, 로그인을 진행합니다.

<br><br>

![image](https://github.com/user-attachments/assets/ce28c8d1-5f2b-44ac-8929-3e870842176a)

MyBlog는 로그인 후 이용 가능합니다.

<br><br>

![2025-02-06 02 22 40](https://github.com/user-attachments/assets/5bfa0d01-b109-4f3c-94d2-45e54fe907d2)


로그인 후 
1. 오른쪽 상단의 별명을 클릭하면 언제든지 내 블로그로 이동하고, 프로필 수정 및 로그아웃이 가능합니다.
2. 검색창이나 인기 블로그를 통해 다른 사람의 블로그를 구경하고, 좋아요 및 댓글을 남길 수 있습니다.

<br><br>

### <나의 블로그>
- #### 블로그홈

![2025-02-06 02 25 00](https://github.com/user-attachments/assets/8c149bc1-e26b-42c6-a529-84413cc26e98)


나의 블로그 메뉴를 클릭하면

1. 블로그명 옆의 다이어리 아이콘을 클릭하면 인덱스 페이지로 이동합니다.
2. 블로그 내 검색창을 통해 내용을 검색할 수 있습니다.
3. 블로그 소개글과 조회수 상위 2개의 글이 표시됩니다.
4. 별명 옆의 톱니바퀴를 클릭하면 프로필을 수정할 수 있습니다.
5. 친구를 클릭하면 친구 목록을 확인할 수 있습니다.<br>
 5-1. 친구 요청이 있을 경우 느낌표 아이콘이 표시됩니다.
6. 일상글, Q&A, 일기 메뉴를 이용할 수 있습니다.<br>
 6-1. Q&A의 질문은 블로그 주인을 제외한 모든 회원이 익명으로 이용할 수 있습니다.<br>
 6-2. Q&A의 답변은 블로그 주인만 작성할 수 있습니다.<br>
 6-3. 일기는 블로그 주인만 이용할 수 있습니다.<br>
   
<br><br>

- #### 프로필 수정

![프로필수정](https://github.com/user-attachments/assets/86f7dd9b-9bf4-4398-8920-48fa24df8ff2)

프로필 수정 시 블로그명, 별명, 소개글, 프로필 사진을 변경할 수 있습니다.

<br><br>

- #### 일상

![image](https://github.com/user-attachments/assets/27c424af-71e8-45b1-b290-cc5731e496b3)

일상 쓰기 버튼을 클릭하면 일상글을 작성할 수 있습니다.

<br><br>

![image](https://github.com/user-attachments/assets/e65947d2-8276-4bab-bb22-1bf1e95af8b5)

제목과 내용을 입력한 후 저장 버튼을 누르면 글이 등록됩니다.

<br><br>

![2025-02-06 01 55 00](https://github.com/user-attachments/assets/7df5d302-9e47-46b9-9a8f-96ceb1baeaf7)

1. 좋아요를 누르거나 취소할 수 있습니다.
2. 댓글을 작성할 수 있습니다.
3. 블로그 주인과 친구일 경우 별명 옆에 연분홍 하트 아이콘이 표시됩니다.
4. 블로그 주인일 경우 별명 옆에 찐분홍 하트 아이콘이 표시됩니다.
5. 댓글 작성자는 자유롭게 댓글을 수정하거나 삭제할 수 있습니다.

<br><br>

- #### Q&A

![2025-02-06 02 50 08](https://github.com/user-attachments/assets/c7ed8240-10ea-475c-93a1-7aaf8eb2dd30)

Q&A에 답변이 달렸을 경우, "답변 등록 완료"라고 표시됩니다.

<br><br>

![image](https://github.com/user-attachments/assets/326cf243-1b23-42aa-9885-51011dd0df34)

Q&A의 답변은 블로그 주인만 작성할 수 있습니다.

<br><br>

- #### 일기

![image](https://github.com/user-attachments/assets/549d8169-1a51-4e11-83ca-a85054d023d8)

일기 쓰기 버튼을 클릭하면 일기를 작성할 수 있습니다.

<br><br>

![image](https://github.com/user-attachments/assets/2822a6bc-a525-4c39-9c40-520e22141989)

날짜, 기분, 날씨를 선택한 후 요일과 제목, 내용을 입력하고 저장 버튼을 누르면 글이 등록됩니다.

<br><br>

![image](https://github.com/user-attachments/assets/ab8b1b71-51a2-48ae-87e7-72bb0f938c78)

등록된 일기는 블로그 주인만 볼 수 있습니다.

<br><br>

## 아쉬운점
- 중복을 허용하지 않기 위해 `HashSet`을 사용했더니 친구 목록이 정렬되지 않는다.
- 글 작성 시 친구 공개, 비공개 등 공개 여부 기능이 추가되면 좀 더 프라이빗하게 블로그를 이용할 수 있을 것 같다.


<br>
