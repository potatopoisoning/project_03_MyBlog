package ezen;
import java.sql.*;

public class DBConn
{
	public static final String URL = "jdbc:mysql://localhost:3306/myblog?useUnicode=true&characterEncoding=utf-8&serverTimezone=UTC";
	public static final String USERID = "ydh";
	public static final String USERPW = "ezen";
	
	public static Connection conn() throws Exception 
	{
		Class.forName("com.mysql.cj.jdbc.Driver");
		return DriverManager.getConnection(URL, USERID, USERPW);
	}
	
	public static void close(ResultSet rs, PreparedStatement stmt, Connection conn) throws Exception 
	{
		if(rs != null) rs.close();
		if(stmt != null) stmt.close();
		if(conn != null) conn.close();	
	}

	public static void close(PreparedStatement stmt, Connection conn) throws Exception 
	{
		if(stmt != null) stmt.close();
		if(conn != null) conn.close();	
	}
}
