<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ezen.*" %>
<%
String methodType = request.getMethod(); // "GET" "POST"

int tbno = Integer.parseInt(request.getParameter("bno"));	
int rbno = (Integer)session.getAttribute("Bno");

Connection conn = null; 
PreparedStatement stmt = null;
ResultSet rs = null;
ResultSet rs2 = null;

try
{
	conn = DBConn.conn();
	
	// 조회
	String sql = "select * from friend where (rbno = ? and tbno = ?) or (rbno = ? and tbno = ?) ";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, rbno);
	stmt.setInt(2, tbno);
	stmt.setInt(3, tbno);
	stmt.setInt(4, rbno);
	
	rs = stmt.executeQuery();
	
	// 데이터 있음
	if(rs.next())
	{
		String state = rs.getString("state");
		
		// 이미 요청중
		if(state.equals("R")) 
	 	{
			sql = "select * from friend where tbno = ? and rbno = ? and state = 'R'";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, rbno);
			stmt.setInt(2, tbno);
			rs2 = stmt.executeQuery();
			// 상대방에서 요청이 이미 들어옴
			if(rs2.next())
			{
				out.print("o");
			
			// 이미 요청중 -> 요청 내역 삭제 (취소)
			}else
			{
	            sql = "DELETE FROM friend WHERE rbno = ? and tbno = ? ";
	            stmt = conn.prepareStatement(sql);
	            stmt.setInt(1, rbno);
	            stmt.setInt(2, tbno);
	            stmt.executeUpdate();
	            out.print("c");
			}
        // 이미 친구 -> 친구 삭제
        }else if(state.equals("Y"))
        {
			sql = "DELETE FROM friend WHERE (rbno = ? and tbno = ?) or (rbno = ? and tbno = ?) ";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, rbno);
			stmt.setInt(2, tbno);
			stmt.setInt(3, tbno);
			stmt.setInt(4, rbno);
			stmt.executeUpdate();
			out.print("d");
        }
	// 데이터 없음 -> 요청
	}else
	{
		sql = "insert into friend (rbno, tbno) values (?, ?) ";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, rbno);
		stmt.setInt(2, tbno);
		stmt.executeUpdate();
		out.print("r");
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