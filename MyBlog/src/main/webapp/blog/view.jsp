<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%@ page import="java.util.*" %>
<%@ include file="../include/header.jsp" %>
<%
request.setCharacterEncoding("UTF-8");

int kno = Integer.parseInt(request.getParameter("kno"));
/* String type = request.getParameter("type");
if(type == null || type.equals("")) type = "L"; */

//댓글용
PreparedStatement stmtCom = null;
ResultSet rsCom = null;    

PreparedStatement fmstmt = null;
ResultSet fmrs = null;    

String id = "";
String title = "";
String rdate = "";
String state = "";
String content = "";
String weather = "";
String mood = "";
String date = "";
String day = "";
int hit = 0;
int uno = 0;
int count = 0;
String bpname = "";
String bfname = "";

String hstate = "D";
int hcnt = 0;

int fmbno = 0;

List<Comment> commentList = new ArrayList<Comment>();

try
{
	conn = DBConn.conn();

	// 상세데이터 조회
	String sql = "select b.uno, kno, title, content, b.state, date(b.rdate) as rdate, weather, mood, day, date_format(date, '%y년 %m월 %d일') as date, id, hit from board b inner join user u on b.uno = u.uno where kno = ? ";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, kno);
	rs = stmt.executeQuery();
	
	if(rs.next()) 
	{
		title = rs.getString("title");
		id = rs.getString("id");
		rdate = rs.getString("rdate");
		hit = rs.getInt("hit");
		if(!type.equals("Q")) content = rs.getString("content");
		state = rs.getString("state");
		if(type.equals("D")) weather = rs.getString("weather"); 
		if(type.equals("D")) mood = rs.getString("mood");
		if(type.equals("D")) date = rs.getString("date"); 
		if(type.equals("D")) day = rs.getString("day");
		uno = rs.getInt("uno");
	}
	
	sql  = "update board set hit = hit + 1 ";
	sql += "where kno = " + kno ;
	hit++;
	stmt.executeUpdate(sql);
/* 	System.out.println(uno); */
	
	if(!type.equals("Q"))
	{ 
		sql  = "select pname,fname from board where kno = ? ";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, kno);
		rs = stmt.executeQuery();
		
		if(rs.next())
		{
			bpname  = rs.getString("pname");
			bfname  = rs.getString("fname");
		}
	}
	
	// 댓글 조회
	/* String sqlCom = "select c.*, nickname, (select count(cno) from comment inner join board on where kno = b.kno and state = 'E') as count from comment c inner join user u on c.uno = u.uno where kno = ? "; */
	String sqlCom = "select c.*, nickname, id, (select count(*) from comment where kno = b.kno and state = 'E') as count from comment c inner join user u on c.uno = u.uno INNER JOIN board b ON c.kno = b.kno where b.kno = ? ";
	sqlCom += "and c.state = 'E' ";
	sqlCom += "order by c.rdate desc ";
	stmtCom = conn.prepareStatement(sqlCom);
	stmtCom.setInt(1, kno);
	rsCom = stmtCom.executeQuery();
	
	while(rsCom.next())
	{
		if (count == 0) 
		{
	        count = rsCom.getInt("count"); 
	    }
		
		Comment c = new Comment(rsCom.getInt("cno")
						      , rsCom.getInt("kno")
						      , rsCom.getInt("uno")
							  , rsCom.getString("content")
							  , rsCom.getString("rdate")
							  , rsCom.getString("state")
							  , rsCom.getString("id")
							  , rsCom.getString("nickname"));
		
		commentList.add(c);
	}
	
	sql = "select state from heart where uno = ? and kno = ? ";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, loginUno);
	stmt.setInt(2, kno);
	
	rs = stmt.executeQuery();
	
	if(rs.next())
	{
		hstate = rs.getString("state");                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
	}
	
	sql = "select count(*) as hcnt from heart where kno = ? and state = 'E' ";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, kno);
	
	rs = stmt.executeQuery();
	
	if(rs.next())
	{
			hcnt = rs.getInt("hcnt");                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
	}
	
	String fmsql = "select bno, (SELECT u.nickname FROM USER u WHERE u.uno = blog.uno) AS nickname "
		    + "from FRIEND  "
		    + "INNER JOIN blog "
		    + "ON (tbno = blog.bno or rbno = blog.bno) "
		    + "where state = 'Y' and (tbno = ? or rbno = ?) and bno != ?";
	fmstmt = conn.prepareStatement(fmsql);
	fmstmt.setInt(1, bno);
	fmstmt.setInt(2, bno);
	fmstmt.setInt(3, bno);
	
	fmrs = fmstmt.executeQuery();
	
%>
        <main>
            <section>
                <article>
                <%
                	if(type.equals("L"))
                	{
               		%>
	                    <div class="life_view">
	                    	<div class="view_head" style="display: flex; justify-content: space-between;">
		                        <h3>
		                        	<%= title %>
							    </h3>
	                        	<div class="question_actions">
	                        	<%
		                        	if(hstate.equals("D"))
		                        	{
		                        		%>
			                        	<a href="heartOk.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>&state=E"><button>&#x2764; <span style="color:pink;"><%= hcnt %></span></button></a>
		                        		<% 
		                        	}else if(hstate.equals("E"))
		                        	{
		                        	%>
			                        	<a href="heartOk.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>&state=D"><button style="color:red;">&#x2764; <span style="color:pink;"><%= hcnt %></button></a>
		                        	<%
		                        	}
	                        	%>
						        </div>    
							</div>            
				            <div class="life_info">조회수: <%= hit %> | 작성일: <%= rdate %>
				            <%
								if(session.getAttribute("Bno") != null && session.getAttribute("Bno").equals(bno))
								{
									// 로그인한 user와 글쓴이의 uno 값이 같다.
									%>
									<div class="md">
										<!-- &nbsp;|&nbsp;<button type="button">공개</button> -->
										&nbsp;|&nbsp;<button type="button" onclick="location.href='modify.jsp?bno=<%= bno %>&kno=<%= kno %>&type=<%= type %>'">수정 </button>
										&nbsp;|&nbsp;<button type="button" onclick="document.deleteForm.submit();">삭제</button>
									</div>
									<form method="post" name="deleteForm" action="deleteOk.jsp">
										<input type="hidden" name="bno" value="<%= bno %>">
										<input type="hidden" name="kno" value="<%= kno %>">
										<input type="hidden" name="type" value="<%= type %>">
									</form>
									<%
								}
				            %>
				            </div>
				            <%
	                        	if(bpname != null)
	                        	{
	                        		%>
			                        <div class="life_content">
			                        	<img src="<%= request.getContextPath() %>/upload/<%= bpname %>" style="width:580px;"><br>
			                        	<%-- <img src="../upload/<%= bpname %>" ><br> --%>
			                            <%= content.replace("\n", "<br>") %><br>
			                        </div>
	                        		<% 
	                        	}else{
	                        		%>
			                        <div class="life_content">
			                            <%= content.replace("\n", "<br>") %><br>
			                        </div>
	                        		<% 
	                        	}
	                        %>
	                        <div class="list_btn">
	                            <a href="list.jsp?bno=<%= bno %>&type=<%= type %>">목록</a>
	                        </div>
	                        <!-- 댓글 작성 -->
	                        <form name="commentForm" action="" method="post" >
	                        	<input type="hidden" name="bno" value="<%= bno %>">
	                        	<input type="hidden" name="kno" value="<%= kno %>">
	                        	<input type="hidden" name="type" value="<%= type %>">
								<input type="hidden" name="cno">
		                        <div class="write_comment">
		                            <textarea placeholder="댓글을 작성하세요..." name=content></textarea>
		                            <button type="button" onclick="submitComment()">댓글 등록</button>
		                        </div>
	                        </form>
	                        <div class="comments">
	                            <h3>댓글 (<%= count %>)</h3>
	                            	<%
	                            		List<String> friendNicknames = new ArrayList<>();
		                            	while (fmrs.next()) 
		                            	{
		                            	    friendNicknames.add(fmrs.getString("nickname")); // 친구의 닉네임을 List에 저장
		                            	}
										for(Comment c : commentList)
										{
											%>
				                            <div class="comment_item">
				                            	<div class="comment_info" style="display: flex; justify-content: space-between;">
				                            		<div>
				                            		<%= c.getUname() %>
				                            		<%
				                            		 if (c.getUno() == uno) 
				                            		 {
				                                        %>
			                            				<img style="width:16px; height:16px;" src="https://img.icons8.com/?size=100&id=UV25GyzcEBPN&format=png&color=000000">
			                                         	<%
				                                     }
				                            		 if (friendNicknames.contains(c.getUname())) 
				                            		 {
				                            				%>
				                            				<img style="width:15px; height:15px;" src="https://img.icons8.com/?size=100&id=23128&format=png&color=000000">
				                            				<%
			                            			}
				                            		%>
				                            		 | <%= c.getRdate() %>
				                            		 <%
				                            		if(session.getAttribute("uno") != null && session.getAttribute("uno").equals(c.getUno()))
				                            		{
				                                        %>
				                                        <strong style="color:red;">나</strong>
			                                         	<%
				                            		}
				                            		 %>
				                            		 </div>
				                            		 <%
													if(session.getAttribute("uno") != null && session.getAttribute("uno").equals(c.getUno()))
													{
														%>
														<div class="md">
															<!-- location.href -> get 방식 -->
															<button onclick="updateFn('<%= c.getContent() %>', <%= c.getCno() %>);">수정&nbsp;</button>
															<button onclick="deleteFn('<%= c.getCno() %>')">삭제</button>
														</div>
														<%
													}
				                            		 %>
				                            		 </div>
	                                			<div class="comment_text"><%= c.getContent() %></div>
											</div>
											<%
										}
									%>
								<form name="commentDeleteForm" action="commentDeleteOk.jsp" method="post">
									<input type="hidden" name="bno" value="<%= bno %>">
									<input type="hidden" name="cno">
									<input type="hidden" name="kno" value="<%= kno %>">
									<input type="hidden" name="type" value="<%= type %>">
								</form>
	                        </div>
	                    </div>
						<%
                    }
	                if(type.equals("Q"))
	            	{
	                	%>
	                	<div class="qna_list">
	                	<div class="question_item2">
					   	<div class="view_head" style="display: flex; justify-content: space-between;">
		                        <h3>
		                        	<%= title %>
							    </h3>
	                        	<div class="question_actions">
	                        	<%
		                        	if(hstate.equals("D"))
		                        	{
		                        		%>
			                        	<a href="heartOk.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>&state=E"><button>&#x2764; <span style="color: white;"><%= hcnt %></span></button></a>
		                        		<% 
		                        	}else if(hstate.equals("E"))
		                        	{
		                        	%>
			                        	<a href="heartOk.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>&state=D"><button style="color:red;">&#x2764; <span style="color: white;"><%= hcnt %></button></a>
		                        	<%
		                        	}
						if((session.getAttribute("Bno") != null && session.getAttribute("Bno").equals(bno)) || ((session.getAttribute("uno") != null && session.getAttribute("uno").equals(uno))))
							{
								// 로그인한 user와 글쓴이의 uno 값이 같다.
								%>&nbsp;&nbsp;
					            <div class="dropdown2">
								    <div class="dropdown_btn2" id="dropdownButton" style="color: white;">&#x2630;</div>
									    <div class="dropdown_menu2" id="dropdownMenu">
									    <%
									    if(session.getAttribute("uno") != null && session.getAttribute("uno").equals(uno))
									    {
									    %>
										<input type="button" value="수정" onclick="location.href='modify.jsp?bno=<%= bno %>&kno=<%= kno %>&type=<%= type%>'" class="dropdown_link2">
										 <hr class="dropdown-divider">
										 <%
									    }
										 %>
										<input type="button" value="삭제" onclick="document.deleteForm.submit();" class="dropdown_link2">
										<!-- 게시글 삭제를 위한 form -->
										<form method="post" name="deleteForm" action="deleteOk.jsp">
											<input type="hidden" name="bno" value="<%= bno %>">
											<input type="hidden" name="kno" value="<%= kno %>">
											<input type="hidden" name="type" value="<%= type %>">
										</form>
										</div>
								</div>
								<script>
								    // 버튼 클릭 시 메뉴 토글
								    document.getElementById('dropdownButton').addEventListener('click', function() {
								        var menu = document.getElementById('dropdownMenu');
								        if (menu.style.display === 'block') {
								            menu.style.display = 'none';
								        } else {
								            menu.style.display = 'block';
								        }
								    });
								
								    // 클릭 후 외부 클릭 시 메뉴 닫기
								    document.addEventListener('click', function(event) {
								        var menu = document.getElementById('dropdownMenu');
								        var button = document.getElementById('dropdownButton');
								        if (!button.contains(event.target) && !menu.contains(event.target)) {
								            menu.style.display = 'none';
								        }
								    });
								</script>
								<%
							}
						%>
						        </div> 
							</div>     
					        <div class="qna_setting">
							    <span><%= rdate %></span>
						    </div>   
					   	<%
							if(session.getAttribute("Bno") != null && session.getAttribute("Bno").equals(bno))
	                    	{
								%>
								 <form name="commentForm" action="" method="post" >
		                        	<input type="hidden" name="bno" value="<%= bno %>">
		                        	<input type="hidden" name="kno" value="<%= kno %>">
		                        	<input type="hidden" name="type" value="<%= type %>">
									<input type="hidden" name="cno">
			                        <div class="write_comment">
			                            <textarea placeholder="답변을 작성하세요..." name=content></textarea>
			                            <button type="button" onclick="submitComment()">답변 등록</button>
			                        </div>
		                        </form>
		                        <%
		                      }
							if(count == 0)
							{
								%>
								<div class="comment_item2 no_after" style="margin-top: 50px;">
								답변이 등록되지 않았습니다.
								</div>
								<%
		                     } 
	                      %>
		                        <div class="comments2">
	                      <% 
	                    		for(Comment c : commentList)
								{
									%>
		                            <div class="comment_item2">
                              			<div class="comment_text2"><%= c.getContent() %></div>
		                            	<div style="display:flex;  justify-content: space-between;">
		                            	<div class="comment_info2"><%= c.getRdate() %></div>
										<%
										if(session.getAttribute("uno") != null && session.getAttribute("uno").equals(c.getUno()))
										{
											%>
											<div class="md">
												<button onclick="updateFn('<%= c.getContent() %>', <%= c.getCno() %>);">수정&nbsp;</button>
												<button onclick="deleteFn('<%= c.getCno() %>')">삭제</button>
											</div>
											<%
										}
										%>
										</div>
									</div>
									<%
								}
		                        %>
		                        <form name="commentDeleteForm" action="commentDeleteOk.jsp" method="post">
									<input type="hidden" name="bno" value="<%= bno %>">
									<input type="hidden" name="cno">
									<input type="hidden" name="kno" value="<%= kno %>">
									<input type="hidden" name="type" value="<%= type %>">
								</form>
	                    		</div>
						</div>
						</div>
						<%
                    }
	                if(type.equals("D"))
	            	{
	           		%>
	           			<div class="diary_container">
								<%
	                        	if(session.getAttribute("Bno") != null && session.getAttribute("Bno").equals(bno))
								{
									// 로그인한 user와 글쓴이의 uno 값이 같다.
									%>
										<div class="dmd">
											<button type="button" onclick="location.href='modify.jsp?bno=<%= bno %>&kno=<%= kno %>&type=<%= type %>'">수정 </button>
											&nbsp;|&nbsp;<button type="button" onclick="document.deleteForm.submit();">삭제</button>
										</div>
										<form method="post" name="deleteForm" action="deleteOk.jsp">
											<input type="hidden" name="bno" value="<%= bno %>">
											<input type="hidden" name="kno" value="<%= kno %>">
											<input type="hidden" name="type" value="<%= type %>">
										</form>
									<%
								}
	                        	%>
	                        <div class="dwrite_header">
	                            <div>
	                                <!-- 2024 년&nbsp;
	                                9 월&nbsp;
	                                16 일 -->
	                                <%= date %>&nbsp;
	                                <%= day %>요일&nbsp;
	                            </div>
	                            <div class="weather_icons">
	                                날씨 : 
	                                <span class="<%= weather.equals("1") ? "choice" : "" %>">☀️</span>
	                                <span class="<%= weather.equals("2") ? "choice" : "" %>">☁️</span>
	                                <span class="<%= weather.equals("3") ? "choice" : "" %>">🌧️</span>
	                                <span class="<%= weather.equals("4") ? "choice" : "" %>">❄️</span>
	                            </div>
	                        </div>
	                        <div class="dwrite_header">
	                            <!-- 제목 입력 -->
	                            <div class="title_input">
	                                제목 : <%= title %>
	                            </div>
	                            <!-- 기분 선택 -->
	                            <div class="mood_icons">
	                                기분 : 
	                                <span class="<%= mood.equals("1") ? "choice" : "" %>">😊</span>
	                                <span class="<%= mood.equals("2") ? "choice" : "" %>">😐</span>
	                                <span class="<%= mood.equals("3") ? "choice" : "" %>">😢</span>
	                                <span class="<%= mood.equals("4") ? "choice" : "" %>">😡</span>
	                            </div>
	                        </div>
	                        <!-- 그림 업로드 영역 -->
	                        <%
	                        	if(bpname != null)
	                        	{
	                        		%>
			                        <div class="image_grid" contenteditable="false">
			                        	<img src="<%= request.getContextPath() %>/upload/<%= bpname %>">
			                            <%-- <img src="../upload/<%= bpname %>"> --%>
			                        </div>
			                        <div class="diary_note" contenteditable="true">
			                            <%= content %>
			                        </div>
		                    	</div>
	                        		<% 
	                        	}else
	                        	{
	                        		%>
	                        		<div class="image_grid" contenteditable="false" style="height:30px;">
			                        </div>
			                        <div class="diary_note" contenteditable="true" style="height:450px;">
			                            <%= content %>
			                        </div>
		                    	</div>
	                        		<% 
	                        	}
                    }
                %>
                </article>
            </section>
<%@ include file="../include/aside.jsp" %>
<%@ include file="../include/footer.jsp" %>
<script>
	// 화면 최초 로드시에는 등록 타입으로 초기화 
	let submitType = "insert";

	function updateFn(content, cno)
	{
		submitType = "update";
		document.commentForm.content.value = content;
		document.commentForm.cno.value = cno;
	}

	function submitComment()
	{
		// 로그인시에만 submit 처리
		let loginUno = '<%= session.getAttribute("uno") %>'; 
		
		// 'null'로 출력되기 때문에 'null'!
		if(loginUno != 'null')
		{
			if(submitType == 'insert')
			{
				// 등록
				document.commentForm.action = "commentWriteOk.jsp";
				
			}else if(submitType == 'update')
			{
				// 수정
				document.commentForm.action = "commentModifyOk.jsp";
			}
			
			document.commentForm.submit();
		}else
		{
			alert("로그인 후 이용할 수 있습니다.");		
		}
		
	}
	
	function deleteFn(cno)
	{
		// alert(cno);
		
		// 삭제버튼 클릭시 받은 pk 값 cno를 입력양식 cno의 값으로 대입
		document.commentDeleteForm.cno.value = cno;
		document.commentDeleteForm.submit();
	}
</script>
<%
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