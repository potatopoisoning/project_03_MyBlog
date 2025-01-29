<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>    
<%@ page import="ezen.*" %>    
<%
request.setCharacterEncoding("UTF-8");
int kno = Integer.parseInt(request.getParameter("kno"));
String type = request.getParameter("type");
Integer bno = Integer.parseInt(request.getParameter("bno"));

String method = request.getMethod(); // "GET" "POST"
if(method.equals("GET") || session.getAttribute("uno") == null)
{
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href="view.jsp?bno=<%= bno %>&kno=<%= kno %>&type=<%= type %>";
	</script>
	<%
}else
{
	String content = request.getParameter("content");
	int loginUno = (Integer)session.getAttribute("uno");
	
	Connection conn = null; 
	PreparedStatement stmt = null; 
	
	try
	{
		conn = DBConn.conn();
		
		String sql = "insert into comment (kno, uno, content) values (?, ?, ?)";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, kno);
		stmt.setInt(2, loginUno);
		stmt.setString(3, content);
		
		int result = stmt.executeUpdate();
		
		if(result > 0)
		{
			%>
			<script>
				alert("댓글 등록이 완료되었습니다. ");
				location.href="view.jsp?bno=<%= bno %>&kno=<%= kno %>&type=<%= type %>";
			</script>
			<%
		}
	}catch(Exception e)
	{
		e.printStackTrace();
		// 오류 출력
		out.print(e.getMessage());
	}finally
	{
		DBConn.close(stmt, conn);
	}	
}

%>
<script>
	alert("댓글 등록이 실패했습니다.");
	location.href="view.jsp?kno=<%= kno %>&type=<%= type %>";
</script>