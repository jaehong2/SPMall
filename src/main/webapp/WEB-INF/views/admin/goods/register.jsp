<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>admin</title>

<!-- CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<!-- 부가적인 테마 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<!--  자바스크립트 -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.5.1.js"></script>


<style>
 body { font-family:'맑은 고딕', verdana; padding:0; margin:0; }
 ul { padding:0; margin:0; list-style:none;  }

 div#root { width:90%; margin:0 auto; }
 
 header#header { font-size:60px; padding:20px 0; }
 header#header h1 a { color:#000; font-weight:bold; }
 
 nav#nav { padding:10px; text-align:right; }
 nav#nav ul li { display:inline-block; margin-left:10px; }

   section#container { padding:20px 0; border-top:2px solid #eee; border-bottom:2px solid #eee; }
 section#container::after { content:""; display:block; clear:both; }
 aside { float:left; width:200px; }
 div#container_box { float:right; width:calc(100% - 200px - 20px); }
 
 aside ul li { text-align:center; margin-bottom:10px; }
  aside ul li a { display:block; width:100%; padding:10px 0;}
 aside ul li a:hover { background:#eee; }
 
 footer#footer { background:#f9f9f9; padding:20px; }
 footer#footer ul li { display:inline-block; margin-right:10px; }
</style>

<style>
.inputArea { margin:10px 0; }
select { width:100px; }
label { display:inline-block; width:70px; padding:5px; }
label[for='gdsDes'] { display:block; }
input { width:150px; }
textarea#gdsDes { width:400px; height:180px; }
</style>

</head>
<body>

	<div id="root">
		<header id="header">
			<div id="header_box">
				<%@ include file="../include/header.jsp"%>
			</div>
		</header>
		
		<nav id="nav">
			<div id = "nav_box">
				<%@ include file="../include/nav.jsp" %>
			</div>
		</nav>
		
		<section id="container">
			<aside>
				<%@ include file="../include/aside.jsp" %>
			</aside>
			<div id="container_box">
				<h2>상품등록</h2>
				
				<form role="form" method="post" autocomplete="off">
				<div class="inputArea">
					<label>1차분류</label>
					<select class="category1">
						<option value="">전체</option>
					</select>
					
					<label>2차분류</label>
					<select class="category2" name="cateCode">
						<option value="">전체</option>
					</select>
				</div>
				
				<div class="inputArea">
					<label for="gdsName">상품명</label>
					<input type="text" id="gdsName" name="gdsName"/>
				</div>
				
				<div class="inputArea">
					<label for="gdsPrice">상품가격</label>
					<input type="text" id="gdsPrice" name="gdsPrice"/>
				</div>	
				
				<div class="inputArea">
					<label for="gdsStock">상품수량</label>
					<input type="text" id="gdsStock" name="gdsStock"/>
				</div>	
				
				<div class="inputArea">
					<label for="gdsDes">상품소개</label>
					<textarea rows="5" cols="50" id="gdsDes" name="gdsDes"></textarea>
				</div>	
				
				<div class="inputArea">
					<button type="submit" id="register_Btn" class="btn btn-primary">등록</button>
				</div>		
				
				</form>
			</div>
		</section>
		
		<footer id = "footer">
			<div id="footer_box">
				<%@ include file="../include/footer.jsp" %>
			</div>
		</footer>
	</div>

<script>
//컨트롤에서 데이터 받기
var jsonData = JSON.parse('${category}');
console.log(jsonData);

var cate1Arr = new Array();
var cate1Obj = new Object();

//1차 분류 셀렉트 박스에 삽입할 데이터 준비
for(var i=0; i < jsonData.length; i++){
	if(jsonData[i].level == "1"){
		cate1Obj = new Object(); //root 카테고리가 선택되면 나머지 초기화
		cate1Obj.cateName = jsonData[i].cateName;
		cate1Obj.cateCode = jsonData[i].cateCode;
		cate1Arr.push(cate1Obj);
	}
}

// 1차 분류 셀렉트 박스에 삽입할 데이터 삽입
var cate1Select  = $("select.category1");
for(var i=0; i< cate1Arr.length; i++){
	cate1Select.append("<option value='"+cate1Arr[i].cateCode + "'>"
			+ cate1Arr[i].cateName + "</option>");
}

$(document).on("change", "select.category1", function(){
	var cate2Arr = new Array();
	var cate2Obj = new Object();
	
	//2차 분류 셀렉트 박스에 삽입할 데이터 준비
	for(var i=0; i< jsonData.length; i++){
		if(jsonData[i].level == "2"){
			cate2Obj = new Object(); //root 카테고리가 선택되면 나머지 초기화
			cate2Obj.cateName = jsonData[i].cateName;
			cate2Obj.cateCode = jsonData[i].cateCode;
			cate2Obj.cateCodeRef = jsonData[i].cateCodeRef;
			
			cate2Arr.push(cate2Obj);
		}
	}
	var cate2Select = $("select.category2");
	
	cate2Select.children().remove(); //기존에 있던 데이터 삭제
	
	$("option:selected", this).each(function(){ 
		
		var selectVal = $(this).val();// selectVal에 현재 선택된 (1차 분류값) 값 저장
		
		cate2Select.append("<option value='" + selectVal + "'>전체 </option>"); //select 박스에 value='' 이고 전체라고 표시될 데이터 추가
		
		for(var i=0; i<cate2Arr.length; i++){
			if(selectVal == cate2Arr[i].cateCodeRef){ //1차 분류 값인 selectVal 와 1차 분류 값을 외래키로가진 cateCodeRef의 값이 같으면 select 추가
				cate2Select.append("<option value='" + cate2Arr[i].cateCode + "'>"
						+ cate2Arr[i].cateName + "</option>");
			}
		}
	});
});
</script>
</body>
</html>