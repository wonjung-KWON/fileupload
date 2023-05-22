<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
/*
	"SELECT b.board_title boardTitle, f.origin_filename originfilename,
	FROM board b INNER JOIN board_file f ON b.board_no = f.board_no 
	ORDER BY b.createdate DESC";
*/
	String driver="org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbId = "root"; 
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
	//디비연결 디버깅
	System.out.println("디비연결확인");
	String sql = "SELECT b.board_title boardTitle, f.origin_filename originFilename, f.save_filename saveFilename, path FROM board b INNER JOIN board_file f ON b.board_no = f.board_no ORDER BY b.createdate DESC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery();
	ArrayList<HashMap<String, Object>> list = new ArrayList<>();
	while(rs.next()){
		HashMap<String, Object> m = new HashMap<>();
		m.put("boardTitle", rs.getString("boardTitle"));
		m.put("originFilename", rs.getString("originFilename"));
		m.put("saveFilename", rs.getString("saveFilename"));
		m.put("path", rs.getString("path"));
		list.add(m);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<%
			if(session.getAttribute("loginMemberId") == null){// 로그인전이라면 로그인폼출력
		%>
			<a href="<%=request.getContextPath()%>/login.jsp">로그인</a>
		<%
			}
		%>
	<a href="<%=request.getContextPath()%>/addBoard.jsp">파일 추가</a>
	<h1>PDF 자료 목록</h1>
	<table>
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
			<td>boardTitle</td>
			<td>originFilename</td>
		</tr>
		<%
			for(HashMap<String, Object> m : list){
		%>
		<tr>
			<td><%=(String)m.get("boardTitle")%></td>
			<td>
				<a href="<%=request.getContextPath()%><%=(String)m.get("path")%>/<%=(String)m.get("saveFilename")%>" download="<%=(String)m.get("saveFilename")%>">
					<%=(String)m.get("originFilename")%>
				</a>
			</td>
			<td>
				<a href="<%=request.getContextPath()%>/modifyBoard.jsp">수정</a>
			</td>
			<td>
				<a href="<%=request.getContextPath()%>/removeBoard.jsp">삭제</a>
			</td>
		</tr>
		<%
			}
		%>
	</table>
</body>
</html>