<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<!-- home 내용 : 로그인폼 / 카테고리별 게시글 5개씩 -->
			<!-- 로그인 폼 -->
				<%
					if(session.getAttribute("loginMemberId") == null){// 로그인전이라면 로그인폼출력
				%>
					<form action="<%=request.getContextPath()%>/loginAction.jsp" method="get">
						<table class="table">
							<tr>
						        <td>
						        <%
						        	if(request.getParameter("msg") != null){
						        %>
						        		<div><%=request.getParameter("msg") %></div>
						        <% 
						        	}
						        %>
						        </td>
				       		</tr>
							<tr>
								<td>ID 로그인</td>
							</tr>
							<tr>
								<td>아이디</td>
								<td><input type="text" name="memberId" placeholder="username"></td>
							</tr>
							<tr>
								<td>비민번호</td>
								<td><input type="password" name="memberPw" placeholder="PASSWORD"></td>
							</tr>
						</table>
						<button type="submit" class="btn btn-dark">로그인</button>
					</form>
				<% 		
					}
				%>
</body>
</html>