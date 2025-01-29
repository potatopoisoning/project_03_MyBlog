<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%

request.setCharacterEncoding("UTF-8");

/* String type = request.getParameter("type"); */
/* if(type == null || type.equals("")) type = "L";
if(searchValue == null || searchValue.equals("null")) searchValue = ""; */
int kno = Integer.parseInt(request.getParameter("kno"));
bno = Integer.parseInt(request.getParameter("bno"));

String title = "";
String content = "";
String weather = "";
String mood = "";
String date = "";
String day = "";
String bpname = "";
String bfname = "";
int qbno = 0;

try
{
	conn = DBConn.conn();

	String sql = "select b.bno, b.uno, kno, title, content, weather, mood, date, day, date(b.rdate) as rdate, pname, fname from board b inner join user u on b.uno = u.uno where kno = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, kno);
	rs = stmt.executeQuery();
	

	if(rs.next()) 
	{
		title = rs.getString("title");
		content = rs.getString("content");
		String rdate = rs.getString("rdate");
		if(type.equals("D")) 
		{
			weather = rs.getString("weather"); 
			mood = rs.getString("mood");
			date = rs.getString("date"); 
			day = rs.getString("day");
		}
		bpname  = rs.getString("pname");
		bfname  = rs.getString("fname");
		qbno = rs.getInt("bno");
	}
}catch(Exception e)
{
	e.printStackTrace();
	// 오류 출력
	out.print(e.getMessage());
}finally
{
	DBConn.close(rs, stmt, conn);
}
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
	                        <form action="modifyOk.jsp" method="post" enctype="multipart/form-data">
	                        	<input type="hidden" name="type" value="<%= type %>">
	                        	<input type="hidden" name="kno" value="<%= kno %>">
	                        	<input type="hidden" name="bno" value="<%= bno %>">
	                            <div class="input_group">
	                                <label for="life_title">제목</label>
	                                <input type="text" name="title" id="life_title" value="<%= title %>" placeholder="제목을 입력하세요" required>
	                            </div>
	                            <div class="input_group">
	                                <label for="life_content">내용</label>
	                                <textarea name="content" id="life_content" placeholder="내용을 입력하세요" required><%= content %></textarea>
	                            </div>
	                            <div class="input_group">
	                                <label for="life_image">첨부 이미지</label>
	                                <input type="file" name="bfname" id="life_image" accept="image/*">
	                                <input type="checkbox"  id="hide_image" name="fimg_delete" value="C">x
	                                <% 
                                   		if (bfname == null || bfname.equals("")) 
									    {
								    		%>
									   		<% 
									    }else
	                                    { 
	                                    	%>
									       	<img src="../upload/<%= bpname %>" alt="현재 첨부 이미지" style="max-width: 100px;" id="fimg">
									    	<% 
									    } 
									 %>
								 <script>
							        // 이미지와 체크박스 요소를 가져옵니다.
							        const imgElement = document.getElementById("fimg");
							        const checkbox = document.getElementById("hide_image");
							
							        // 체크박스 상태가 변경될 때마다 실행되는 이벤트 핸들러
							        checkbox.addEventListener("change", function() {
							            if (this.checked) {
							                imgElement.style.display = "none";  // 체크박스가 선택되면 이미지 숨김
							            } else {
							                imgElement.style.display = "block"; // 체크박스 선택 해제되면 이미지 다시 표시
							            }
							        });
							    </script>
	                            </div>
	                            <button type="submit" class="_btn">일상 저장</button>
	                        </form>
	                        <div class="back">
	                            <a href="view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>">뒤로 가기</a>
	                        </div>
	                    </div>	
                		<%
                	} 
	                if(type.equals("Q"))
                	{
                			%>
							<div class="qna_container3">
		                        <h2>Question</h2>
		                        <form action="modifyOk.jsp" method="post" enctype="multipart/form-data">
		                        <input type="hidden" name="type" value="<%= type %>">
	                        	<input type="hidden" name="kno" value="<%= kno %>">
	                        	<input type="hidden" name="bno" value="<%= qbno %>">
			                        <div class="question_form">
			                            <label for="q_note">질문</label>
			                            <!-- <input type="text" id="question_content2" placeholder="질문 내용을 입력하세요" required> -->
			                            <textarea name="title" placeholder="질문 내용을 입력하세요" rows="4" required><%= title %></textarea>
			                            <button class="_btn">질문 등록</button>
			                        </div>
		                        </form>
		                        <div class="back">
		                            <a href="view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>">뒤로 가기</a>
		                        </div>
		                    </div>
		                    <%
	               	} 
               		if(type.equals("D"))
                	{
                		%>
	                    <div id="diary_container2">
	                        <h2>일기 작성</h2>
	                        <form action="modifyOk.jsp" method="post" enctype="multipart/form-data">
	                        	<input type="hidden" name="type" value="<%= type %>">
	                        	<input type="hidden" name="kno" value="<%= kno %>">
	                        	<input type="hidden" name="bno" value="<%= bno %>">
	                        	<div class="input_container" style="display: flex; gap: 20px; width:100%">
		                            <div class="input_group">
		                                <label for="dwrite_date">날짜</label>
		                               <!--  <input type="text" name="date" id="dwrite_date" placeholder="YYYY-MM-DD" required> -->
		                                <input type="date" name="date" id="dwrite_date" value="<%= date %>" required>
		                            </div>
		                            <div class="input_group">
		                                <label for="dwrite_day">요일</label>
		                                <input type="text" name="day" id="dwrite_day" value="<%= day %>" required>
		                            </div>
		                        </div>    
	                            <div class="input_container" style="display: flex; gap: 20px; width:100%"">
									 <div class="input_group weather_group">
			                                <label>날씨</label>
			                                <input type="radio" name="weather" value="1" id="w1" <%= weather.equals("1")? "checked " : "" %>><label for="w1"> ☀️</label>
			                                <input type="radio" name="weather" value="2" id="w2" <%= weather.equals("2")? "checked " : "" %>><label for="w2"> ☁️</label>
			                                <input type="radio" name="weather" value="3" id="w3" <%= weather.equals("3")? "checked " : "" %>><label for="w3"> 🌧️</label>
			                                <input type="radio" name="weather" value="4" id="w4" <%= weather.equals("4")? "checked " : "" %>><label for="w4"> ❄️</label>
		                            </div>    
									<div class="input_group mood_group">
			                                <label>기분</label>
			                                <input type="radio" name="mood" value="1" id="m1" <%= mood.equals("1")? "checked " : "" %>><label for="m1"> 😊</label>
			                                <input type="radio" name="mood" value="2" id="m2" <%= mood.equals("2")? "checked " : "" %>><label for="m2"> 😐</label>
			                                <input type="radio" name="mood" value="3" id="m3" <%= mood.equals("3")? "checked " : "" %>><label for="m3"> 😢</label>
			                                <input type="radio" name="mood" value="4" id="m4" <%= mood.equals("4")? "checked " : "" %>><label for="m4"> 😡</label>
		                            </div>
		                        </div>  
	                            <div class="input_group">
	                                <label for="dwrite_title">제목</label>
	                                <input type="text" name="title" id="dwrite_title" value="<%= title %>" placeholder="일기 제목을 입력하세요" required>
	                            </div>
	                            <div class="input_group">
	                                <label for="dwrite_image">사진 첨부</label>
	                                <input type="file" id="dwrite_image" name="bfname" accept="image/*">
	                                <input type="checkbox"  id="hide_image" name="fimg_delete" value="C">x
	                                <% 
                                   		if (bfname == null || bfname.equals("")) 
									    {
								    		%>
									   		<% 
									    }else
	                                    { 
	                                    	%>
									       	<img src="../upload/<%= bpname %>" alt="현재 첨부 이미지" style="max-width: 100px;" id="fimg">
									    	<% 
									    } 
									 %>
								 <script>
							        // 이미지와 체크박스 요소를 가져옵니다.
							        const imgElement = document.getElementById("fimg");
							        const checkbox = document.getElementById("hide_image");
							
							        // 체크박스 상태가 변경될 때마다 실행되는 이벤트 핸들러
							        checkbox.addEventListener("change", function() {
							            if (this.checked) {
							                imgElement.style.display = "none";  // 체크박스가 선택되면 이미지 숨김
							            } else {
							                imgElement.style.display = "block"; // 체크박스 선택 해제되면 이미지 다시 표시
							            }
							        });
							    </script>
	                            </div>
	                            <div class="input_group">
	                                <label for="dwrite_content">내용</label>
	                                <textarea name="content" id="dwrite_content" placeholder="일기 내용을 입력하세요" required><%= content %></textarea>
	                            </div>
	                            <button type="submit" class="_btn">일기 저장</button>
	                        </form>
	                        <div class="back">
	                            <a href="view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>">뒤로 가기</a>
	                        </div>
	                    </div>
	                    <%
                	}
	                %>                
                </article>
            </section>
<%@ include file="../include/aside.jsp" %>
<%@ include file="../include/footer.jsp" %>