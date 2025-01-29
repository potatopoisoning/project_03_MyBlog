<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ezen.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>  
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>  
<%
String methodType = request.getMethod(); // "GET" "POST"

if (methodType.equals("GET")) {
    %>
    <script>
        alert("잘못된 접근입니다.");
        location.href="join.jsp";
    </script>
    <%
} else {
	request.setCharacterEncoding("UTF-8");
	
    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    String nname = request.getParameter("nickname");
    String bname = request.getParameter("blogname");
    String email = request.getParameter("email");
    
    if (id == null || pw == null || nname == null || bname == null || email == null)
    {
        response.sendRedirect("join.jsp");
        return;
    }
    
    Connection conn = null; 
    PreparedStatement userStmt = null;
    PreparedStatement blogStmt = null;

    try 
    {
        conn = DBConn.conn();
        
        // USER 테이블에 삽입
        String sqlUser = "insert into user (id, password, nickname, blogname, email) values (?, ?, ?, ?, ?)";
        
        userStmt = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
        userStmt.setString(1, id);
        userStmt.setString(2, pw);
        userStmt.setString(3, nname);
        userStmt.setString(4, bname);
        userStmt.setString(5, email);
        
        int userResult = userStmt.executeUpdate();
        
        if (userResult > 0) {
            ResultSet rs = userStmt.getGeneratedKeys();
            int uno = 0;

            if (rs.next()) {
                uno = rs.getInt(1);
            }
            
            String sqlBlog = "insert into blog (introduce, uno) values (?, ?)";
            blogStmt = conn.prepareStatement(sqlBlog);
            blogStmt.setString(1, "환영합니다!");
            blogStmt.setInt(2, uno);
            
            int blogResult = blogStmt.executeUpdate();
            
            if (blogResult > 0) {
                %>
                <script>
                    alert("회원가입에 성공했습니다.");
                    location.href = "index.jsp";
                </script>
                <%
            } else {
                throw new Exception("블로그 생성에 실패했습니다.");
            }
        } else {
            throw new Exception("회원가입에 실패했습니다.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        %>
        <script>
            alert("<%= e.getMessage() %>");
            location.href = "join.jsp";
        </script>
        <%
    } finally {
        DBConn.close(userStmt, conn);
        DBConn.close(blogStmt, null);
    }
}
%>


<%-- <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ezen.*" %> 
<%
// get방식으로 접근 시 login.jsp로 이동
String methodType = request.getMethod(); // "GET" "POST"

if(methodType.equals("GET"))
{
	%>
	<script>
		alert("잘못된 접근입니다.");
		location.href="join.jsp";
	</script>
	<%
}else
{
	String id     = request.getParameter("id");
	String pw     = request.getParameter("pw");
	String nname   = request.getParameter("nickname");
	String bname = request.getParameter("blogname");
	String email  = request.getParameter("email");
	
	if(id == null || pw == null || nname == null || bname == null || email == null)
	{
	    response.sendRedirect("join.jsp");
	    return;
	}
	
	Connection conn = null; 
	PreparedStatement stmt = null;

	try
	{
		conn = DBConn.conn();
		
		/* insert into (id, password, nickname, blogname, email) values (?, ?, ?, ?, ?) */
		String sqlUser = "insert into user (id, password, nickname, blogname, email) values (?, ?, ?, ?, ?)";
		
		stmt = conn.prepareStatement(sqlUser);
		stmt.setString(1, id);
		stmt.setString(2, pw);
		stmt.setString(3, nname);
		stmt.setString(4, bname);
		stmt.setString(5, email);
		
		int result = stmt.executeUpdate();
		
		if(result > 0)
		{
			%>
			<script>
				alert("회원가입에 성공했습니다.");
				location.href = "<%= request.getContextPath() %>/index/index.jsp";
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
	alert("회원가입에 실패했습니다.");
	location.href = "join.jsp";
</script> --%>