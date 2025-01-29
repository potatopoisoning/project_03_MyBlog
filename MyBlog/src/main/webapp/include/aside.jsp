<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>        
<%@ page import="ezen.*" %>      
<%
	request.setCharacterEncoding("UTF-8");
	
	PreparedStatement fstmtTotal = null;  
	ResultSet frsTotal = null;  
	PreparedStatement fstmtTotal2 = null;  
	ResultSet frsTotal2 = null;
	PreparedStatement fstmt = null;  
	ResultSet frs = null;
	

	
	int cnt = 0; 
	int rcnt = 0; 
	String name = "";
	String fdate = "";
	String fstate = "";
	int fno = 0;
	int rbno = 0;
	int tbno = 0;
	
	Set<Friend> friendsList = new HashSet<>();
	try
	{
		conn = DBConn.conn();
		
		/* String fsqlTotal = "select count(*) as cnt from friend where state = 'Y' and (tbno = ? or rbno = ?) ";
		fstmtTotal = conn.prepareStatement(fsqlTotal);
		fstmtTotal.setInt(1, bno);
		fstmtTotal.setInt(2, Bno);
		frsTotal = fstmtTotal.executeQuery();
		if(frsTotal.next())
		{
			cnt = frsTotal.getInt("cnt"); 
		} */
		
		String fsqlTotal = "select count(*) as rcnt from friend where state = 'R' and (tbno = ?) ";
		fstmtTotal = conn.prepareStatement(fsqlTotal);
		fstmtTotal.setInt(1, Bno);
		frsTotal = fstmtTotal.executeQuery();

		if(frsTotal.next())
		{
			rcnt = frsTotal.getInt("rcnt"); 
		}
		
/* 		String fsql = "SELECT (SELECT u.nickname FROM USER u WHERE u.uno = blog.uno) AS nickname, blog.bno, f.state as fstate, date as fdate, fno FROM friend f INNER JOIN blog ON f.rbno = blog.bno ";
		fsql += "order by f.state = 'R' DESC, fdate desc ";
		fstmt = conn.prepareStatement(fsql);
		fstmt.setInt(1, bno);
		fstmt.setInt(2, Bno);
		frs = fstmt.executeQuery(); */
		
		// 친구 목록
		/* System.out.print("bno:"+bno); */
		String fsql = "select tbno, fno, (SELECT u.nickname FROM USER u WHERE u.uno = blog.uno) AS nickname, FRIEND.state as fstate, date as fdate from FRIEND INNER JOIN blog ON tbno = blog.bno ";
		fsql += "where rbno = ? and (state = 'R' or state = 'Y') order by fstate = 'R' DESC, fdate desc ";
		fstmt = conn.prepareStatement(fsql);
		fstmt.setInt(1, bno);
		frs = fstmt.executeQuery();
		while(frs.next())
		{
			Friend friend = new Friend(frs.getInt("tbno")
				      , frs.getInt("fno")
					  , frs.getString("nickname")
					  , frs.getString("fstate")
					  , frs.getString("fdate")
					  );

			friendsList.add(friend);
		} 
		
		fsql = "select rbno, fno, (SELECT u.nickname FROM USER u WHERE u.uno = blog.uno) AS nickname, FRIEND.state as fstate, date as fdate from FRIEND INNER JOIN blog ON rbno = blog.bno ";
		fsql += "where tbno = ? and (state = 'R' or state = 'Y') order by fstate = 'R' DESC, fdate desc ";
		fstmt = conn.prepareStatement(fsql);
		fstmt.setInt(1, bno);
		frs = fstmt.executeQuery();
		while(frs.next())
		{
			Friend friend = new Friend(frs.getInt("rbno")
				      , frs.getInt("fno")
					  , frs.getString("nickname")
					  , frs.getString("fstate")
					  , frs.getString("fdate")
					  );

			friendsList.add(friend);
		}
		for(Friend friend : friendsList)
		{
			if(friend.getState().equals("Y"))
			{
				cnt++;
			}
		}
%>    
 				<aside>
                    <div class="user_info">
                        <%
                       	if(pname != null)
                       	{
                       		%>
                       			<img src="<%= request.getContextPath() %>/upload/<%= pname %>" width="200px" height="80px">
	                        	<%-- <img src="../upload/<%= pname %>" width="200px" height="80px"> --%>
                       		<% 
                       	}else{
                       		%>
	                        	<img src="../img/default.jpg" width="200px" height="80px"><br>
                       		<% 
                       	}
                        %>
                        <h3>
                        	<a href="../blog/myblog.jsp?bno=<%= bno %>"><%= nname %></a>
                        	<%
                            	if(session.getAttribute("Bno") != null && session.getAttribute("Bno").equals(bno))
                            	{
                            		%>
                        			<a href="<%= request.getContextPath() %>/blog/setting.jsp?bno=<%= Bno %>"><img src="https://img.icons8.com/?size=100&id=8Kt1nqrRoo4W&format=png&color=000000" style="width: 18px; height: 18px;"></a>
                        			<%
                            	}
                   			%>
                        </h3>
                        <div class="dropdown">
                            <p class="dropdown_btn">
                            	친구 <%= cnt %>
                            	<%
                            	if(rcnt > 0 && (session.getAttribute("Bno") != null && session.getAttribute("Bno").equals(bno)))
                            	{
                            		%> <img class="fr" src="https://img.icons8.com/?size=100&id=-4mfBhchw6WG&format=png&color=000000"> <%
                            	}
                            	%>
                           	</p>
	                           <div class="dropdown_menu">
	                           <% 
	                           if( friendsList.size() > 0 && (session.getAttribute("Bno") != null && !session.getAttribute("Bno").equals(bno)))
	                            {
		                           for(Friend friend : friendsList)
		                           {
		                        	   if(friend.getState().equals("Y"))
			                           { 
			                        	   %>
				                           <div class="dropdown_link">
				                               <a href="../blog/myblog.jsp?bno=<%= friend.getBno() %>"><%= friend.getNickname() %></a>
				                           </div> 
				                           <%
			                           }
		                           }
	                            }
	                           if( friendsList.size() > 0 && (session.getAttribute("Bno") != null && session.getAttribute("Bno").equals(bno)))
	                            {
	                        	   for(Friend friend : friendsList)
		                           {
		                        	   fstate = friend.getState();
			                            if(rcnt > 0 && fstate.equals("R"))
			                            { 
			                            %> 	
			                            	<div class="dropdown_link">
			                                    <a href="../blog/myblog.jsp?bno=<%= friend.getBno() %>"><%= friend.getNickname() %></a>
			                            		<div class="fbtn">
			                                    	<a href="../blog/friendAcceptanceOk.jsp?bno=<%= friend.getBno() %>"><button class="friend_">수락</button></a>
			                                    	<a href="../blog/friendDeleteOk.jsp?bno=<%= friend.getBno() %>&fno=<%= friend.getFno() %>"><button class="friend_">거절</button></a>
			                                    </div>	
			                                </div> 
	                                   	<%
			                            }
			                            if(fstate.equals("Y"))
			                            { 
			                            %>
				                            <div class="dropdown_link">
			                                    <a href="../blog/myblog.jsp?bno=<%= friend.getBno() %>"><%= friend.getNickname() %></a>
					                            <div class="fbtn">
				                                    <a href="../blog/friendDeleteOk.jsp?bno=<%= friend.getBno() %>&fno=<%= friend.getFno() %>"><button class="friend_delete">&#9746;</button></a>
			                                    </div>	
			                                </div> 
			                            <%
			                            }
		                           }
	                            }
                            	%>
                              </div>
                    	</div>
                    	<%
                    	if((session.getAttribute("Bno") != null && !session.getAttribute("Bno").equals(bno)))
		                {
                    		fstate = "";
                    		int fbno = 0;
                    	    for (Friend friend : friendsList) 
                    	    {
                    	    	System.out.println(friendsList.size());
                    	        if ((friend.getState().equals("Y") || friend.getState().equals("R")) && friend.getBno() == Bno)
                    	        {
                    	        	/* System.out.println(friend.getState());
                    	        	System.out.println(friend.getBno()); */
                    	            fstate = friend.getState();
                    	            break; 
                    	        }
                    	    }
                    		if((!fstate.equals("Y") && !fstate.equals("R")) || fstate.equals("") || fstate == null)
                    		{
	                    		%>
	                    		<button class="friend_btn">친구 요청</button>
	                    		<%
                    		}else if(fstate.equals("Y"))
                    		{
	                    		%>
	                    		<button class="friend_btn">친구<!-- <img style="width:15px; height:15px;" src="https://img.icons8.com/?size=100&id=qUmnqktmy7Kv&format=png&color=000000"> --></button>
	                    		<%
                    		}else if(fstate.equals("R"))
                    		{
	                    		%>
	                    		<button class="friend_btn">친구 요청중</button>
	                    		<%
                    		}
		                }
                    	 %>
                    </div>
                    <script>
                    	window.onload = function(){
                    		$(".friend_btn").click(function(){
                    			$.ajax ({
                    				url: "../blog/friendRequestOk.jsp",
                    				type: "post",
                    				data: {bno:"<%= bno %>"},
                    				success : function(result)
                    				{
                    					result = result.trim();
                    					switch(result)
                    					{
                    						case "c":
                    							alert("친구요청이 취소되었습니다.");
                    							location.reload(true);
                    							break;
                    						case "r":
                    							alert("친구요청 되었습니다.");
                    							location.reload(true);
                    							break;
                    						case "d":
                    							alert("친구가 삭제 되었습니다.");
                    							location.reload(true);
                    							break;
                    						case "o":
                    							alert("이미 상대방에게 친구요청이 었습니다.");
                    							location.reload(true);
                    							break;
                    					}
                    				}
                    			});
                    		})
                    	}
                    </script>
                    <div class="menu">
	                    <button onclick="location.href='list.jsp?bno=<%= session.getAttribute("bno") != null && session.getAttribute("bno").equals(Bno) ? Bno : bno %>&type=L'" class="<%= type.equals("L") ? "active" : "" %>">일상</button>
	                    <button onclick="location.href='list.jsp?bno=<%= session.getAttribute("bno") != null && session.getAttribute("bno").equals(Bno) ? Bno : bno %>&type=Q'" class="<%= type.equals("Q") ? "active" : "" %>">Q&A</button>
	                    <button onclick="location.href='list.jsp?bno=<%= session.getAttribute("bno") != null && session.getAttribute("bno").equals(Bno) ? Bno : bno %>&type=D'" class="<%= type.equals("D") ? "active" : "" %>">일기</button> 
                    </div>
                </aside>
            </main>
            <%}catch(Exception E) {} %>