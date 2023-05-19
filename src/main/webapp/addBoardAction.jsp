<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import ="vo.*"%>
<%@ page import = "java.io.*" %>
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
	String originFilename = mRequest.getOriginalFileName("boardTitle");
	String saveFilename = mRequest.getFilesystemName("boardFile");	
	
	System.out.println(type + "<-- type");
	System.out.println(originFilename + "<-- originFilename");
	System.out.println(saveFilename + "<-- saveFilename");
	
	BoardFile boardFile = new BoardFile();
	boardFile.setType(type);
	boardFile.setOriginFileName(originFilename);
	boardFile.setSaveFilename(saveFilename);
%>
