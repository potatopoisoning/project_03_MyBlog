<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>회원가입</title>
    <link rel="stylesheet" href="../css/style.css" type="text/css">
    <script src="../js/jquery-3.7.1.js"></script>
    <script>
	    var formFlag = false;
	    
	    function validateForm() {
	      console.log("함수가 호출되었습니다");
	      if(formFlag == true){ return true; }
	      var id = $("#username");
	      var pw = $("#password");
	      var pwc = $("#confirm_password");
	      var email = $("#email");
	      var nickname = $("#nickname");
	      var blogname = $("#blogname");
	      
	      if( id.val().trim() == "" ){
	        alert("아이디를 입력해주세요");
	        id.focus();
	        return false;
	      }
	      
	      var idPattern = /^[a-zA-Z0-9]+$/;
	      if( !idPattern.test(id.val()) )
	      {
	        alert("영문과 숫자만 입력해주세요");
	        id.val("");
	        id.focus();
	        return false;
	      }

	      if( pw.val().length < 4 ){
	        alert("비밀번호는 최소 4자 이상이어야 합니다");
	        pw.focus();
	        return false;
	      }
	      if( pw.val() != pwc.val() ){
	        alert("비밀번호가 일치하지 않습니다");
	        pwc.val("");
	        pwc.focus();
	        return false;
	      }
	      
	      var emailPattern = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
	      if(!emailPattern.test(email.val())){
	        alert("유효한 이메일 주소를 입력하세요");
	        email.focus();
	        return false;
	      }
	
	      if( nickname.val().trim() == "" ){
	          alert("별명을 입력해주세요");
	          nickname.focus();
	          return false;
	        }
	      
	      if( blogname.val().trim() == "" ){
	          alert("블로그명을 입력해주세요");
	          blogname.focus();
	          return false;
	        }
	
	      if( confirm("회원가입을 진행하시겠습니까?") == false )
	      {
	        return false;
	      }else{
	        formFlag = true;
	        $("#registerForm").submit();
	      }
	    }
	    
	    function checkID(){
			// 사용자가 입력한 아이디가 DB에 중복여부 확인하기
			let value = $("#username").val();
			
			$.ajax({
				url : "checkID.jsp",
				type : "get",
				data : "id=" + value,
				beforeSend: function() {
                    $("#idCheckReset").html("<span>확인 중...</span>");
                },
				success : function(data){
					if(data.trim() == "isId")
					{
						$("#idCheckReset").html("<span style='color:red;'>사용할 수 없는 아이디입니다.</span>");
					}else
					{
						$("#idCheckReset").html("사용할 수 있는 아이디입니다.");
						$("#idCheckReset").css("color", "green");
					}
				}
			});
		} 
    </script>
</head>
<body>
    <div id="out_div">
        <header>
            <div class="title_inner">
                <div class="logo">
                    <a href="index.jsp">My Blog</a>
                </div>
            </div>
        </header>

        <section>
            <article id="art">
                <div id="join">
                    <h2>회원가입</h2>
                    <form action="joinOk.jsp" method="post" onsubmit="return validateForm()" id="registerForm">
                        <div class="input_group">
                            <label for="username">아이디</label>
                            <input type="text" name="id" id="username" placeholder="아이디를 입력하세요" onkeyup="checkID();">
                        	<div id="idCheckReset"></div>
                        </div>
                        <div class="input_group">
                            <label for="password">비밀번호</label>
                            <input type="password" name="pw" id="password" placeholder="비밀번호를 입력하세요" >
                        </div>
                        <div class="input_group">
                            <label for="confirm_password">비밀번호 확인</label>
                            <input type="password" name="pwc" id="confirm_password" placeholder="비밀번호를 다시 입력하세요" >
                        </div>
                        <div class="input_group">
                            <label for="email">이메일</label>
                            <input type="email" name="email" id="email" placeholder="이메일을 입력하세요" >
                        </div>
                        <div class="input_group">
                            <label for="nickname">별명</label>
                            <input type="text" name="nickname" id="nickname" placeholder="별명을 입력하세요" >
                        </div>
                        <div class="input_group">
                            <label for="blogname">블로그명</label>
                            <input type="text" name="blogname" id="blogname" placeholder="블로그명을 입력하세요" >
                        </div>
                        <button type="submit" class="_btn">회원가입</button>
                    </form>
                    <div class="login_btn">
                        이미 계정이 있으신가요? <a href="login.jsp">로그인</a>
                    </div>
                </div>
            </article>
        </section>
<%@ include file="../include/footer.jsp" %>
