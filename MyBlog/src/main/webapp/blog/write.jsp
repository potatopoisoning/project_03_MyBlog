<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%
	if(session.getAttribute("id") == null)
	{
		%>
		<script>
			alert("잘못된 접근입니다. ")
			location.href = 'list.jsp';
		</script>
		<%
	}

	/* String type = request.getParameter("type");
	if(type == null || type.equals("")) type = "L";	 */
%>      
        <main>
            <section>
                <article>
                <%
                	if(type.equals("L"))
                	{
                		%>
                		<div id="lwrite">
	                        <h2>일상 작성</h2>
	                        <form action="writeOk.jsp" method="post" enctype="multipart/form-data">
	                        	<input type="hidden" name="type" value="<%= type %>">
	                        	<input type="hidden" name="bno" value="<%= Bno %>">
	                            <div class="input_group">
	                                <label for="life_title">제목</label>
	                                <input type="text" name="title" id="life_title" placeholder="제목을 입력하세요" required>
	                            </div>
	                            <div class="input_group">
	                                <label for="life_content">내용</label>
	                                <textarea name="content" id="life_content" placeholder="내용을 입력하세요" required></textarea>
	                            </div>
	                            <!-- <div class="input_group">
	                            	<label>공개 여부</label>
	                            	<div class="pc">
		                            	<label><input type="radio" name="state" value="E">전체공개</label>
		                            	<label><input type="radio" name="state" value="F">친구공개</label>
		                            	<label><input type="radio" name="state" value="P">비공개</label>
		                            </div>	
	                            </div> -->
	                            <div class="input_group">
	                                <label for="life_image">첨부 이미지</label>
	                                <input type="file" name="fname" id="life_image">
	                                <!-- <input type="file" name="fname" id="life_image" accept="image/*"> -->
	                            </div>
	                            <button type="submit" class="_btn">일상 저장</button>
	                        </form>
	                        <div class="back">
	                            <a href="list.jsp?bno=<%= Bno %>&type=<%= type %>">뒤로 가기</a>
	                        </div>
	                    </div>	
                		<%
                	} 
	                if(type.equals("Q"))
	                {
		                %>
	                	<div class="qna_container3">
	                       <h2>Question</h2>
	                       <form action="writeOk.jsp" method="post" enctype="multipart/form-data">
	                       		<input type="hidden" name="type" value="<%= type %>">
	                        	<input type="hidden" name="bno" value="<%= bno %>">
	                       		<!-- 질문 입력 폼 -->
		                        <div class="question_form">
		                            <label for="q_note">질문</label>
		                            <!-- <input type="text" id="question_content2" placeholder="질문 내용을 입력하세요" required> -->
		                            <textarea name="title" placeholder="질문 내용을 입력하세요" rows="4" required></textarea>
		                            <button class="_btn">질문 등록</button>
		                        </div>
	                       </form>
	                       <div class="back">
	                           <a href="list.jsp?bno=<%= bno %>&type=<%= type %>">뒤로 가기</a>
	                       </div>
	                   </div>
	                   <%
	                }
               		if(type.equals("D"))
                	{
                		%>
	                    <div id="diary_container2">
	                        <h2>일기 작성</h2>
	                        <form action="writeOk.jsp" method="post" enctype="multipart/form-data">
	                        	<input type="hidden" name="type" value="<%= type %>">
	                        	<input type="hidden" name="bno" value="<%= Bno %>">
	                        	<div class="input_container" style="display: flex; gap: 20px; width:100%">
		                            <div class="input_group">
		                                <label for="dwrite_date">날짜</label>
		                               <!--  <input type="text" name="date" id="dwrite_date" placeholder="YYYY-MM-DD" required> -->
		                                <input type="date" name="date" id="dwrite_date" required>
		                            </div>
		                            <div class="input_group">
		                                <label for="dwrite_day">요일</label>
		                                <input type="text" name="day" id="dwrite_day" required>
		                            </div>
		                        </div>    
	                            <div class="input_container" style="display: flex; gap: 20px; width:100%"">
									 <div class="input_group weather_group">
			                                <label>날씨</label>
			                                <input type="radio" name="weather" value="1" id="w1"><label for="w1"> ☀️</label>
			                                <input type="radio" name="weather" value="2" id="w2"><label for="w2"> ☁️</label>
			                                <input type="radio" name="weather" value="3" id="w3"><label for="w3"> 🌧️</label>
			                                <input type="radio" name="weather" value="4" id="w4"><label for="w4"> ❄️</label>
		                            </div>    
									<div class="input_group mood_group">
			                                <label>기분</label>
			                                <input type="radio" name="mood" value="1" id="m1"><label for="m1"> 😊</label>
			                                <input type="radio" name="mood" value="2" id="m2"><label for="m2"> 😐</label>
			                                <input type="radio" name="mood" value="3" id="m3"><label for="m3"> 😢</label>
			                                <input type="radio" name="mood" value="4" id="m4"><label for="m4"> 😡</label>
		                            </div>
		                        </div>  
	                            <div class="input_group">
	                                <label for="dwrite_title">제목</label>
	                                <input type="text" name="title" id="dwrite_title" placeholder="일기 제목을 입력하세요" required>
	                            </div>
	                            <div class="input_group">
	                                <label for="dwrite_content">내용</label>
	                                <textarea name="content" id="dwrite_content" placeholder="일기 내용을 입력하세요" required></textarea>
	                            </div>
	                            <div class="input_group">
	                                <label for="dwrite_image">사진 첨부</label>
	                                <input type="file" id="dwrite_image" name="fname" accept="image/*">
	                                <!-- <img id="journal-image-preview" class="image-preview" src="#" alt="사진 미리보기"> -->
	                            </div>
	                            <button type="submit" class="_btn">일기 저장</button>
	                        </form>
	                        <div class="back">
	                            <a href="list.jsp?bno=<%= Bno %>&type=<%= type %>">뒤로 가기</a>
	                        </div>
	                    </div>
	                    <%
                	}
	                %>                
                </article>
            </section>
<%@ include file="../include/aside.jsp" %>
<%@ include file="../include/footer.jsp" %>