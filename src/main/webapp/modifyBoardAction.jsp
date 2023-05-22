<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "com.oreilly.servlet.MultipartRequest" %>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import = "vo.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<%	
	String dir = request.getServletContext().getRealPath("/upload");
	int max = 10 * 1024 * 1024;
	//request 객체를 MultipartRequest 의 API 를 사용할 수 있도록 랩핑
	MultipartRequest mRequest = new MultipartRequest(request, dir, max, "utf-8", new DefaultFileRenamePolicy());
	//System.out.println(mRequest.getOriginalFileName("boardFile")+"<-- boardFile");
	// mRequest.getOriginalFileName("boardFile") 값이 null이면 board테이블에 title만 수정
	
	int boardNo = Integer.parseInt(mRequest.getParameter("boardNo"));
	int boardFileNo = Integer.parseInt(mRequest.getParameter("boardFileNo"));
	// 1) board_title 수정
	String boardTitle = mRequest.getParameter("boardTitle");
	
	//디비에서 모델가져오기 
		String driver="org.mariadb.jdbc.Driver";
		String dbUrl = "jdbc:mariadb://127.0.0.1:3306/fileupload";
		String dbId = "root"; 
		String dbPw = "java1234";
		Class.forName(driver);
		Connection conn = null;
		conn = DriverManager.getConnection(dbUrl,dbId, dbPw);
		String boardSql = "UPDATE board SET board_title = ? WHERE board_no = ?";
		PreparedStatement boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setString(1, boardTitle);
		boardStmt.setInt(2, boardNo);
		int boardRow = boardStmt.executeUpdate();

	// 2) 이전 boardFile를 삭제하고 새로운 boardFile로 추가 테이블을 수
	if(mRequest.getOriginalFileName("boardFile") != null){
		//수정할 파일이 있으면 
		//PDF 파일 유효성 검사, pdf파일이 아니면 새로업로드 한 파일 삭제
		if(mRequest.getContentType("boardFile").equals("application/pdf") ==  false){
			String saveFilename = mRequest.getFilesystemName("boardFile");
			File f = new File(dir+"/"+saveFilename); // new File(실제위치"d:/abc/upload/+"") \\ 이두개가 \하나다 \하나만 적으면 특수문자이므로 에러
			if(f.exists()){
				f.delete();
				System.out.println("파일삭제");
			}
		}else {//pdf파일이면 
			// 1) 이전 파일(saveFilename) 삭제
			// 2) DB수정(update))
			// input type = "file" 값(파일 메타 정보) 반환 API(원본파일이름, 저장된파일이름, 컨테츠타입)
			// --> board_file테이블에 저장 
			// 파일(바이너리)은 이미 MultipartRequest객체성생시(request랩핑시, 9라인)애서 이미지 저장
			String type = mRequest.getContentType("boardFile");
			String originFilename = mRequest.getOriginalFileName("boardFile");
			String saveFilename = mRequest.getFilesystemName("boardFile");	
			
			System.out.println(type + "<-- type");
			System.out.println(originFilename + "<-- originFilename");
			System.out.println(saveFilename + "<-- saveFilename");
			
			BoardFile boardFile = new BoardFile();
			boardFile.setBoardFileNo(boardFileNo);
			boardFile.setType(type);
			boardFile.setOriginFileName(originFilename);
			boardFile.setSaveFilename(saveFilename);
			
			// 1) 이전파일 삭제
			String saveFilenameSql = "SELECT save_filename FROM board_file where board_file_no = ?";
			PreparedStatement saveFilenameStmt = conn.prepareStatement(saveFilenameSql);
			saveFilenameStmt.setInt(1, boardFile.getBoardFileNo());
			ResultSet saveFilenameRs = saveFilenameStmt.executeQuery();
			String preSavefilename = "";
			if(saveFilenameRs.next()){
				preSavefilename = saveFilenameRs.getString("save_filename");
			}
			File f = new File(dir+"/"+preSavefilename);
			if(f.exists()){
				f.delete();
			}
			//2) 수정된 파일을 정보를 DB수정
			String boardFileSql = "UPDATE board_file SET origin_filename = ?, save_filename = ? WHERE board_file_no = ?";
			PreparedStatement boardFileStmt = conn.prepareStatement(boardFileSql);
			boardFileStmt.setString(1, boardFile.getOriginFileName());
			boardFileStmt.setString(2, boardFile.getSaveFilename());
			boardFileStmt.setInt(3, boardFile.getBoardFileNo());
			int boardFileRow = boardFileStmt.executeUpdate();
		}
	}
	
	response.sendRedirect(request.getContextPath()+"/boardList.jsp");
%>
