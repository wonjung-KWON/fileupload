<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	//세션 유효성검사
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}
		String memberId = (String)session.getAttribute("loginMemberId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="<%=request.getContextPath()%>/insert_member/insertMemberAction.jsp" method="post">
			<fieldset>
	       <legend>회원가입</legend>
	       <%
	       	if(request.getParameter("msg") != null){
	       %>
	       		<div><%=request.getParameter("msg") %></div>
	       <% 
	       	}
	       %>
	        아이디 : <input type="text" name="memberId"><br>
	        비밀번호 : <input type="password" name="memberPw"><br>
	        <button type="submit" class="btn btn-dark">가입하기</button>
	 	  </fieldset>
	</form>
</body>
</html>