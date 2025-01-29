<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ezen.*" %> 
<%
// request 안에 있는 문자열 전부 UTF-8 변환
request.setCharacterEncoding("UTF-8");
String id = request.getParameter("id");

Connection conn = null; // DB 연결
PreparedStatement stmt = null;  // SQL 등록 및 실행
ResultSet rs = null;    // 조회 결과를 담음

try
{
	conn = DBConn.conn();
	
	String sql = "select count(*) as cnt from user where id=?";
	stmt = conn.prepareStatement(sql); // 사용할 쿼리 등록
	stmt.setString(1, id); // 쿼리 변수값 등록
	rs = stmt.executeQuery();
	if(rs.next())
	{
		int result = rs.getInt("cnt");
		if(result > 0)
		{
			out.print("isId"); // 아이디 존재시 응답데이터
		}else
		{
			out.print("isNotId"); // 아이디 존재 않을 시 응답데이터
		}
	}
}catch(Exception e)
{
	out.print("error"); // 오류 발생시 응답데이터
	e.printStackTrace();	
}finally
{
	DBConn.close(rs, stmt, conn);
}
%>