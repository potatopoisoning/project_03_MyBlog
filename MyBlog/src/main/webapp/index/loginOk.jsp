<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ezen.*" %> 
<%
// get방식으로 접근 시 login.jsp로 이동
String methodType = request.getMethod(); // "GET" "POST"

if(methodType.equals("GET"))
{
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href="login.jsp";
	</script>
	<%
}else
{
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	
	
	Connection conn = null; 
	PreparedStatement stmt = null;  
	ResultSet rs = null;    

	try
	{
		conn = DBConn.conn();
		
		String sql = "select u.*, bno from user u inner join blog b on u.uno = b.uno where id = ? and password = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, id);
		stmt.setString(2, pw);
		
		rs = stmt.executeQuery();
		
		if(rs.next())
		{
			// id, uno, uauthorization
			String uid = rs.getString("id");
			int uno = rs.getInt("uno");
			int Bno = rs.getInt("bno");
			String authorization = rs.getString("authorization");
			String nickname = rs.getString("nickname");
			
			/*
				- session은 서버에서 관리하는 클라이언트 별 데이터 임시 저장소(브라우저가 꺼지면 임시 저장소가 초기화)
				- session은 웹페이지를 벗어나 하나의 시스템에서 모두 접근할 수 있는 저장소(로그인 처리시 사용)
			*/
			session.setAttribute("id", id); // Attribute 오브젝트 타입
			session.setAttribute("uno", uno); 
			session.setAttribute("Bno", Bno); 
			session.setAttribute("authorization", authorization);
			session.setAttribute("nickname", nickname);

			%>
			<script>
				alert("로그인에 성공했습니다.");
				location.href = "index.jsp";
			</script>
			<%
		}
	}catch(Exception e)
	{
		e.printStackTrace();
		out.print(e.getMessage());
	}finally
	{
		DBConn.close(stmt, conn);
	}
}
%>   
<!-- 로그인 실패(에러 또는 조회 데이터가 없으므로 맨아래 실행문까지 실행됨) --> 
<script>
	alert("로그인에 실패했습니다.");
	location.href = "login.jsp";
</script>