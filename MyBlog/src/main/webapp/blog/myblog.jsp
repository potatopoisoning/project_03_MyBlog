<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");

	try
	{
		conn = DBConn.conn();
		
		// 인기글목록
		String sql = "select type, kno, title, date(b.rdate) as rdate, content, b.bno, hit, b.pname, b.fname, (select count(*) as hcnt from heart where kno = b.kno and state = 'E') as hcnt, introduce " 
				   + "from board b " 
				   + "inner join blog " 
				   + "on b.bno = blog.bno " 
				   + "where b.bno = ? and type = 'L' and state = 'E' "
				   + "order by hcnt desc, hit desc "
				   + "LIMIT 2";
		
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, bno);
		rs = stmt.executeQuery();
%>                    
            <main>
                <section>
                    <article>
                    <div id="myblog">
	                    <div class="blog-intro">
		                    <h2>블로그 소개</h2>
		                    <p><%= intro %></p>
		                </div>
		                <div class="popular-posts">
		                    <h2>인기 게시물</h2>
		                </div>
		                    <div class="popular-posts_list">
		                    <%
			                    while(rs.next())
			                    {
			                    	String title = rs.getString("title");
			                    	String content = rs.getString("content");
			                    	String mpname = rs.getString("pname");
			                    	String mfname = rs.getString("fname");
			                    	String mtype = rs.getString("type");
			                    	int mbno = rs.getInt("bno");
			                    	int mkno = rs.getInt("kno");
			                    	
			                    	if(mpname != null)
			                    	{
				                    %>
				                    <div class="post-card">
				                        <img src="../upload/<%= mpname %>" height="170px">
				                        <div class="post_title">
				                        	<h3><a href="view.jsp?bno=<%= mbno %>&kno=<%= mkno %>&type=<%= mtype %>"><%= title %></a></h3>
			                        	</div>
				                        <p><%= content %></p>
			                   	 	</div>	
			                    	<%
			                    	}else
			                    	{
				                    %>
				                    <div class="post-card">
				                        <div style="height:170px; background-color:white;"></div>
				                        <h3><a href="view.jsp?bno=<%= mbno %>&kno=<%= mkno %>&type=<%= mtype %>"><%= title %></a></h3>
				                        <p><%= content %></p>
			                   	 	</div>	
			                    	<%
			                    	}
			                    }
	                    	%>
	                    	</div>
	                </div>
                    </article>
                </section>
<%@ include file="../include/aside.jsp" %>
<%@ include file="../include/footer.jsp" %>
<%
}catch(Exception e)
{
	e.printStackTrace();
	// 오류 출력
	 out.print("오류가 발생했습니다: " + e.getMessage());
}finally
{
	DBConn.close(rs, stmt, conn);
}
%>
