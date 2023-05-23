<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.util.*" %>
<%
	request.setCharacterEncoding("utf-8");
//세션유효성 검사
	if(session.getAttribute("loginMemberId") == null){
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}
	System.out.println(request.getParameter("boardNo"));
	if(request.getParameter("boardNo") == null
			|| request.getParameter("boardNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	String msg = null;
	//DB연결
		String driver="org.mariadb.jdbc.Driver";
		String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
		String dbId = "root"; 
		String dbPw = "java1234";
		Class.forName(driver);
		//필요한 변수선언
		Connection conn = null;
		ResultSet rs = null;
		int row = 0;
		// 1)서브메뉴 결과셋(모델)
		PreparedStatement stmt = null;
		conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
		//디비연결 디버깅
		System.out.println("디비연결확인");
		
		String deleteSql = "delete from board where board_no = ?";
		stmt = conn.prepareStatement(deleteSql);
		stmt.setInt(1, boardNo);
		row = stmt.executeUpdate();
		//row 값에 실행된 행의 수?를 넣어 적용이 됐는지 안됐는지 if문을 활용하여 체크하여 리다이렉트를 써서 각각의 msg와 함께 보낸다.
		if(row==1){//정상 작동하면 홈페이지로 이동
			System.out.println("삭제완료 removeBoardAction row-->"+row);
			msg = URLEncoder.encode("삭제완료","utf-8");
			response.sendRedirect(request.getContextPath()+"/boardList.jsp?msg="+msg);
			return;	
		} else{
			System.out.println("removeBoardAction row-->"+row);
			msg = URLEncoder.encode("삭제 실패","utf-8");
			response.sendRedirect(request.getContextPath()+"/boardList.jsp"
			+"?boardNo="
			+boardNo
			+"&msg="+msg);
			return;
		}
%>