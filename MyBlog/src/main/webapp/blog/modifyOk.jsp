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
request.setCharacterEncoding("UTF-8");
MultipartRequest multi;

String uploadPath = request.getServletContext().getRealPath("/upload");
System.out.println("서버의 업로드 폴더 경로 : " + uploadPath);

// String uploadPath = "D:\\YDH\\01.java\\workspace\\PJ_1\\src\\main\\webapp\\upload";  
// String uploadPath = "C:\\YDH\\workspace\\PJ\\src\\main\\webapp\\upload"; 
// String uploadPath = "D:\\DH\\workspace\\PJ2\\src\\main\\webapp\\upload"; 
int size = 10 * 1024 * 1024;

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
int kno = Integer.parseInt(multi.getParameter("kno"));
String type = multi.getParameter("type");

int bno = Integer.parseInt(multi.getParameter("bno"));

if(request.getMethod().equals("GET"))
{
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href = "view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>";
	</script>		
	<%
}else
{
	
	
	String title = multi.getParameter("title");
	String content = ""; if(!type.equals("Q")) content = multi.getParameter("content");
	String fimg = multi.getParameter("fimg_delete"); if(fimg == null || fimg.equals("")) fimg = "X";
	
	String weather = ""; if(type.equals("D")) weather = multi.getParameter("weather"); 
	String mood = ""; if(type.equals("D")) mood = multi.getParameter("mood");
	String date = ""; if(type.equals("D")) date = multi.getParameter("date"); 
	String day = ""; if(type.equals("D")) day = multi.getParameter("day");
	
	//업로드된 파일명을 얻는다.
	Enumeration files = multi.getFileNames();
	String filename = null;  
	String phyname = null;
	
	if(files.hasMoreElements())
	{
		String fileid = (String) files.nextElement();
		filename = (String) multi.getFilesystemName("bfname");
	
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

	try
	{
		conn = DBConn.conn();
		String sql = "";
		
		if(fimg.equals("C"))
		{
			if(type.equals("L"))
			{
				sql = "update board set title = ?, content = ?, fname = null, pname = null where kno = ?;";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, title);
				stmt.setString(2, content);
				stmt.setInt(3, kno);
			}else if(type.equals("D"))
			{
				sql = "update board set title = ?, content = ?, mood = ?, weather = ?, day = ?, date = ?, fname = null, pname = null where kno = ?;";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, title);
				stmt.setString(2, content);
				stmt.setString(3, mood);
				stmt.setString(4, weather);
				stmt.setString(5, day);
				stmt.setString(6, date);
				stmt.setInt(7, kno);
			}
		}else
		{
			if(filename == null)
			{
				if(type.equals("L"))
				{
					sql = "update board set title = ?, content = ? where kno = ?;";
					stmt = conn.prepareStatement(sql);
					stmt.setString(1, title);
					stmt.setString(2, content);
					stmt.setInt(3, kno);
				}else if(type.equals("Q"))
				{
					sql = "update board set title = ?, content = ? where kno = ?;";
					stmt = conn.prepareStatement(sql);
					stmt.setString(1, title);
					stmt.setString(2, content);
					stmt.setInt(3, kno);
				}else if(type.equals("D"))
				{
					sql = "update board set title = ?, content = ?, mood = ?, weather = ?, day = ?, date = ? where kno = ?;";
					stmt = conn.prepareStatement(sql);
					stmt.setString(1, title);
					stmt.setString(2, content);
					stmt.setString(3, mood);
					stmt.setString(4, weather);
					stmt.setString(5, day);
					stmt.setString(6, date);
					stmt.setInt(7, kno);
				}
			}else{
				if(type.equals("L"))
				{
					sql = "update board set title = ?, content = ?, fname = ?, pname = ? where kno = ?;";
					stmt = conn.prepareStatement(sql);
					stmt.setString(1, title);
					stmt.setString(2, content);
					stmt.setString(3, filename);
					stmt.setString(4, phyname);
					stmt.setInt(5, kno);
				}else if(type.equals("Q"))
				{
					sql = "update board set title = ?, content = ? where kno = ?;";
					stmt = conn.prepareStatement(sql);
					stmt.setString(1, title);
					stmt.setString(2, content);
					stmt.setInt(3, kno);
				}else if(type.equals("D"))
				{
					sql = "update board set title = ?, content = ?, mood = ?, weather = ?, day = ?, date = ?, fname = ?, pname = ? where kno = ?;";
					stmt = conn.prepareStatement(sql);
					stmt.setString(1, title);
					stmt.setString(2, content);
					stmt.setString(3, mood);
					stmt.setString(4, weather);
					stmt.setString(5, day);
					stmt.setString(6, date);
					stmt.setString(7, filename);
					stmt.setString(8, phyname);
					stmt.setInt(9, kno);
				}
			}
		}
		
		
		int result = stmt.executeUpdate();
		
		if(result > 0)
		{
			// 수정 성공
			%>
			<script>
				alert("수정되었습니다.");
				location.href = 'view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>';
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
	alert("수정이 실패했습니다.");
	location.href = 'view.jsp?bno=<%= bno %>&type=<%= type %>&kno=<%= kno %>';
</script>	