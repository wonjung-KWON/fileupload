<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.net.*" %>
<%
//세션 확인 : 로그인 되어있으면 못들어오게 막고 메세지와 함께 돌려보낸다	
	String msg = "";
	if(session.getAttribute("loginMemberId") == null){
		msg = URLEncoder.encode("로그인해주시길바랍니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/boardList.jsp?msg="+msg);
		return;
	}
	//세션에 있는 로그인 아이디 변수에 저장 테이블에서 재사용하기위해
	String memberId = (String)session.getAttribute("loginMemberId");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>add board + file</title>
</head>
<body>
	<h1>PDF자료업로드</h1>
	<form action="<%=request.getContextPath()%>/addBoardAction.jsp" method="post" enctype="multipart/form-data">
		<table>
		<!-- 자료 업로드 제목글 -->
			<tr>
				<th>boardTitle</th>
				<td>
					<textarea rows="3" cols="50" name="boardTitle" required="required"></textarea>
				</td>
			</tr>
			<!-- 로그인 사용자 아이디 -->
			<tr>
				<th>memberId</th>
				<td>
					<input type="text" name="memberId" value="<%=memberId%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th>boardFile</th>
				<td>
					<input type="file" name="boardFile" required="required">
				</td>
			</tr>
		</table>
		<button type="submit">자료업로드</button>
	</form>
</body>
</html>