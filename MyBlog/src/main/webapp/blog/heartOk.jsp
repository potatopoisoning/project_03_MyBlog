<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="ezen.*" %> 
<%
int loginUno = (Integer)session.getAttribute("uno");
int kno = Integer.parseInt(request.getParameter("kno"));
String type = request.getParameter("type");
Integer bno = Integer.parseInt(request.getParameter("bno"));
String state = request.getParameter("state");

Connection conn = null; 
PreparedStatement stmt = null; 
ResultSet rs = null;

try
{
	conn = DBConn.conn();
	
	String sql = "select state from heart where uno = ? and kno = ? ";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, loginUno);
	stmt.setInt(2, kno);
	
	rs = stmt.executeQuery();
	
	if(rs.next())
	{
		sql = "update heart set state = ? where uno = ? and kno = ? ";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, state);
		stmt.setInt(2, loginUno);
		stmt.setInt(3, kno);
	}else{
		sql = "insert into heart (kno, uno, state) values (?, ?, ?)";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, kno);
		stmt.setInt(2, loginUno);
		stmt.setString(3, state);
	}
	
	int result = stmt.executeUpdate();
	
	if(result > 0)
	{
		%>
		<script>
		location.href = "view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>";
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


%>