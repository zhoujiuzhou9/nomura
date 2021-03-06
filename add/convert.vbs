Option Explicit
Dim msgFileo
Dim fileFromInput
Dim msgFilet
Dim countFromInput
Dim count
Dim lines
Dim linesArr
Dim linesc
' Dim txtFull

'入力必要データ
msgFileo="繰り返すフォルダーを入力する:※普通zipB,(zipAはOT-STのみ)"
fileFromInput=Inputbox(msgFileo) 
msgFilet="繰り返す回数入力する:※普通2,(80はOT-STのみ)"
countFromInput=Inputbox(msgFilet) 

Msgbox "file is : " & fileFromInput& " ; " & "count is :" &countFromInput

count = getCount(fileFromInput)
lines = getArr(countFromInput,count,fileFromInput)
call writeftpConDel(fileFromInput,lines)
call writeScript(fileFromInput,lines)
call writeFinish(fileFromInput,lines)


Function Full2Half(ByVal s)
    Dim i
    For i = &HFF01 To &HFF7E
        s = Replace(s, ChrW(i), ChrW(i - &HFEE0))
    Next
    Full2Half = s
End Function

REM 1
Function getCount(fn)
	Dim fso,f,a,fname,k
	Set fso = CreateObject("Scripting.FileSystemObject")
	fname= ".\ftp\" & fn & "FinishList.txt"
	if  Not fso.FileExists(fname) then
		fso.createTextFile fname
	end if
	Set f=fso.OpenTextFile(fname,1)
	getCount=0
	DO While f.AtEndOfStream <> True
		a=f.ReadLine 
		getCount=getCount+1
	loop
	f.close
	set fso=Nothing
End Function

REM 2
Function getArr(c,k,fn)
	Dim fso,f,a,fname,cc,kk,j
	Set fso = CreateObject("Scripting.FileSystemObject")
	fname=".\" & fn & ".txt"
	getArr=""
	Set f=fso.OpenTextFile(fname,1)
	j=0
	cc=c+k
	kk=k
	DO While f.AtEndOfStream <> True
		a = f.ReadLine
		j=j+1
		if j>kk and j<=cc then
			getArr= getArr & Mid(Trim(a),10,8) & ","
		end if	
	loop
	f.close
	set fso=Nothing
End Function

REM 3
Sub writeftpConDel(fn,arr)
	Dim f,conDel,linefc,linesArr,fname
	linesArr=Split(arr,",")

	if fn="zipB" then
		fname=".\ftp\ot\ftpConDel.bat"
	Else
		fname=".\ftp\st\ftpConDel.bat"
	End if

	set f = createobject("scripting.filesystemobject")     
	if  Not f.FileExists(fname) then
		f.createTextFile fname
	end if
	set conDel = f.opentextfile(fname,2)   
	conDel.writeline "@echo off" & chr(9)
	for each linefc in linesArr
		if Len(Trim(linefc)) > 2 then
			conDel.writeLine StrConvNarrow(linefc) & chr(9)
		end if 
	next
	conDel.writeline "pause" & chr(9)
	conDel.close
	set f=Nothing
End Sub

REM 4
Sub writeScript(fn,arr)
	Dim f,sc,linefc,linesArr,fname
	linesArr=Split(arr,",")

	if fn="zipB" then
		fname=".\ftp\ot\script.bat"
	Else
		fname=".\ftp\st\script.bat"
	End if

	set f = createobject("scripting.filesystemobject")     
	if  Not f.FileExists(fname) then
		f.createTextFile fname
	end if
	set sc = f.opentextfile(fname,2)   
	sc.writeline "@echo off" & chr(9)
	for each linefc in linesArr
		if Len(Trim(linefc)) > 2 then
			sc.writeLine StrConvNarrow(linefc) & chr(9)
		end if 
	next
	sc.writeline "pause" & chr(9)
	sc.close
	set f=Nothing
End Sub

REM 5
Sub writeFinish(fn,arr)
	Dim f,sc,linefc,linesArr,fname
	linesArr=Split(arr,",")

	if fn="zipB" then
		fname=".\ftp\zipBFinishList.txt"
	Else
		fname=".\ftp\zipAFinishList.txt"
	End if

	set f = createobject("scripting.filesystemobject")     
	if  Not f.FileExists(fname) then
		f.createTextFile fname
	end if

	set sc = f.opentextfile(fname,8)   
	for each linefc in linesArr
		if Len(Trim(linefc)) > 2 then
			sc.writeLine StrConvNarrow(linefc) & chr(9)
		end if 
	next
	sc.close
	set f=Nothing
End Sub

'*****************************************************************************
'[概要] 全角英数字を半角に変換する
'[引数] 変換対象文字列
'[戻値] 変換後文字列
'*****************************************************************************
Function StrConvNarrow(ByVal strWord)
    Dim i, j, strChar, lngChar
	Const HAN = " !#$%&?\()[]{}<>=-+*^/,._;:|@`･"
	Const ZEN = "　！＃＄％＆？\（）［］｛｝＜＞＝−＋＊＾／，．＿；：｜＠｀・"
    For i = 1 To Len(strWord)
        strChar = Mid(strWord, i, 1)
        lngChar = Asc(strChar)
        If Asc("Ａ") <= lngChar And lngChar <= Asc("Ｚ") Then
            strChar = Chr(lngChar - Asc("Ａ") + Asc("A"))
        ElseIf Asc("ａ") <= lngChar And lngChar <= Asc("ｚ") Then
            strChar = Chr(lngChar - Asc("ａ") + Asc("a"))
        ElseIf Asc("０") <= lngChar And lngChar <= Asc("９") Then
            strChar = Chr(lngChar - Asc("０") + Asc("0"))
        Else
            j = InStr(1, ZEN, strChar)
            If j > 0 Then
                strChar = Mid(HAN, j, 1)
            End If
        End If
        StrConvNarrow = StrConvNarrow & strChar
    Next
End Function