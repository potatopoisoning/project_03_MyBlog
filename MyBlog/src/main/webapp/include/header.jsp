<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ezen.*" %>
<%
	if(session.getAttribute("Bno") == null || session.getAttribute("uno") == null)
	{
		// System.out.println(session.getAttribute("Bno"));
		// System.out.println(session.getAttribute("uno")); 
		// response.sendRedirect("../index/login.jsp");
		%>
		<script>
			alert("로그인 후 이용해주세요.");
			location.href = "../index/login.jsp";
		</script>
		<%
		return;
	}

	String loginName;
	String loginId;
	int loginUno;

	loginUno = (Integer)session.getAttribute("uno");
	loginName = (String)session.getAttribute("nickname");
	loginId = (String)session.getAttribute("id");
	int Bno = (Integer)session.getAttribute("Bno");
	
	String sbno = request.getParameter("bno");
	int bno = 0;
	if(sbno != null && !sbno.equals(""))
	{
		bno = Integer.parseInt(sbno);
	}
	/* 
	if(loginName == null || loginName.equals("") || loginId == null || loginId.equals(""))
	{
		// 세션 정보가 올바르지 않음 -> 초기화
		System.out.println("로그인 정보가 올바르지 않습니다.");
		loginName = "";
		loginId   = "";
		loginUno  = 0;
	} */
	
	
 	String type = request.getParameter("type");
	if(type == null || type.equals("")) type = "";  
	
	String searchValue = request.getParameter("searchValue"); 
	if(searchValue == null || searchValue.equals("null")) searchValue = "";
	/* if(searchValue != null && !searchValue.equals("")) type = "";   */

	Connection conn = null; 
	PreparedStatement stmt = null;  
	ResultSet rs = null; 
%>    
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <title>프로필 수정</title>
        <link rel="stylesheet" href="../css/style.css" type="text/css">
        <script src="../js/jquery-3.7.1.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                var dropdownBtn = document.querySelector('.dropdown_btn');
                var dropdownContent = document.querySelector('.dropdown_menu');

                dropdownBtn.addEventListener('click', function() {
                    dropdownContent.classList.toggle('show');
                });

                // 클릭 밖에서 드롭다운 숨기기
                window.addEventListener('click', function(event) {
                    if (!event.target.matches('.dropdown_btn')) {
                        if (dropdownContent.classList.contains('show')) {
                            dropdownContent.classList.remove('show');
                        }
                    }
                });
            });
        </script>
    </head>
    <body>
        <div id="out_div">
            <header>
                <div class="title_inner">
                    <%
                    	String bname = "", nname = "", intro = "", fname="", pname="";
                    	//int uno = 0;
	                    if (session.getAttribute("id") != null) {
	                        String id = (String)session.getAttribute("id");
	                        // DB 연결 및 사용자 정보 조회
	                        try 
	                        {
	                            conn = DBConn.conn();
	                            String sql = "select b.uno, blogname, nickname, introduce, fname, pname, b.bno from blog b inner join user u on b.uno = u.uno where bno = ?";
	                            stmt = conn.prepareStatement(sql);
	                            stmt.setInt(1, bno);
	                            rs = stmt.executeQuery();
	
	                            if (rs.next()) 
	                            {
	                                bname = rs.getString("blogname");
	                                nname = rs.getString("nickname");
	                                intro = rs.getString("introduce");
	                                fname = rs.getString("fname");
	                                pname = rs.getString("pname");
	                                bno = rs.getInt("bno");
	                            }
	                        } catch (Exception e) 
	                        {
	                            e.printStackTrace();
	                        } finally {
	                        	DBConn.close(rs, stmt, conn);
	                        }
                	%>
		                    <div class="logo">
		                    	<a href="../index/index.jsp"><img src="https://img.icons8.com/?size=100&id=3ioZzLbscgG7&format=png&color=000000" style="width: 35px;"></a>
		                        <a href="myblog.jsp?bno=<%= bno %>"><%= bname %></a>
		                    </div>
							<div class="auth_links2">
			                    <!-- <a href="myblog.jsp" class="name"> --><span id="submenu1"><%= loginName %></span><!-- </a> -->님, 환영합니다. 
								<div id="downmenu1" class="sub">
									<a href="myblog.jsp?bno=<%= Bno %>">나의 블로그</a><br><hr style="color: pink;">
									<a href="../blog/setting.jsp?bno=<%= Bno %>">환경설정</a><br><hr style="color: pink;">
									<a href="../index/logout.jsp?bno=<%= Bno %>">로그아웃</a>
								</div>
								
							<%-- 	test::::::::::::::<%= bno %> --%>
								<script>
									$(document).ready(function(){
										$("#submenu1")
											.mouseover(function(){
												$(this).css("text-decoration","underline");
											}) 
											.mouseout(function(){
												$(this).css("text-decoration","none");
											}) 
											.click(function(){
												$(".sub").css("display","none");
												switch($(this).attr("id")){
													case "submenu1" :
														$("#downmenu1").toggle();
														break;
													/* case "menuB" :
														$("#menuTableB").toggle();
														break;
													case "menuC" :
														$("#menuTableC").toggle();
														break; */
												}
											});
										$(".sub").mouseleave(function(){
											$(this).toggle();
										});
									});
								</script>
								<%-- <%
								if(session.getAttribute("authorization").equals("A"))
								{
									%>
									<div>
										관리자님이시군요!
									</div>
									<%
								}
								%> --%>
			                </div>
							<%
						}else
						{
							%>
			                <div class="auth_links">
			                    <a href="../join/join.jsp">회원가입</a> | <a href="../login/login.jsp">로그인</a>
			                </div>
							<%
						}
					%>
                </div>
                <nav class="header_nav">
				<form class="search_form" action="list.jsp" method="get">
					<input type="hidden" name="bno" value="<%= bno %>">
					<input type="text" class="search_input2" name="searchValue" value="<%= searchValue %>" placeholder="블로그 내 검색...">
					<button type="submit" class="search_btn2">검색</button>
				</form>
			</nav>
		</header>