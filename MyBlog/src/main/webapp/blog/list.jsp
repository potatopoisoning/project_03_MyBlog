<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>    
<%@ include file="../include/header.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");

	/* String type = request.getParameter("type");
	if(type == null || type.equals("")) type = "L";
	if(searchValue == null || searchValue.equals("null")) searchValue = "";
	 */
	int nowPage = 1;
	
	if(request.getParameter("nowPage") != null)
	{
		nowPage = Integer.parseInt(request.getParameter("nowPage"));
	}
	
	PreparedStatement stmtTotal = null;  
	ResultSet rsTotal = null;  
	
	int total = 0; 
	String title = "";
	String content = "";
	String rdate = "";
	String state = "";
	String date = "";
	String bpname = "";
	String bfname = "";
	String stype = "";
	
	try
	{
		conn = DBConn.conn();
		
		// 페이징
		String sqlTotal = "";
		
		sqlTotal += "select count(*) as total from board b inner join user u on b.uno = u.uno ";
		
		if(type.equals(""))
		{
			if(searchValue.equals(""))
			{
				sqlTotal += "where type != 'D' and b.bno = ? and b.state = 'E' ";
				sqlTotal += "and (title like concat('%', null, '%') or content like concat('%', null, '%')) ";
				stmtTotal = conn.prepareStatement(sqlTotal);
				stmtTotal.setInt(1, bno);
			}
			else
			{
				sqlTotal += "where type != 'D' and b.bno = ? and b.state = 'E' ";
				sqlTotal += "and (title like concat('%', ?, '%') or content like concat('%', ?, '%')) ";
				stmtTotal = conn.prepareStatement(sqlTotal);
				stmtTotal.setInt(1, bno);
				stmtTotal.setString(2, searchValue);
				stmtTotal.setString(3, searchValue);
			}
			
			
			/* System.out.println(sqlTotal); */
		}else
		{
			if(type.equals("Q"))
			{
				sqlTotal += "where type = 'Q' and b.bno = ? and b.state = 'E' ";
				
			}else if(type.equals("L"))
			{
				sqlTotal += "where type = 'L' and b.bno = ? and b.state = 'E' ";
				
			}else if(type.equals("D"))
			{
				sqlTotal += "where type = 'D' and b.bno = ? and b.state = 'E' ";
			}
			stmtTotal = conn.prepareStatement(sqlTotal);
			stmtTotal.setInt(1, bno);
			
			/* System.out.println(sqlTotal); */
		}
		
		rsTotal = stmtTotal.executeQuery();
		
		
		if(rsTotal.next())
		{
			total = rsTotal.getInt("total");
			/* out.print("total" + total); */
		}
		PagingUtil paging = null;
		if(!searchValue.equals(""))
		{
			paging = new PagingUtil(nowPage, total, 4);
		}else
		{
			paging = new PagingUtil(nowPage, total, 3);
		}
		
		
		// 글목록
		String sql = "select type, kno, title, id, date(b.rdate) as rdate, content, b.bno, weather, mood, date_format(date, '%y년 %m월 %d일') as date, day, " 
				   + "(select count(cno) from comment where kno = b.kno and state = 'E') as count, nickname, pname, fname " 
				   + " from board b " 
				   + "inner join user u " 
				   + "on b.uno = u.uno ";
		
		if(type.equals(""))
		{
			if(searchValue.equals(""))
			{
	 			sql += "where type != 'D' and b.bno = ? and b.state = 'E' ";
	 			sql += "and (title like concat('%', null, '%') or content like concat('%', null, '%')) ";
			}else
			{
	 			sql += "where type != 'D' and b.bno = ? and b.state = 'E' ";
	 			sql += "and (title like concat('%', ?, '%') or content like concat('%', ?, '%')) ";
			}
		}else
		{
			if(type.equals("L")) // 일상
			{
				sql += "where b.bno = ? and type = 'L' and  b.state = 'E' ";
				
			}else if(type.equals("Q")) // qna
			{
				sql += "where b.bno = ?  and type = 'Q' and  b.state = 'E' "; 
				
			}else if(type.equals("D")) // 일기
			{
				sql += "where b.bno = ? and type = 'D' and  b.state = 'E' ";
				sql += "order by date desc ";
				sql += "limit ?, ?;"; 
				stmt = conn.prepareStatement(sql);
				/* System.out.print(sql); */
			}
		} 
		
		if(!type.equals("D") || type.equals(""))
		{
			sql += "order by kno desc ";
			sql += "limit ?, ?;"; 
			stmt = conn.prepareStatement(sql);
			/* System.out.print(sql); */
		}
 		
		if(!searchValue.equals("")) // 검색어 O
		{
			stmt.setInt(1, bno);
			stmt.setString(2, searchValue);
			stmt.setString(3, searchValue);
			stmt.setInt(4, paging.getStart());
			stmt.setInt(5, paging.getPerPage());
		}else // 검색어 X
		{
			stmt.setInt(1, bno);
			stmt.setInt(2, paging.getStart());
			stmt.setInt(3, paging.getPerPage());
		}
		
		rs = stmt.executeQuery();
%>
<main>
	<section>
		<article>
           	<%
           	if(type.equals(""))
           	{
		 		%>
           		<div id="sblog_list">
		 		<div class="popular-posts_list" style="height:625px">
           		<%	
	        		/* out.print(searchValue); */
           		if(total == 0 || searchValue.equals(""))
	        	{
	        		%>
	        		<div class="no_data">
        				<p><h2>'<span><%= searchValue %></span>'에 대한 검색 결과가 없습니다.</h2><br>
						<h3>모든 단어의 철자가 올바른지 확인해 보세요.<br>
						좀 더 일반적인 단어를 사용하거나 다른 키워드로 검색해 보세요.</h3></p>
	        		</div>
	        		<%
	        	}
	        	while(rs.next())
	        	{
	        		// 출력 할 데이터 한행씩 반복
	        		title = rs.getString("title");
	        		content = ""; if(type.equals("L")) content = rs.getString("content");
	        		pname = rs.getString("pname");
	        		fname = rs.getString("fname");
	        		stype = rs.getString("type");
	        		bno = rs.getInt("bno");
	        		int kno = rs.getInt("kno");
	        		if(pname != null)
	        		{
	        		/* out.print(type); */
	        		%>
	        		<div class="post-card" style="height:239px">
                        <img src="../upload/<%= pname %>" height="170px" >
                        <h3 style="margin: 0; margin-bottom:10px;"><a href="view.jsp?bno=<%= bno %>&kno=<%= kno %>&type=<%= stype %>"><%= title %></a></h3>
			            <p class="post_content" style="margin: 0;"><%= content %></p>
               	 	</div>
	        		<%
               	 	 }else
               	 	 {
               	 		  %>
		        		<div class="post-card" style="height:239px">
		        			<div style="height:172.5px; background-color:white;"></div>
	                        <h3 style="margin: 0; margin-bottom:10px;"><a href="view.jsp?bno=<%= bno %>&kno=<%= kno %>&type=<%= stype %>"><%= title %></a></h3>
				            <p class="post_content" style="margin: 0;"><%= content %></p>
	               	 	</div>
	               	 	<%
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
					<a href="list.jsp?bno=<%= bno %>&nowPage=<%= paging.getStartPage() - 1 %>&searchValue=<%= searchValue %>&type=<%= type %>">&lt;</a>
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
						<a href="list.jsp?bno=<%= bno %>&nowPage=<%= i %>&searchValue=<%= searchValue %>&type=<%= type %>"><%= i %></a>
						<%
					}
				}
				if(paging.getLastPage() > paging.getEndPage())
				{
					%>
					<!-- 클릭시 현재 페이지의 마지막 페이지 번호 다음 페이지로 이동(13->20)-->
					<a href="list.jsp?bno=<%= bno %>&nowPage=<%= paging.getEndPage() + 1 %>&searchValue=<%= searchValue %>&type=<%= type %>">&gt;</a>
					<%
				}
			%>
			</div>
			</div>
		<%
           	}else
           	{
           		/* System.out.print(searchValue); */
				if(type.equals("L"))
				{
					%>
					<div class="life_list">
					    <div class="life_header">
					        <h2>일 상</h2>
					        <%
					        if(session.getAttribute("Bno") != null && session.getAttribute("Bno").equals(bno))
					        {
					        	%>
					        	<button class="write_btn" onclick="location.href='write.jsp?bno=<%= Bno %>&type=<%= type %>'">일상 쓰기</button>
						        <%
				        	}
				        	%>
					</div>
					<%
				}
				if(type.equals("D"))
				{
					if(session.getAttribute("Bno") != null && !session.getAttribute("Bno").equals(bno))
					{
						%>
						<script>
							alert("권한이 없습니다.");
							history.back();
						</script>
						<%
					}
					%>
					<div class="diary_list">
					    <div class="diary_header">
					        <h2>일 기</h2>
					        <%
					        if(session.getAttribute("Bno") != null && session.getAttribute("Bno").equals(bno))
					        {
					        	%>
						        <button class="write_btn" onclick="location.href='write.jsp?bno=<%= Bno %>&type=<%= type %>'">일기 쓰기</button>
						        <%
				        	}
				        	%>
					</div>
					<%
				}
				if(type.equals("Q"))
				{
					%>
					<div class="qna_list">
						    <div class="qna_header">
						        <h2>Q & A</h2>
				        <%
						if(session.getAttribute("Bno") != null && !session.getAttribute("Bno").equals(bno))
						{
							%>
							<button class="write_btn" onclick="location.href='write.jsp?bno=<%= bno %>&type=<%= type %>'">질문 하기</button>
							<%
						}
						%>
						</div>
					<%
				}
				int seqNo = total - ((nowPage - 1) * paging.getPerPage());
				if(total == 0)
				{
					%>
					<p>등록된 글이 없습니다.</p>
					<%
	            }
	            while(rs.next())
				{
					// 출력 할 데이터 한행씩 반복
					bno = rs.getInt("bno");
					int kno = rs.getInt("kno");
					title = rs.getString("title");
					content = ""; 
					if(!type.equals("Q")) 
					{
						content = rs.getString("content");
					}
					bpname  = rs.getString("pname");
					bfname  = rs.getString("fname");
					rdate = rs.getString("rdate");
					String weather = "";
					String mood = "";
					date = ""; 
					String day = ""; 
					if(type.equals("D")) 
					{
						weather = rs.getString("weather"); 
						mood = rs.getString("mood");
						date = rs.getString("date"); 
						day = rs.getString("day");
					}
					/* String qnname = ""; if(type.equals("Q")) qnname = rs.getString("nickname"); */
					int count = rs.getInt("count");
	
					if(type.equals("L"))
	                {
                       	if(bpname != null)
                       	{
                       		%>
							<div class="life">
							    <div class="text_content">
						        <h3><a href="view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>"><%= title %></a></h3>
								<p><%= content %></p>
								<div class="qna_setting">
								    <span><%= rdate %></span>
							    </div>
							    </div>
				    			<img src="../upload/<%= bpname %>" class="life_img">
							</div>
                       		<% 
                       	}else
                       	{
                       		%>
							<div class="life">
							    <div class="text_content" style="height:135px;">
						        <h3><a href="view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>"><%= title %></a></h3>
								<p><%= content %></p>
								<div class="qna_setting">
								    <span><%= rdate %></span>
							    </div>
							    </div>
							</div>
                       		<% 
                       	}
					}
					if(type.equals("D"))
	                {
                       	if(bpname != null)
                       	{
                		%>
						<div class="diary">
						    <div class="text_content">
						        <a href="view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>"><h3><%= title %></h3></a>
								<p><%= content %></p>
								<div class="qna_setting">
								    <span><%= date %></span>
							    </div>
						    </div>
						    <img src="../upload/<%= bpname %>" class="diary_img">
						</div>
						<%
                       	}else
                       	{
                		%>
						<div class="diary">
						    <div class="text_content" style="height:135px;">
						        <a href="view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>"><h3><%= title %></h3></a>
								<p><%= content %></p>
								<div class="qna_setting">
								    <span><%= date %></span>
							    </div>
						    </div>
						</div>
						<%
                       	}
					}		
					if(type.equals("Q"))
					{
						%>
						<div class="question_item">
						   	<a href="view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>"><h3 id="qnote">
						   		<%= title %>
						   		<%
						   		if(count > 0)
						   		{
						   			%>
						   			<답변 등록 완료!>
						   			<%
						   		}
						   		 %>
						   	</h3></a>
							<div class="qna_setting">
							    <span><%= rdate %></span>
						        <!-- <div class="question_actions">
						            <span>1</span>
						            <button>&#x2764;</button>
						            <button>&#x2630;</button>
						        </div> -->
						    </div>
						</div>
						<%
						} 
					}
	           	%>
				<div class="paging_inner">
				<%
				if(paging.getStartPage() > 1)
				{
					// 시작페이지가 1보다 큰 경우 이전 페이지 존재
					%>
					<!-- 클릭시 현재 페이지의 시작 페이지 번호 이전 페이지로 이동(13->10)-->
					<a href="list.jsp?bno=<%= bno %>&nowPage=<%= paging.getStartPage() - 1 %>&searchValue=<%= searchValue %>&type=<%= type %>">&lt;</a>
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
						<a href="list.jsp?bno=<%= bno %>&nowPage=<%= i %>&searchValue=<%= searchValue %>&type=<%= type %>"><%= i %></a>
						<%
					}
				}
				if(paging.getLastPage() > paging.getEndPage())
				{
					%>
					<!-- 클릭시 현재 페이지의 마지막 페이지 번호 다음 페이지로 이동(13->20)-->
					<a href="list.jsp?bno=<%= bno %>&nowPage=<%= paging.getEndPage() + 1 %>&searchValue=<%= searchValue %>&type=<%= type %>">&gt;</a>
					<%
				}
			%>
			</div>
		</div>
		<%
			}
		%>
	</article>
</section>
<%@ include file="../include/aside.jsp" %>
<%@ include file="../include/footer.jsp" %>
<%
}catch(Exception e)
{
	e.printStackTrace();
	// 오류 출력
	 out.print("오류가 발생했습니다: " + e.getMessage());
}finally
{
	DBConn.close(rs, stmt, conn);
}
%>