<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ezen.*" %>    
<%
request.setCharacterEncoding("UTF-8");

int kno = Integer.parseInt(request.getParameter("kno"));
int cno = Integer.parseInt(request.getParameter("cno"));
String type = request.getParameter("type");
String content = request.getParameter("content");
Integer bno = Integer.parseInt(request.getParameter("bno"));

if(request.getMethod().equals("GET"))
{
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href = "view.jsp?bno=<%= bno %>&kno=<%= kno %>&type=<%= type %>";
	</script>		
	<%
}
	
Connection conn = null; 
PreparedStatement stmt = null;  

try
{
	conn = DBConn.conn();
	
	String sql = "update comment set content = ? where cno = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, content);
	stmt.setInt(2, cno);
	
	int result = stmt.executeUpdate();
	
	if(result > 0)
	{
		// 삭제 성공
		%>
		<script>
			alert("댓글이 수정되었습니다.");
			location.href = 'view.jsp?bno=<%= bno %>&kno=<%= kno %>&type=<%= type %>';
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
%>
<script>
	alert("댓글 수정이 실패했습니다.");
	location.href = 'view.jsp?kno=<%= kno %>&type=<%= type %>';
</script>	