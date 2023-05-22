<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import="vo.*" %>
<%
	String msg = "";
	//세션 확인 : 로그인 되어있으면 못들어오게 막고 메세지와 함께 돌려보낸다	
	if(session.getAttribute("loginMemberId") != null){
		msg = URLEncoder.encode("로그인되어있습니다","utf-8");
		response.sendRedirect(request.getContextPath()+"/boardList.jsp?msg="+msg);
		return;
	}
	//요청값 디버깅 확인.
	System.out.println(request.getParameter("memberId")+"<-- loginAction memberId");
	System.out.println(request.getParameter("memberPw")+"<-- loginAction memberPw");
	
	String memberId = "";
	if(request.getParameter("memberId") != null){
		memberId = request.getParameter("memberId");
	}
	
	String memberPw = "";
	if(request.getParameter("memberPw") != null){
		memberPw = request.getParameter("memberPw");
	}
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
	// 값 디버깅
	
	System.out.println(memberId+"<--para memberId");
	System.out.println(memberPw+"<--para memberPw");
	
	//디비연결
		String driver="org.mariadb.jdbc.Driver";
		String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
		String dbId = "root"; 
		String dbPw = "java1234";
		Class.forName(driver);
		Connection conn = null;
		PreparedStatement stmt = null;
		
		ResultSet rs = null;
		conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
		
		String sql ="SELECT member_id memberId FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, paramMember.getMemberId());
		stmt.setString(2, paramMember.getMemberPw());
		System.out.println(stmt+"<--setString stmt");
		rs = stmt.executeQuery();
		System.out.println(rs+"<-- loginAction rs");
		
		if(rs.next()){//로그인성공
			//세션 로그인정보(memberId) 저장
			session.setAttribute("loginMemberId", rs.getString("memberId"));
			System.out.println("로그인성공 세션정보 :" +session.getAttribute("loginMemberId"));

		}else {// 로그인실패
			System.out.println("로그인실패");
			msg = URLEncoder.encode("아이디와 비밀번호를 확인해주세요","utf-8");
			response.sendRedirect(request.getContextPath()+"/login.jsp?msg="+msg);
			return;
		}
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
%>
