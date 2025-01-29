<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ezen.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%

	Connection conn = null; 
	PreparedStatement stmt = null;  
	ResultSet rs = null; 
	
	String uploadPath = "D:\\YDH\\01.java\\workspace\\PJ_1\\src\\main\\webapp\\upload"; 
	// String uploadPath = "C:\\YDH\\workspace\\PJ\\src\\main\\webapp\\upload";   
 	// String uploadPath = "D:\\DH\\workspace\\PJ2\\src\\main\\webapp\\upload"; 

	//게시물 번호
	int kno = Integer.parseInt(request.getParameter("kno"));
	String pname = "";
	String fname = "";

	try
	{
		conn = DBConn.conn();

		String sql = "";
		sql  = "select pname,fname "; 
		sql += "from board ";
		sql += "where kno = " + kno;
		rs = stmt.executeQuery(sql);
		
		if( rs.next() == true)
		{
			pname  = rs.getString("pname");
			fname  = rs.getString("fname");
		}
		
		response.setContentType("application/octet-stream");   
		response.setHeader("Content-Disposition","attachment; filename=" + fname + "");   
		String fullname = uploadPath + "\\" + pname;
		File file = new File(fullname);
		FileInputStream fileIn = new FileInputStream(file);
		ServletOutputStream ostream = response.getOutputStream();
	
		byte[] outputByte = new byte[4096];
		//copy binary contect to output stream
		while(fileIn.read(outputByte, 0, 4096) != -1)
		{
			ostream.write(outputByte, 0, 4096);
		}
		
	}catch(Exception e)
	{
		e.printStackTrace();
		// 오류 출력
		out.print(e.getMessage());
	}finally
	{
		DBConn.close(rs, stmt, conn);
	}
	
%>