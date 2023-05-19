<%@page import="javax.naming.spi.DirStateFactory.Result"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import ="vo.*"%>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<%
	String dir = request.getServletContext().getRealPath("/upload");
	int max = 10 * 1024 * 1024;
	
	DefaultFileRenamePolicy fp = new DefaultFileRenamePolicy();
	//request 객체를 MultipartRequest 의 API 를 사용할 수 있도록 랩핑
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", fp);
	
	//MultipartRequest API를 사용하여 스트림내에서 문자값을 반환할수있다.
	
	//업로드 파일이 PDF파일이 아니면
	if(mRequest.getContentType("boardFile").equals("application/pdf") == false){
		// 이미저장된 파일을 삭제
		System.out.println("PDF파일이 아닙니다");
		String saveFilename = mRequest.getFilesystemName("boardFile");	
		File f = new File(dir+"/"+saveFilename); // new File(실제위치"d:/abc/upload/+"") \\ 이두개가 \하나다 \하나만 적으면 특수문자이므로 에러
		if(f.exists()){
			f.delete();
			System.out.println("파일삭제");
		}
		return;
	}
	
	// 1) input type="text" 반환 API --> board 테이블에 저
	String boardTitle = mRequest.getParameter("boardTitle");
	String memberId = mRequest.getParameter("memberId");

	System.out.println(boardTitle + "<-- boardTitle");
	System.out.println(memberId + "<-- memberId");
	
	Board board = new Board();	
	board.setBoardTitle(boardTitle);
	board.setMemberId(memberId);
	
	// 2) input type = "file" 값(파일 메타 정보) 반환 API(원본파일이름, 저장된파일이름, 컨테츠타입)
	// --> board_file테이블에 저장 
	// 파일(바이너리)은 이미 MultipartRequest객체성생시(request랩핑시, 9라인)애서 이미지 저장
	String type = mRequest.getContentType("boardFile");
	String originFilename = mRequest.getOriginalFileName("boardFile");
	String saveFilename = mRequest.getFilesystemName("boardFile");	
	
	System.out.println(type + "<-- type");
	System.out.println(originFilename + "<-- originFilename");
	System.out.println(saveFilename + "<-- saveFilename");
	
	BoardFile boardFile = new BoardFile();
	boardFile.setType(type);
	boardFile.setOriginFileName(originFilename);
	boardFile.setSaveFilename(saveFilename);
	/*
		INSERT INTO board(board_title, member_id, updatedate, createdate) 
		values(?, ?, NOW(), NOW())
		
		INSERT INTO board_file(board_no, origin_filename, save_filename, path, type, createdate)
		VALUES(?, ?, ?, ?, ?, NOW())
	*/
	
	//디비에서 모델가져오기 
	String driver="org.mariadb.jdbc.Driver";
	String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
	String dbId = "root"; 
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
	//디비연결 디버깅
	System.out.println("디비연결확인");
	// 1)서브메뉴 결과셋(모델)
	PreparedStatement boardStmt = null;
	String boardSql = "INSERT INTO board(board_title, member_id, updatedate, createdate) values(?, ?, NOW(), NOW())";
	boardStmt = conn.prepareStatement(boardSql, PreparedStatement.RETURN_GENERATED_KEYS); //그냥 이렇게 하면  생성된 키값boardNo를 받을 수있다.
	boardStmt.setString(1, boardTitle);
	boardStmt.setString(2, memberId);
	boardStmt.executeUpdate();//board 입력 후 키값저장
	ResultSet keyRs = boardStmt.getGeneratedKeys();//insert 후 입력된 행의 저장된 키값을 받아오는 select 쿼리를 실행
	int boardNo = 0;
	if(keyRs.next()){
		boardNo = keyRs.getInt(1);
	}

	String fileSql = null;
	fileSql = "INSERT INTO board_file(board_no, origin_filename, save_filename, type, path, createdate) VALUES(?, ?, ?, ?, '.upload', NOW())";
	PreparedStatement fileStmt = conn.prepareStatement(fileSql);
	fileStmt.setInt(1, boardNo);
	fileStmt.setString(2, originFilename);
	fileStmt.setString(3, saveFilename);
	fileStmt.setString(4, type);
	fileStmt.executeUpdate();	//board file 입력
	
	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
%>
