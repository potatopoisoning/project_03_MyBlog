<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ezen.*" %>    
<%
request.setCharacterEncoding("UTF-8");

int bno = Integer.parseInt(request.getParameter("bno"));
int Bno = (Integer)session.getAttribute("Bno");

Connection conn = null; 
PreparedStatement stmt = null;  

try
{
	conn = DBConn.conn();
	
	String sql = "update friend set state = 'Y' where rbno = ? and tbno = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, bno);
	stmt.setInt(2, Bno);
	
	int result = stmt.executeUpdate();
	
	if(result > 0)
	{
		// 삭제 성공
		%>
		<script>
			alert("친구요청이 수락 되었습니다.");
			location.href = 'myblog.jsp?bno=<%= Bno %>';
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
	alert("친구 수락이 실패했습니다.");
	location.href = 'myblog.jsp?bno=<%= Bno %>';
</script>