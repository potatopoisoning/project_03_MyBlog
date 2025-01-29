<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");
%>                    
            <main>
                <section>
                    <article>
                        <div id="setting">
                            <h2>프로필 수정</h2>
                            <form action="settingOk.jsp" method="post" enctype="multipart/form-data">
                            	<input type="hidden" name="type" value="<%= type %>">
                            	<input type="hidden" name="bno" value="<%= Bno %>">
                            	<%-- <input type="hidden" name="id" value="<%= session.getAttribute("id") %>"> --%>
                                <div class="input_group">
                                    <label for="blog_name">블로그명</label>
                                    <input type="text" name="bname" id="blog_name" placeholder="블로그명을 입력하세요" value="<%= bname %>" required>
                                </div>
                                <div class="input_group">
                                    <label for="nickname">별명</label>
                                    <input type="text" name="nname" id="nickname" placeholder="별명을 입력하세요" value="<%= nname %>" required>
                                </div>
                                <div class="input_group">
                                    <label for="intro">소개글</label>
                                    <input type="text" name="intro" id="intro" placeholder="소개글을 입력하세요" value="<%= intro %>">
                                </div>
                                <div class="input_group">
                                    <label for="profile_image">프로필 이미지</label>
                                    <input type="file" name="fname" id="profile_image" accept="image/*">
                                    <input type="checkbox"  id="hide_image" name="fimg_delete" value="C">x
                                    <% 
                                   		if (fname == null || fname.equals("")) 
									    {
								    		%>
									        <img src="../img/default.jpg" alt="기본 프로필 이미지" style="max-width: 100px;" id="fimg">
									   		<% 
									    }else
	                                    { 
	                                    	%>
									       	<img src="../upload/<%= pname %>" alt="현재 프로필 이미지" style="max-width: 100px;" id="fimg">
									    	<% 
									    } 
									 %>
									 <script>
										// 이미지와 체크박스 요소를 가져옵니다.
									    const imgElement = document.getElementById("fimg");
									    const checkbox = document.getElementById("hide_image");

									    // 현재 이미지 경로 저장
									    const originalImageSrc = imgElement.src;
									    const defaultImageSrc = "../img/default.jpg"; // 기본 이미지 경로

									    // 체크박스 상태가 변경될 때마다 실행되는 이벤트 핸들러
									    checkbox.addEventListener("change", function() 
							    		{
									        if (this.checked) 
									        {
									            imgElement.src = defaultImageSrc;  // 체크박스가 선택되면 기본 이미지로 변경
									        } else 
									        {
									            imgElement.src = originalImageSrc; // 체크박스 선택 해제되면 원래 이미지로 복구
									        }
									    });
    								</script>
                                </div>
                                <button type="submit" class="_btn">프로필 업데이트</button>
                            </form>
                            <div class="back">
                                <a href="../blog/myblog.jsp?bno=<%= Bno %>">뒤로 가기</a>
                            </div>
                        </div>
                    </article>
                </section>
<%@ include file="../include/aside.jsp" %>
<%@ include file="../include/footer.jsp" %>
