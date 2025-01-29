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

int Bno = (Integer)session.getAttribute("Bno");

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

if(request.getMethod().equals("GET"))
{
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href="setting.jsp?bno=<%= Bno %>";
	</script>
	<%
}else 
{
	String id = (String)session.getAttribute("id");
	String bname = multi.getParameter("bname");
	String nname = multi.getParameter("nname");
	String intro = multi.getParameter("intro");
	String fimg = multi.getParameter("fimg_delete"); if(fimg == null || fimg.equals("")) fimg = "X";
	
 	System.out.println("bname: " + bname);
    System.out.println("nname: " + nname);
    System.out.println("intro: " + intro);
    System.out.println("id: " + id);
    
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
	
	try
	{
		conn = DBConn.conn();
		
		if(fimg.equals("C"))
		{
			String sql = "update blog b join user u on b.uno = u.uno set b.introduce = ?, u.blogname = ?, u.nickname = ?, fname = null, pname = null where b.bno = ? ";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, intro);
			stmt.setString(2, bname);
			stmt.setString(3, nname);
			stmt.setInt(4, Bno);
		}else{

			if(filename == null)
			{
				String sql = "update blog b join user u on b.uno = u.uno set b.introduce = ?, u.blogname = ?, u.nickname = ? where b.bno = ? ";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, intro);
				stmt.setString(2, bname);
				stmt.setString(3, nname);
				stmt.setInt(4, Bno);
				
				session.setAttribute("nickname", nname);
				
			}else{
				String sql = "update blog b join user u on b.uno = u.uno set b.introduce = ?, u.blogname = ?, u.nickname = ?, fname = ?, pname = ? where b.bno = ? ";
				stmt = conn.prepareStatement(sql);
				stmt.setString(1, intro);
				stmt.setString(2, bname);
				stmt.setString(3, nname);
				stmt.setString(4, filename);
				stmt.setString(5, phyname);
				stmt.setInt(6, Bno);
				
				session.setAttribute("nickname", nname);
			}
		}

		int result = stmt.executeUpdate();
		System.out.println("Number of rows affected: " + result);

		if(result > 0)
		{
			%>
			<script>
				alert("프로필 수정이 완료되었습니다. ")
				location.href = 'setting.jsp?bno=<%= Bno %>';
			</script>
			<%
		}else 
		{
	          // 결과가 없을 때 처리
	          %>
	          <script>
	              alert("수정할 내용이 없습니다.");
	              location.href = 'setting.jsp?bno=<%= Bno %>';
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
	alert("프로필 수정이 실패했습니다.")
	location.href = 'setting.jsp?bno=<%= Bno %>';
</script>