<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %> 
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>   
<%@ page import="ezen.*" %>    
<%
String method = request.getMethod(); // "GET" "POST"
if(method.equals("GET") || session.getAttribute("uno") == null)
{
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href="write.jsp";
	</script>
	<%
}else
{
	request.setCharacterEncoding("UTF-8");
	
	String uploadPath = request.getServletContext().getRealPath("/upload");
	System.out.println("서버의 업로드 폴더 경로 : " + uploadPath);
	
	// String uploadPath = "D:\\YDH\\01.java\\workspace\\PJ_1\\src\\main\\webapp\\upload";  
	// String uploadPath = "C:\\YDH\\workspace\\PJ\\src\\main\\webapp\\upload";   
 	// String uploadPath = "D:\\DH\\workspace\\PJ2\\src\\main\\webapp\\upload"; 
	
	int size = 10 * 1024 * 1024;
	MultipartRequest multi;
	try
	{
		multi = 
				new MultipartRequest(request,uploadPath,size,
					"UTF-8",new DefaultFileRenamePolicy());
	}catch(Exception e)
	{
		response.sendRedirect("write.jsp");
		return;
	}

	int Bno = (Integer)session.getAttribute("Bno");
	String bnoParam = multi.getParameter("bno");
	int bno = 0;  
	if (bnoParam != null && !bnoParam.isEmpty())
	{
	        bno = Integer.parseInt(bnoParam);
	}
	int loginUno = (Integer)session.getAttribute("uno");
	String type = multi.getParameter("type");
	String title = multi.getParameter("title");
	String content = multi.getParameter("content");
	
	String weather = ""; if(type != null && type.equals("D")) weather = multi.getParameter("weather"); 
	String mood = ""; if(type != null && type.equals("D")) mood = multi.getParameter("mood");
	String date = ""; if(type != null && type.equals("D")) date = multi.getParameter("date"); 
	String day = ""; if(type != null && type.equals("D")) day = multi.getParameter("day");
	
	//업로드된 파일명을 얻는다.
	Enumeration files = multi.getFileNames();
	String filename = null;  
	String phyname = null;
	
	if(files.hasMoreElements())
	{
		String fileid = (String) files.nextElement();
		filename = (String) multi.getFilesystemName("fname");
	
		if(filename !=  null)
		{
			phyname = UUID.randomUUID().toString();
			String srcName    = uploadPath + "/" + filename; //업로드된 원래 파일명
			String targetName = uploadPath + "/" + phyname;  //저장 후 암호화된 파일명(물리적이름)
			File srcFile    = new File(srcName);
			File targetFile = new File(targetName);
			srcFile.renameTo(targetFile);
		}
	}
	
	Connection conn = null; 
	PreparedStatement stmt = null;
	ResultSet rs = null; 
	
	try
	{
		conn = DBConn.conn();
		String sql = "";
		
		if( type.equals("L"))
		{
			sql = "insert into board (uno, title, content, type, bno, fname, pname) values (?, ?, ?, ?, ?, ?, ?)";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, loginUno);
			stmt.setString(2, title);
			stmt.setString(3, content);
			stmt.setString(4, type);
			stmt.setInt(5, Bno);
			stmt.setString(6, filename);
			stmt.setString(7, phyname);
		}else if( type.equals("Q"))
		{
			sql = "insert into board (uno, title, type, bno) values (?, ?, ?, ?)";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, loginUno);
			stmt.setString(2, title);
			stmt.setString(3, type);
			stmt.setInt(4, bno);
		}else if( type.equals("D"))
		{
			sql = "insert into board (uno, title, content, type, weather, mood, day, date, bno, fname, pname) values (?, ? ,?, ?, ?, ?, ?, ?, ?, ?, ?)";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, loginUno);
			stmt.setString(2, title);
			stmt.setString(3, content);
			stmt.setString(4, type);
			stmt.setString(5, weather);
			stmt.setString(6, mood);
			stmt.setString(7, day);
			stmt.setString(8, date);
			stmt.setInt(9, Bno);
			stmt.setString(10, filename);
			stmt.setString(11, phyname);
		}	
		
		int result = stmt.executeUpdate();
		
		if(result > 0)
		{
			rs = stmt.executeQuery("SELECT LAST_INSERT_ID() as kno");
			int kno = 0;
			if( rs.next() )
			{
				kno = rs.getInt("kno");
			}
			System.out.println(kno); 
			System.out.println(type); 
			System.out.println(bno); 
			%>
			<script>
				alert("등록이 완료되었습니다. ");
			 	
				var type = '<%= type %>';
				
				if(type == "Q")
				{
					location.href = 'view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>';
				}else
				{
				    location.href = 'view.jsp?bno=<%= Bno %>&type=<%= type %>&kno=<%= kno %>';
				}
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
	alert("등록이 실패했습니다.");
	location.href = 'write.jsp';
</script>