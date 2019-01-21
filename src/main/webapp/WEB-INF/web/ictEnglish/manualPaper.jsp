<%@ page import="com.thoughtWorks.entity.paper.PaperNameInfo" %>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="../../public/tag.jsp"%>
<!doctype html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>手动选题</title>
    <!-- load css -->
    <link rel="stylesheet" type="text/css"
          href="${baseurl}/public/common/layui/css/layui.css" media="all">
    <link rel="stylesheet" type="text/css"
          href="${baseurl}/public/css/select.css" media="all">
    <script type="text/javascript" src="http://212.64.25.41:8080/ICTEnglish//public/common/layui/layui.js"></script>
    <script>
        var baseUrl = "http://212.64.25.41:8080/ICTEnglish/";
        var ADDRESS_SPLIT_FLAG = "-";
        var HEAD_IMAGE_PREFIX = baseUrl+"images/subject"
        var HEAD_IMAGE_PREFIX1 = baseUrl+"images/public/cover.png"
    </script>
</head>
<body>

<div style="width: 80%; margin: 0 auto">
    <div class="top">
        <form class="layui-form" action="">
            <table>
                <tr>
                    <td><label class="layui-form-label" style="float: right">题目类型：</label></td>
                    <td align=left><input type="checkbox" name="type"
                                          lay-skin="primary" value="SELECTION" title="单选题"></td>
                    <td align=left><input type="checkbox" name="type"
                                          lay-skin="primary" value="NAMING" title="判断题"></td>
                    <td align=left><input type="checkbox" name="type"
                                          lay-skin="primary" value="COMPLETION" title="常用词组英译汉"></td>
                    <td align=left><input type="checkbox" name="type"
                                          lay-skin="primary" value="DEDUCTION" title="常用词组汉译英"></td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>

                    <td><input type="checkbox" name="type" lay-skin="primary"
                               value="ANAYLISIS" title="缩略词解释"></td>
                    <td><input type="checkbox" name="type" lay-skin="primary"
                               value="IDENTIFICATION" title="句子英译汉"></td>
                    <td><input type="checkbox" name="type" lay-skin="primary"
                               value="SYNTHESIS" title="句子汉译英"></td>
                    <td><input type="checkbox" name="allTypeChoose" lay-skin="primary" lay-filter="allTypeChoose"
                               value="ALL" title="全选"></td>
                </tr>
            </table>
        </form>
        <div style = "float:right;">
            <form class="layui-form" action="">
                <table class="seleitem">
                    <tr height="30px">
                        <td>
                            <p>试卷名称：</p>
                        </td>
                        <td>
                            <input size="30" type="text" id="paperName" style = "text-align:center; border-bottom: 1px solid #dbdbdb; border-top:0px; border-left:0px; border-right:0px;"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p>试卷类型：</p>
                        </td>
                        <td>
                            <form action="" method=>
                                <select id = "paperType" name="paperType">
                                    <option value="4">单套试卷（默认）</option>
                                    <option value="1">A卷</option>
                                    <option value="2">B卷</option>
                                    <option value="3">练习题</option>
                                </select>
                            </form>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>

    <div class="selectType" align="right">
        <button class="layui-btn" onclick="select.resetSelectType()">重置</button>
        <button class="layui-btn" onclick="select.getSelectType()">搜索</button>
    </div>
    <div class="question layui-form">
    </div>
    <div class="bottom" >
        <div align="right">
            <button class="layui-btn" onclick="goIndex()">返回首页 </button>
            <button class="layui-btn" onclick="select.resetSelectQuestion()">重置 </button>
            <button class="layui-btn" onclick="submit()">完成选题</button>
        </div>
    </div>
</div>

<script type="text/javascript">
    let select;
    var selectionList;
    var deductionList;
    var identificationList;
    var namingList;
    var completionList;
    var analysisList;
    var synthesisList;
    var fromPreview = false;

    window.onload=function(){
        if(null == true) {
            fromPreview = true;
            select.fromPreviewShow();
        }
    }

    layui.use(
        [ 'jquery', 'layer', 'element', 'laypage', 'form',
            'laytpl', 'tree' ],
        function() {
            window.jQuery = window.$ = layui.jquery;
            window.layer = layui.layer;
            let element = layui.element(), form = layui.form(), laytpl = layui.laytpl;

            form.on('checkbox(allTypeChoose)', function (data) {
                $("input[name='type']").each(function () {
                    this.checked = data.elem.checked;
                });
                form.render('checkbox');
            });

            form.on('checkbox(allChapterChoose)', function (data) {
                $("input[name='chapter']").each(function () {
                    this.checked = data.elem.checked;
                });
                form.render('checkbox');
            });

            form.on('checkbox(allQuestionChoose)', function (data) {
                $("input[name='question']").each(function () {
                    this.checked = data.elem.checked;
                });
                form.render('checkbox');
            });

            select = {
                getSelectType: function() {
                    var items_type = document.getElementsByName("type");
                    var type = new Array();
                    var j = 0;
                    for (var i = 0; i < items_type.length; i++) {
                        if (items_type[i].checked) {
                            type[j] = items_type[i].value;
                            j++;
                        }
                    }

                    var chapter = new Array();
                    // var allSelect = document.getElementsByName("allChapterChoose");
                    var isAll = false;
                    if(true) {
                        //allSelect[0].checked
                        isAll = true;
                    } else {
                        isAll = false;
                        var items_chapter = document.getElementsByName("chapter");
                        var j = 0;
                        for (var i = 0; i < items_chapter.length; i++) {
                            if (items_chapter[i].checked) {
                                chapter[j] = items_chapter[i].value;
                                j++;
                            }
                        }
                    }
                    isAll = true;
                    select.showQuestion(type,chapter,isAll);
                },

                showQuestion: function(type,chapter,isAll) {
                    var data = {"type": type,"chapter":chapter,"isAll":isAll};
                    var params = JSON.stringify(data);
                    console.log(params);
                    $.ajax({
                        type : "post",
                        url : "http://212.64.25.41:8080/ICTEnglish//smxy/paper/getByTypeAndChapter",
                        //url : "http://212.64.25.41:8080/ICTEnglish//exam/getByType",
                        data : params,
                        success : function(data) {
                            //console.log("data=" + JSON.stringify(data));
                            selectionList = data.selectionList;
                            deductionList = data.deductionList;
                            identificationList = data.identificationList;
                            namingList = data.namingList;
                            completionList = data.completionList;
                            analysisList = data.analysisList;
                            synthesisList = data.synthesisList;
                            var _html = "";
                            if(selectionList != null||namingList != null||completionList != null||deductionList != null||
                                deductionList != null||analysisList != null||identificationList != null || synthesisList != null){
                                _html+=`<div class="layui-form" align="left">
                                            <input type="checkbox" name="allQuestionChoose" lay-skin="primary" value="全选" lay-filter="allQuestionChoose">全选>
                                            </div><br/>`;
                            }
                            if (selectionList != null) {
                                _html = generateHtml("SELECTION", _html,selectionList);
                            }
                            if (namingList != null) {
                                _html = generateHtml("NAMING", _html, namingList);
                            }
                            if (completionList != null) {
                                _html = generateHtml("COMPLETION", _html,completionList);
                            }
                            if (deductionList != null) {
                                _html = generateHtml("DEDUCTION", _html,deductionList);
                            }
                            if (analysisList != null) {
                                _html = generateHtml("ANAYLISIS", _html,analysisList);
                            }
                            if (identificationList != null) {
                                _html = generateHtml("IDENTIFICATION", _html,identificationList);
                            }
                            if (synthesisList != null) {
                                _html = generateHtml("SYNTHESIS", _html,synthesisList);
                            }
                            $(".question").html(_html);
                            form.render();
                        },
                        dataType : 'json',
                        contentType : 'application/json'
                    })
                },

                resetSelectType: function() {
                    $("[name=type]:checkbox").attr("checked", false);
                    $("[name=chapter]:checkbox").attr("checked", false);
                    $("[name=allTypeChoose]:checkbox").attr("checked", false);
                    $("[name=allChapterChoose]:checkbox").attr("checked", false);
                    form.render();
                    $(".question").html("");
                },

                resetSelectQuestion: function() {
                    $("[name=question]:checkbox").attr("checked", false);
                    form.render();
                },

                fromPreviewShow: function() {
                    var type = new Array(1);
                    type[0]= "null";
                    if(type[0]!=null) {
                        var items = document.getElementsByName("type");
                        for (var i = 0; i < items.length; i++) {
                            if(items[i].value==type) {
                                items[i].checked = true;
                            }
                        }
                        //select.showQuestion(type);
                    }
                    ($("#paperName")).val("null");
                    ($("#paperType")).val("null");
                    form.render();
                }
            };
        })

    function generateHtml(str, _html, list) {
        if(list.length > 0) {
            _html += '<div><span style="font-weight: bold">';
            _html += getTypeName(str);
            _html += '</span><br><br></div>';
            _html += '<table style="width:50%"><tbody>';
            for(var i = 0; i < list.length; i++) {
                _html += '<tr><td valign="top"><input type="checkbox" name="question" lay-skin="primary" class="';
                _html +=str;
                _html += '" value ="';
                _html +=i;
                _html +='"/></td>';
                _html += '<td><div class=question_item>';
                _html += '<div class=question_name>';
                _html += list[i].question;
                _html += '</div>'
                if(str=="SELECTION") {
                    _html += '<div class=select_item ><p style="float:left">';
                    _html += "A. "+list[i].answerA;
                    _html += '</p></div>';
                    _html += '<div class=select_item><p style="float:left">';
                    _html += "B. "+list[i].answerB;
                    _html += '</p></div>';
                    _html += '<div class=select_item><p style="float:left">';
                    _html += "C. "+list[i].answerC;
                    _html += '</p></div>';
                    _html += '<div class=select_item><p style="float:left">';
                    _html += "D. "+list[i].answerD;
                    _html += '</p></div>';
                }
                _html += '</div><br></td></tr>';
            }
            _html +=  '</tbody></table>';
        }
        return _html;
    }

    function getTypeName(str){
        var type;
        switch(str){
            case 'SELECTION':
                type = "单选题";
                break;
            case 'NAMING':
                type = "判断题";
                break;
            case 'COMPLETION':
                type = "常用词组英译汉";
                break;
            case 'DEDUCTION':
                type = "常用词组汉译英";
                break;
            case 'ANAYLISIS':
                type = "缩略词解释";
                break;
            case 'IDENTIFICATION':
                type = "句子英译汉";
                break;
            case 'SYNTHESIS':
                type = "句子汉译英";
                break;
        }
        return type;
    }

    function submit() {

        var selectList = {
            "selectionList": getSelectQuestion('SELECTION'),
            "namingList": getSelectQuestion('NAMING'),
            "completionList": getSelectQuestion('COMPLETION'),
            "deductionList": getSelectQuestion('DEDUCTION'),
            "analysisList": getSelectQuestion('ANAYLISIS'),
            "identificationList": getSelectQuestion('IDENTIFICATION'),
            "synthesisList": getSelectQuestion('SYNTHESIS'),
        };
        var paperName = ($("#paperName")).val()
        var paperType = document.getElementById("paperType").value;

        console.log("paperName："+paperName);
        console.log("paperType："+paperType);

        if(paperName == null || paperName == "") {
            layer.msg("请输入试卷名称");
        } else {
            var data = {"paperName":paperName, "fromPreview": fromPreview, "paperType": paperType};
            console.log("submit："+JSON.stringify(data));
            $.ajax({
                type: 'POST',
                url: "http://212.64.25.41:8080/ICTEnglish//smxy/paper/setDataBeforeSelect",
                data: JSON.stringify(data),
                dataType : 'json',
                contentType : 'application/json'
            });
            $.ajax({type: 'POST',
                url: "http://212.64.25.41:8080/ICTEnglish//smxy/paper/addQuestionToPaper",
                data: JSON.stringify(selectList),
                dataType : 'json',
                contentType : 'application/json',
                success: function (data) {
                    if (data.result) {
                        console.log("跳转");
                        window.location.href = "http://212.64.25.41:8080/ICTEnglish//smxy/questionpreview";
                    } else {
                        console.log("fail");
                    }
                }
            });
        }
    }

    function getSelectQuestion (str) {
        var items = document.getElementsByClassName(str);
        var list = new Array();
        var j = 0;
        for (var i = 0; i <items.length; i++) {
            if (items[i].checked) {
                var index=items[i].value;
                switch(str){
                    case'SELECTION':
                        list[j] = selectionList[index];
                        break;
                    case 'NAMING':
                        list[j] = namingList[index];
                        break;
                    case 'COMPLETION':
                        list[j] = completionList[index];
                        break;
                    case 'DEDUCTION':
                        list[j] = deductionList[index];
                        break;
                    case 'ANAYLISIS':
                        list[j] = analysisList[index];
                        break;
                    case 'IDENTIFICATION':
                        list[j] = identificationList[index];
                        break;
                    case 'SYNTHESIS':
                        list[j] = synthesisList[index];
                        break;
                }
                j++;
            }
        }
        if(list.length==0) {
            list = null;
        }
        //console.log(JSON.stringify(list));
        return list;
    }

    function goPaperList() {
        $.ajax({
            type: 'POST',
            url: "http://212.64.25.41:8080/ICTEnglish//smxy/paper/getPaperList",
            success: function ( ) {
                window.location.href = "http://212.64.25.41:8080/ICTEnglish//smxy/paperlist";
            }
        });
    }

    function goIndex() {
        $.ajax({
            type: 'POST',
            url: "http://212.64.25.41:8080/ICTEnglish//smxy/paper/clearSession",
        });
        window.location.href = "http://212.64.25.41:8080/ICTEnglish//smxy/index";
    }
</script>
</body>

</html>