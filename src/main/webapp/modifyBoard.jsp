<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
//세션 확인 : 로그인 되어있으면 못들어오게 막고 메세지와 함께 돌려보낸다	
	String msg = "";
	if(session.getAttribute("loginMemberId") == null){
		msg = URLEncoder.encode("로그인해주시길바랍니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/boardList.jsp?msg="+msg);
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(request.getParameter("boardFileNo"));
	
	
	String driver="org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbId = "root"; 
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
	//디비연결 디버깅
	System.out.println("디비연결확인");
	String sql = "SELECT b.board_no boardNo, b.board_title boardTitle, f.board_file_no boardFileNo, f.origin_filename originFilename FROM board b INNER JOIN board_file f ON b.board_no = f.board_no WHERE b.board_no = ? and f.board_file_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, boardNo);
	stmt.setInt(2, boardFileNo);
	ResultSet rs = stmt.executeQuery();
	HashMap<String, Object> map = null;
	if(rs.next()){
		map = new HashMap<>();
		map.put("boardNo", rs.getInt("boardNo"));
		map.put("boardTitle", rs.getString("boardTitle"));
		map.put("boardFileNo", rs.getInt("boardFileNo"));
		map.put("originFilename", rs.getString("originFilename"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>board & boardFile 수정</h1>
	<form action="<%=request.getContextPath()%>/modifyBoardAction.jsp"
			method="post" enctype="multipart/form-data">
			<input type="hidden" name="boardNo" value="<%=map.get("boardNo")%>">
			<input type="hidden" name="boardNo" value="<%=map.get("boardFileNo")%>">
			<table>
				<tr>
					<th>boardTitle</th>
					<td>
						<textarea rows="3" cols="50" name="boardTitle" 
							required="required"><%=map.get("boardTitle")%></textarea>
					</td>
				</tr>
				<tr>
					<th>boardFile(현재 파일 : <%=map.get("originFilename")%>)</th>
					<td>
						<input type="file" name="boardFile" >
					</td>
				</tr>
			</table>
			<button type="submit">수정</button>
	</form>
</body>
</html>