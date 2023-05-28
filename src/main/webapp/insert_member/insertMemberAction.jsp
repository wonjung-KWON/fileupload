<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "java.util.*" %>
<%
	// 로그인 안되어있으면 못들어오게 하는 if문활용
	if(session.getAttribute("loginMemberId") != null){
		response.sendRedirect(request.getContextPath()+"/boardList.jsp");
		return;
	}
	System.out.println(request.getParameter("memberId")+"<--insertMemberAction.jsp memberId");
	System.out.println(request.getParameter("memberPw")+"<--insertMemberAction.jsp memberPw");

	String msg ="";
	//요청값 유효성 검사
	// if문을 활용하여 para값이 널이나 공백으로 들어오면 리다이렉트를 활용하여 msg값을 같과 함께 값을 보낸 페이지로 돌려보낸다.
	if(request.getParameter("memberId") == null 
		|| request.getParameter("memberId").equals("")
		|| request.getParameter("memberPw") == null 
		|| request.getParameter("memberPw").equals("")){
			msg = URLEncoder.encode("ID와 비밀번호를 모두 입력해주세요","utf-8");
			response.sendRedirect(request.getContextPath()+"/insertMember.jsp?msg="+msg);
			return;
	}
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	//요청값 디버깅
	System.out.println(memberId+"< -- memberId");
	System.out.println(memberPw+"< -- memberPw");
	
	//디비 드라이버 연결
		String driver="org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbId = "root"; 
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
	
	//아이디 중복체크 확인하기
	String checkSql = "SELECT count(*) FROM member WHERE member_id = ?";
	PreparedStatement stmt1 = conn.prepareStatement(checkSql);
	stmt1.setString(1, memberId);
	System.out.println(stmt1+"<-- stmt1");
	ResultSet rs = stmt1.executeQuery();
	// 행의 갯수를 쿼리를 활용하여 디비의 행의 수가 나오는데 if문을 활용하여 그 아이디의 행이 1이상이라면 회원가입을 중단하고 돌려보낸다
	int cnt = 0; // 행의 수를 저장할 변수선언
	if(rs.next()){
		cnt = rs.getInt("count(*)");
	}
	System.out.println(cnt+"<-- cnt");
	if(cnt > 0){
		System.out.println("중복된 Id가 있음");
		msg = URLEncoder.encode("이미 가입한 동일한 ID가 있습니다.","utf-8");
		response.sendRedirect(request.getContextPath()+"/insert_member/insertMember.jsp?msg="+msg);
		return;	
	}
	// 회원가입데이터 입력 쿼리사용
	String sql = "INSERT INTO member(member_id, member_pw, createdate, updatedate) values(?,?,now(),now())";
	PreparedStatement stmt2 = conn.prepareStatement(sql);
	stmt2.setString(1, memberId);
	stmt2.setString(2, memberPw);
	// int row값에 실행된 결과 행의 수를 저장하여 데이터 입력이 되었는지 안되었는지 확인하다.
	int row = stmt2.executeUpdate();
	System.out.println(stmt2+"<-- stmt2");
	System.out.println(row+"<-- row");//디버깅체크
	if(row == 1){
		System.out.println("insertMemberActio row-->"+row);
		msg = URLEncoder.encode("회원가입완료","utf-8");
		response.sendRedirect(request.getContextPath()+"/boardList.jsp?msg="+msg);
		return;	
	} else{
		System.out.println("insertMemberActio row-->"+row);
		msg = URLEncoder.encode("회원가입 실패","utf-8");
		response.sendRedirect(request.getContextPath()+"/insert_member/insertMember.jsp?msg="+msg);
	}
	
%>