<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ezen.*" %>    
<%
int kno = Integer.parseInt(request.getParameter("kno"));
int cno = Integer.parseInt(request.getParameter("cno"));
Integer bno = Integer.parseInt(request.getParameter("bno"));
String type = request.getParameter("type");
if(request.getMethod().equals("GET"))
{
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href = "view.jsp?bno=<%= bno %>&kno=<%= kno %>&type=<%= type %>";
	</script>		
	<%
}else
{
	Connection conn = null; 
	PreparedStatement stmt = null;  
	
	try
	{
		conn = DBConn.conn();
		
		// DB에서 실제 삭제 
		// String sql = "delete from comment where cno = ?";
		
		// DB에서 비활성화
		String sql = "update comment set state = 'D' where cno = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, cno);
		
		int result = stmt.executeUpdate();
		
		if(result>0)
		{
			// 삭제 성공
			%>
			<script>
				alert("댓글이 삭제되었습니다.");
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
}
%>
<script>
	alert("댓글이 실패했습니다.");
	location.href = 'view.jsp?kno=<%= kno %>&type=<%= type %>';
</script>	