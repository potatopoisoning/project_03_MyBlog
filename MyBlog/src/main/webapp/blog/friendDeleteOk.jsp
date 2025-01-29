<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ezen.*" %>    
<%
request.setCharacterEncoding("UTF-8");

int fno = Integer.parseInt(request.getParameter("fno"));
int bno = 0;
if(request.getParameter("bno") != null && !request.getParameter("bno").equals("")){
	bno = Integer.parseInt(request.getParameter("bno"));
}
int Bno = (Integer)session.getAttribute("Bno");
String state = ""; 

Connection conn = null; 
PreparedStatement stmt = null;  
ResultSet rs = null;

try
{
	conn = DBConn.conn();
	
	String sql = "select state from friend where fno = ? ";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, fno);
	
	rs = stmt.executeQuery();
	
	if(rs.next())
	{
		state = rs.getString("state");
		if(state.equals("Y"))
		{
			sql = "DELETE FROM friend WHERE fno = ? ";
            stmt = conn.prepareStatement(sql);
			stmt.setInt(1, fno);
			
			int result = stmt.executeUpdate();
			if(result > 0)
			{
				%>
				<script>
					alert("친구가 삭제 되었습니다.");
					location.href = 'myblog.jsp?bno=<%= Bno %>';
				</script>		
				<%
			}
		}else if(state.equals("R"))
		{
			sql = "DELETE FROM friend WHERE fno = ? ";
            stmt = conn.prepareStatement(sql);
			stmt.setInt(1, fno);
			
			int result = stmt.executeUpdate();
			if(result > 0)
			{
				%>
				<script>
					alert("친구요청이 거절 되었습니다.");
					location.href = 'myblog.jsp?bno=<%= Bno %>';
				</script>		
				<%
			}
		}
	}
}catch(Exception e)
{
	e.printStackTrace();
	out.print("오류 발생: " + e.getMessage());
}finally
{
	DBConn.close(stmt, conn);
}
%>
<script>
	alert("친구 삭제가 실패했습니다.");
	location.href = 'myblog.jsp?bno=<%= Bno %>';
</script>	