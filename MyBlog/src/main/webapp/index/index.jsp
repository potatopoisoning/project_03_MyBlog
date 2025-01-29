<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %> 
<%@ page import="ezen.*" %>    
<%    
	String type = request.getParameter("type");
	if(type == null) type = "L";   
	
	Integer Bno = (Integer)session.getAttribute("Bno");
	
	request.setCharacterEncoding("UTF-8"); // 한글 때문
	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");
	if(searchType == null || searchType.equals("null")) searchType = "";
	if(searchValue == null || searchValue.equals("null")) searchValue = "";

	//현재페이지 번호
	int nowPage = 1;
	if(request.getParameter("nowPage") != null)
	{
		// 하단에 다른 페이지 번호 클릭시
		nowPage = Integer.parseInt(request.getParameter("nowPage"));
	}

	Connection conn = null; 

	// 전체글 개수용
	PreparedStatement stmtTotal = null;  
	ResultSet rsTotal = null;  
	
	int total = 0;

	// 친구용
	PreparedStatement fstmt = null;  
	ResultSet frs = null;
	
	String fintroduce = "";
	String fpname  = "";
	String ffname = "";
	int fbno = 0;
	String fnickname = "";
	String fblogname = "";
	String fcount = "";

	// 하트용
	PreparedStatement hstmt = null;  
	ResultSet hrs = null;
	
	String hbname = "";
	String hnname = "";
	String htitle = "";
	String hcontent = "";
	int hbno = 0;
	int hkno = 0;
	String hpname  = "";
	String hfname  = "";

	// 검색용 
	PreparedStatement stmt = null;  
	ResultSet rs = null; 
	PreparedStatement nstmt = null;  
	ResultSet nrs = null; 
	
	String bname = "";
	String nname = "";
	String title = "";
	String content = "";
	String rdate = "";
	int bno = 0;

	String nbname = "";
	String nnname = "";
	String nfname = "";
	String npname = "";
	String nintro = "";
	int nbno = 0;

	
	try
	{
		// DB 연결 후 
		conn = DBConn.conn();
		
		String sqlTotal = "";
		
		// 페이징에 필요한 게시글 전체 개수 쿼리 영역
		// 검색어 O
		if(!searchType.equals(""))
		{
			// searchType "글"
			if(searchType.equals("post"))
			{
				sqlTotal = "select count(*) as total from board b inner join user u on b.uno = u.uno ";
				sqlTotal += "inner join blog on b.uno = blog.uno ";
				sqlTotal += "where b.state = 'E' ";
				sqlTotal += "and type = 'L' and (title like concat('%', ?, '%') or content like concat('%', ?, '%')) ";
			// searchType "닉네임"
			}else if(searchType.equals("nname"))
			{
				sqlTotal = "select count(*) as total from user u inner join blog on u.uno = blog.uno where u.state = 'E' ";
				sqlTotal += "and nickname like concat('%', ?, '%')";
			// searchType "블로그명"
			}else if(searchType.equals("bname"))
			{
				sqlTotal = "select count(*) as total from user u inner join blog on u.uno = blog.uno where u.state = 'E' ";
				sqlTotal += "and blogname like concat('%', ?, '%')";
			}
		}else
		{
				sqlTotal = "select count(*) as total from board b inner join user u on b.uno = u.uno ";
				sqlTotal += "inner join blog on b.uno = blog.uno ";
				sqlTotal += "where b.state = 'E' ";
		}
		
		stmtTotal = conn.prepareStatement(sqlTotal);
		
		System.out.print(sqlTotal);
		
		// 검색어 O
		if(!searchType.equals(""))
		{
			// searchType "글"
			if(searchType.equals("post"))
			{
				stmtTotal.setString(1, searchValue);
				stmtTotal.setString(2, searchValue);
			// searchType "닉네임", "블로그명"
			}else
			{
				stmtTotal.setString(1, searchValue);
			}
		}
		rsTotal = stmtTotal.executeQuery();
		
		
		if(rsTotal.next())
		{
			total = rsTotal.getInt("total");
		}
		PagingUtil paging = null;
		if(!searchValue.equals("")) 
		{
			paging = new PagingUtil(nowPage, total, 8); // 검색어 O -> 8개 글 보기
		}else if(searchValue.equals("") || searchValue == null || searchValue.equals("null")) 
		{
			paging = new PagingUtil(nowPage, total, 3); // 검색어 X -> 3개 글 보기
		}
		
		
		// 인기짱
		String fsql = "SELECT introduce, pname, fname, bno, "
				    + "(SELECT u.nickname FROM USER u WHERE u.uno = blog.uno) AS nickname, "
				    + "(SELECT u.blogname FROM USER u WHERE u.uno = blog.uno) AS blogname, "
				    + "COUNT(*) AS fcount "
				    + "FROM FRIEND  "
				    + "INNER JOIN blog "
				    + "ON (tbno = blog.bno or rbno = blog.bno) "
				    + "WHERE state = 'Y' "
				    + "GROUP BY "
				    + "FRIEND.state, introduce, pname, fname, nickname, blogname, bno "
				    + "HAVING  "
				    + "COUNT(*) >= 1 "
				    + "ORDER BY fcount DESC "
				    + "LIMIT ?, ? ";
				    
		fstmt = conn.prepareStatement(fsql);
		fstmt.setInt(1, paging.getStart());
		fstmt.setInt(2, paging.getPerPage());
		frs = fstmt.executeQuery();
		
		
		// 하트짱
		String hsql = "SELECT (select count(*) as hcnt from heart where kno = b.kno and state = 'E') as hcnt, kno, title, nickname, blogname, date(b.rdate) as rdate, content, b.fname, b.pname, b.uno, blog.bno "
				   + "FROM board b " 
				   + "INNER JOIN user u " 
				   + "ON b.uno = u.uno "
			 	   + "INNER JOIN blog on b.uno = blog.uno "
			 	   + "WHERE b.state = 'E' "
				   + "AND type = 'L' order by hcnt desc, hit desc "
				   + "LIMIT ?, ? ";
		
		hstmt = conn.prepareStatement(hsql);
		hstmt.setInt(1, paging.getStart());
		hstmt.setInt(2, paging.getPerPage());
		hrs = hstmt.executeQuery();
		
		
		// 검색
		String sql = "";
		String nsql = "";
		if(!searchType.equals(""))
		{
			
			// 글 제목, 내용, 블로그 이름, 닉네임, 날짜
			if(searchType.equals("post"))
			{
				sql = "SELECT kno, title, content, date(b.rdate) as rdate, blog.fname, blog.pname, hit, nickname, blogname, blog.bno "
					   + "FROM board b " 
					   + "INNER JOIN user u " 
					   + "ON b.uno = u.uno "
				 	   + "INNER JOIN blog on b.uno = blog.uno "
					   + "WHERE ";
				sql += "b.state = 'E' ";
				sql += "AND type = 'L' AND (title like concat('%', ?, '%') OR content like concat('%', ?, '%')) ";
				sql += "ORDER BY hit DESC ";
				sql += "LIMIT ?, ? ";                
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, searchValue);
				stmt.setString(2, searchValue);
				stmt.setInt(3, paging.getStart());
				stmt.setInt(4, paging.getPerPage());
				rs = stmt.executeQuery();
			// 블로그 이름, 닉네임, 프로필 사진	
			}else if(searchType.equals("bname") || searchType.equals("nname"))
			{
				nsql = "SELECT nickname, blogname, blog.bno, blog.fname, blog.pname, introduce "
						+ "FROM user u "
						+ "INNER JOIN blog on u.uno = blog.uno "
						+ "WHERE ";
				if(searchType.equals("nname"))
				{
					nsql += "nickname like concat('%', ?, '%') ";
				}else if(searchType.equals("bname"))
				{
					nsql += "blogname like concat('%', ?, '%') ";
				}
				nsql += "LIMIT ?, ? ";                
				nstmt = conn.prepareStatement(nsql);
				nstmt.setString(1, searchValue);
				nstmt.setInt(2, paging.getStart());
				nstmt.setInt(3, paging.getPerPage());
				nrs = nstmt.executeQuery();
			}
		}
		
		
		
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <title>인덱스</title>
    <link rel="stylesheet" href="../css/style.css" type="text/css">
    <script src="../js/jquery-3.7.1.js"></script>
</head>
<body>
    <div id="out_div">
        <header>
            <div class="title_inner">
                <div class="logo">
                    <a href="index.jsp">My Blog</a>
                    <!-- <a href="index.jsp"><span style="font-weight: bold;">My Blog<img src="https://img.icons8.com/?size=100&id=LEjlxdaDOt2I&format=png&color=FFC0CB" style="width: 30px;"></span></a> -->
                </div>
                <%
					if(session.getAttribute("id") != null)
					{
						%>
						<div class="auth_links2">
			                    <!-- <a href="myblog.jsp" class="name"> --><span id="submenu1"><%= (String)session.getAttribute("nickname") %></span><!-- </a> -->님, 환영합니다. 
								<div id="downmenu1" class="sub">
									<a href="../blog/myblog.jsp?bno=<%= Bno %>">나의 블로그</a><br><hr>
									<a href="../blog/setting.jsp?bno=<%= Bno %>">환경설정</a><br><hr>
									<a href="../index/logout.jsp?bno=<%= Bno %>">로그아웃</a>
								</div>
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
							 </div>
						<%
					}else
					{
						%>
		                <div class="auth_links">
		                    <a href="join.jsp">회원가입</a> | <a href="login.jsp">로그인</a>
		                </div>
						<%
					}
				%>
            </div>
            <nav class="header_nav">
                <form class="search_form" action="index.jsp" method="get">
                	<input type="hidden" id="type" name="type" value="<%= type %>">
                    <select name="searchType" style="height:34px;">
                        <option  value="post" <%= searchType.equals("post")? "selected" : "" %>>글</option>
                        <option  value="bname" <%= searchType.equals("bname")? "selected" : "" %>>블로그명</option>
                        <option  value="nname" <%= searchType.equals("nname")? "selected" : "" %>>별명</option>
                    </select>
                    <input type="text" class="search_input" value="<%= searchValue %>" placeholder="검색..." name="searchValue">
                    <button type="submit" class="search_btn">검색</button>
                </form>
            </nav>
        </header>

        <section>
            <article id="art">
            <%
            	if(searchValue == null || searchValue.equals("null") || searchValue.equals(""))
            	{
            	%> 
	                <div class="article_inner">
	                    <p class="pmenu"><img width=20px; src="https://img.icons8.com/?size=100&id=GSmPs057Cr2v&format=png&color=000000"> Best Friend <img width=20px; src="https://img.icons8.com/?size=100&id=GSmPs057Cr2v&format=png&color=000000"></p>
	                    <div class="friend_inner">
	                    <%
	                    while(frs.next())
	            		{
	            			fintroduce = frs.getString("introduce");
	            			fpname  = frs.getString("pname");
	            			ffname = frs.getString("fname");
	            			fbno = frs.getInt("bno");
	            			fnickname = frs.getString("nickname");
	            			fblogname = frs.getString("blogname");
	            			fcount = frs.getString("fcount");
	            			if(fpname != null)
							{
			        			%>
				             	<div class="out">
				             		<a href="../blog/myblog.jsp?bno=<%= fbno %>">
		                            <p class="o"><b>친구 <%= fcount %></b></p>
		                            <div class="image" >
		                            	<img src="<%= request.getContextPath() %>/upload/<%= fpname %>">
		                            	<%-- <img src="../upload/<%= fpname %>"> --%>
		                            <div class="san">
		                                <p><b>별명</b></p>
		                                <p><%= fnickname %></p>
		                                <p><b>소개</b></p>
		                                <p><%= fintroduce %></p>
		                            </div>
		                            </div>
		                            <div class="cont">
		                                <strong><%= fblogname %></strong>
		                            </div>	
		                            </a>
		                        </div>
	        					<%
							}else
							{
				        		%>
				             	<div class="out">
				             		<a href="../blog/myblog.jsp?bno=<%= fbno %>">
		                            <p class="o"><b>친구 <%= fcount %></b></p>
		                            <div class="image" >
		                                <img src="../img/default.jpg">
		                            <div class="san">
		                                <p><b>별명</b></p>
		                                <p><%= fnickname %></p>
		                                <p><b>소개</b></p>
		                                <p><%= fintroduce %></p>
		                            </div>
		                            </div>
		                            <div class="cont">
		                                <strong><%= fblogname %></strong>
		                            </div>	
		                            </a>
		                        </div>
		        				<%
							}
	            		} 
	                    %>
	                    </div>
	                    <p class="pmenu"><img width=20px; src="https://img.icons8.com/?size=100&id=GSmPs057Cr2v&format=png&color=000000"> Best Life <img width=20px; src="https://img.icons8.com/?size=100&id=GSmPs057Cr2v&format=png&color=000000"></p>
	                    <div class="heart_inner">
	                    <%
	                    	int count = 1;
				        	while(hrs.next())
				        	{
				        		// 출력 할 데이터 한행씩 반복
				        		hbname = hrs.getString("blogname");
				        		hnname = hrs.getString("nickname");
				        		htitle = hrs.getString("title");
				        		hcontent = hrs.getString("content");
				        		hbno = hrs.getInt("bno");
				        		hkno = hrs.getInt("kno");
				        		hpname  = hrs.getString("pname");
								hfname  = hrs.getString("fname");
								if(hpname != null)
								{
				        		%>
					             	<div class="heart_content">
			                            <p class="number"><%= count %>.</p>
			                            <div class="heart_text">
			                                <a href="../blog/view.jsp?bno=<%= hbno %>&kno=<%= hkno %>&type=L"><h3><%= htitle %></h3></a> 
			                                <p><%= hcontent %></p> 
			                            </div>
			                            <img src="<%= request.getContextPath() %>/upload/<%= hpname %>" class="heart_img">
			                            <%-- <img src="../upload/<%= hpname %>" class="heart_img"> --%>
			                        </div>
		        				<%
								}else
								{
					        		%>
						             	<div class="heart_content" style="height:110px;">
				                            <p class="number"><%= count %>.</p>
				                            <div class="heart_text">
				                                <a href="../blog/view.jsp?bno=<%= hbno %>&kno=<%= hkno %>&type=L"><h3><%= htitle %></h3></a> 
				                                <p><%= hcontent %></p> 
				                            </div>
				                        </div>
			        				<%
								}
		        				count++;
				        	}
	                    %>
	                    </div>   
	                </div>
	             <%
            	 }else
            	 {
		            int seqNo = total - ((nowPage - 1) * paging.getPerPage());
		        	if(total == 0)
		        	{
		        		%>
		        		<div class="no_data">
	        				<p><h2>'<span><%= searchValue %></span>'에 대한 검색 결과가 없습니다.</h2><br>
							<h3>모든 단어의 철자가 올바른지 확인해 보세요.<br>
							좀 더 일반적인 단어를 사용하거나 다른 키워드로 검색해 보세요.</h3></p>
		        		</div>
		        		<%
		        	}
		        	%>
		        		<div class="post_">
		        	<%
		        	if(!searchType.equals(""))
		    		{
		    			
		    			if(searchType.equals("post"))
		    			{
				        	while(rs.next())
				        	{
				        		// 출력 할 데이터 한행씩 반복
				        		bname = rs.getString("blogname");
				        		nname = rs.getString("nickname");
				        		String pfname = rs.getString("fname");
				        		String ppname = rs.getString("pname");
				        		title = rs.getString("title");
				        		content = rs.getString("content");
				        		rdate = rs.getString("rdate");
				        		bno = rs.getInt("bno");
				        		int kno = rs.getInt("kno");
				        		if(ppname != null)
				        		{
				        		%>
					             	<div class="post_list">
					             		<a href="../blog/myblog.jsp?bno=<%= bno %>">
					             		<p class="post_date"><img src="<%= request.getContextPath() %>/upload/<%= ppname %>">&nbsp;<%= bname %><%= nname %></p>
							            </a>
					             		<a href="../blog/view.jsp?bno=<%= bno %>&type=L&kno=<%= kno %>">
					             		<h2><%= title %></h2>
							            <p class="Post_content"><%= content %></p>
							            <p class="post_date"><%= rdate %></p>
							            </a>
					             	</div>
		        				<%
				        		}else
				        		{
				        		%>
					             	<div class="post_list">
					             		<a href="../blog/myblog.jsp?bno=<%= bno %>">
					             		<p class="post_date"><img src="../img/default.jpg">&nbsp;<%= bname %><%= nname %></p>
					             		</a>
					             		<a href="../blog/view.jsp?bno=<%= bno %>&type=L&kno=<%= kno %>">
					             		<h2><%= title %></h2>
							            <p class="Post_content"><%= content %></p>
							            <p class="post_date"><%= rdate %></p>
							            </a>
					             	</div>
		        				<%
				        		}
				        		
				        	}
		    			}else if(searchType.equals("bname") || searchType.equals("nname") )
		    			{
		    				while(nrs.next())
				        	{
				        		// 출력 할 데이터 한행씩 반복
				        		nbname = nrs.getString("blogname");
				        		nnname = nrs.getString("nickname");
				        		nfname = nrs.getString("fname");
				        		npname = nrs.getString("pname");
				        		nintro = nrs.getString("introduce");
				        		nbno = nrs.getInt("bno");
				        		if(npname != null)
				        		{
				        		%>
					             	<div class="post_list" style="display:flex; width:420px;">
					             		<div style="width:360px;">
					             		<a href="../blog/myblog.jsp?bno=<%= nbno %>">
					             		<p class="post_date"><%= nbname %></p>
					             		<h2><%= nnname %></h2>
							            <p class="post_content"><%= nintro %></p> 
							            </a>
							            </div>
							            <div>
					             		<a href="../blog/myblog.jsp?bno=<%= nbno %>">
							            <img src="<%= request.getContextPath() %>/upload/<%= npname %>" style="width:120px; height:120px; padding-top: 10px; border-radius:50%;">
							            </a>
							            </div>
					             	</div>
		        				<%
				        		}else
				        		{
				        		%>
					             	<div class="post_list" style="display:flex; width:420px;">
					             		<div style="width:360px;">
					             		<a href="../blog/myblog.jsp?bno=<%= nbno %>">
					             		<p class="post_date"><%= nbname %></p>
					             		<h2><%= nnname %></h2>
							            <p class="post_content"><%= nintro %></p> 
							            </a>
							            </div>
							            <div>
					             		<a href="../blog/myblog.jsp?bno=<%= nbno %>">
							            <img src="../img/default.jpg" style="width:120px; height:120px; padding-top: 10px; border-radius:50%;">
							            </a>
							            </div>
					             	</div>
		        				<%
				        		}
				        	}
		    			}
		    		}
		        	%>
			            </div>	
                    <div class="paging_inner">
                    <%
	        		if(paging.getStartPage() > 1)
	        		{
	        			// 시작페이지가 1보다 큰 경우 이전 페이지 존재
	        			%>
	        				<!-- 클릭시 현재 페이지의 시작 페이지 번호 이전 페이지로 이동(13->10)-->
	        				<a href="index.jsp?nowPage=<%= paging.getStartPage() - 1 %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>">&lt;</a>
	        			<%
	        		}
        		
	        		for(int i = paging.getStartPage(); i <= paging.getEndPage(); i++)
	        		{
						if(i == nowPage)
						{
							%>
							<strong><%= i %></strong>
							<%
						}else
						{
							%>
							<a href="index.jsp?nowPage=<%= i %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>"><%= i %></a>
							<%
						}
	        		}
	        		if(paging.getLastPage() > paging.getEndPage())
	        		{
	        			%>
	        			<!-- 클릭시 현재 페이지의 마지막 페이지 번호 다음 페이지로 이동(13->20)-->
	        			<a href="idnex.jsp?nowPage=<%= paging.getEndPage() + 1 %>&searchType=<%= searchType %>&searchValue=<%= searchValue %>">&gt;</a>
	        			<%
	        		}
	        		%>
	        		</div>
	        		<%
				}
	            %>
            </article>
        </section>
<%@ include file="../include/footer.jsp" %>
<%
	}catch(Exception e)
	{
		e.printStackTrace();
		// 오류 출력
		out.print(e.getMessage());
	}finally
	{
		DBConn.close(rsTotal, stmtTotal, null);
		DBConn.close(rs, stmt, conn);
	}
%>
