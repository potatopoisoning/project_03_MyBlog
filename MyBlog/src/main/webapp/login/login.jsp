<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <link rel="stylesheet" href="../css/style.css" type="text/css">
</head>
<body>
    <div id="out_div">
        <!-- Header section -->
        <header>
            <div class="title_inner">
                <div class="logo">
                    <a href="../index/index.jsp">My Blog</a>
                </div>
            </div>
        </header>

        <section>
            <article id="art">
                <div id="login">
                    <h2>로그인</h2>
                    <form action="loginOk.jsp" method="post">
                        <div class="input_group">
                            <label for="username">아이디</label>
                            <input type="text" name="id" id="username" placeholder="아이디를 입력하세요" required>
                        </div>
                        <div class="input_group">
                            <label for="password">비밀번호</label>
                            <input type="password" name="pw" id="password" placeholder="비밀번호를 입력하세요" required>
                        </div>
                        <button type="submit" class="_btn">로그인</button>
                    </form>
                    <div class="join_btn">
                        계정이 없으신가요? <a href="../join/join.jsp">회원가입</a>
                    </div>
                </div>
            </article>
        </section>

        <!-- Footer section -->
        <footer>
            &copy; Copyright by EZEN All rights reserved
        </footer>
    </div>
</body>
</html>
