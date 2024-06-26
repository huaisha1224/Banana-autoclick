#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=favicon.ico
#AutoIt3Wrapper_Res_Comment=������Ϸ������
#AutoIt3Wrapper_Res_Description=�Զ���Ⲣ���Banana��Burger��Egg��Cats��Ϸ����
#AutoIt3Wrapper_Res_Fileversion=2024.6.25.1
#AutoIt3Wrapper_Res_ProductVersion=1.0.2
#AutoIt3Wrapper_Res_LegalCopyright=��ɳ2049
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=None
#AutoIt3Wrapper_Res_Field=ProductName|������Ϸ������
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region ;**** ���������� ACNWrapper_GUI ****
#EndRegion ;**** ���������� ACNWrapper_GUI ****
#NoTrayIcon
#RequireAdmin

#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>

Global $hGUI, $btnStart, $btnStop, $btnAbout, $lblDescription, $isClicking, $hWnd, $windowSize, $GameName, $counter = 0 ,$isRunning, $comboDelay
Global $gameNames[4] = ["Banana", "Burger", "Egg", "Cats"] ; ȫ��ģʽ������Ϸ�����б�
$isRunning = False  ;���ȫ�ֱ�����ʾ����״̬

Func GatGameWindowSize($GameName)
    ;ͨ���������Ϸ��������ȡ��Ϸ�ľ�������ջ�ȡ��Ϸ�Ĵ�������    
    $hWnd = 0 ; ��ʼ�����ھ��Ϊδ�ҵ�
    $hWnd = WinGetHandle($GameName)
    WinActivate($GameName)  ;�����
    ;ConsoleWrite("��Ϸ���ƣ�" &$GameName & "��Ϸ�����"& $hWnd &@CRLF)
    If $hWnd <> 0 Then
        ; ����ҵ����ھ�����ͻ�ȡ��Ϸ�ĵ�ǰ�������Ϸ���ڵĴ�С
        $windowSize = WinGetPos($GameName)
        ClickAtGameCenter($windowSize)  ;ִ�е��
        ;ConsoleWrite("X - ����: " & $windowSize[0] & @CRLF & "Y - ����: " & $windowSize[1] & @CRLF & "���: " & $windowSize[2] & @CRLF & "�߶�: " & $windowSize[3])
        ;Sleep(10000) ;��ѡ����ʱ
		Local $delay = GUICtrlRead($comboDelay) * 1000 ; ������ѡ����ж�ȡ�ӳ�ʱ�䲢ת��Ϊ����
		ConsoleWrite("�ӳ�ʱ�䣺"& $delay & @CRLF)
		Sleep($delay) ; ʹ���û�ѡ����ӳ�ʱ��
        Return $windowSize
    EndIf
EndFunc

Func ClickAtGameCenter($windowSize)
    ;ͨ��X��Y�����Լ���Ϸ���ڵĿ�Ⱥ͸߶ȼ�����λ�ò�ִ�е������
	;ConsoleWrite("�����Ϸ��" &$GameName)
	Local $clickX = $windowSize[0] + $windowSize[2] / 2
	Local $clickY = $windowSize[1] + $windowSize[3] / 2
	MouseClick("left", $clickX+20, $clickY+40) 
EndFunc

Func GetGameName()
    ; ����ִ���߼������漰ѭ���������Ϸ����
    If $counter >= UBound($gameNames) Then
        $counter = 0; ���ü�����
    EndIf
    $GameName = $gameNames[$counter];
    GatGameWindowSize($GameName); ���û�ȡ��Ϸ��������꺯��
    $counter += 1; ��ȷ��������Ч������Ӽ�����
EndFunc

Func MainLoop()
    ;��ѭ������ִ���ڼ䲻�ϵ��� GetGameName��ֱ�� isRunning Ϊ False
    While $isRunning
        GetGameName()
        Sleep(100) ; ���ʵ���ʱ������ռ�ù��� CPU ��Դ
        If Not $isRunning Then ExitLoop
    WEnd
EndFunc

Func StartClicker()
	;��ʼ����
    $isRunning = True ; ��ʼ��ť���������Ϊ True
    AdlibRegister("MainLoop", 100) ;ÿ 100ms ����һ�� MainLoop
EndFunc

Func StopClicker()
	;��ͣ����
	ConsoleWrite("������ͣ״̬: "& @CRLF)
    $isRunning = False ; ֹͣ��ť���������Ϊ False
    AdlibUnRegister("MainLoop")
EndFunc

Func ExitApp()
    ;�˳�����
    ConsoleWrite("�����˳�ѭ��: "& @CRLF)
    StopClicker()  ; ȷ��ֹͣ���в������˳�
    GUIDelete($hGUI)
    Exit
EndFunc

Func OpenAboutURL()
    ;��Url����
    ShellExecute('https://www.bilibili.com/video/BV1vf421Q7xS/')
EndFunc

Func CreateGUI()
	; ���� GUI ����  
	$hGUI = GUICreate("������Ϸ������ 1.0.2        By����ɳ2049", 400, 210)
	Opt('GuiOneventmode', 1) ; ����GUI�¼�����ģʽ
	GUISetOnEvent($GUI_EVENT_CLOSE, "ExitApp")  
	GUISetIcon(@ScriptDir & "\favicon.ico") ; ���� favicon.ico ��ű�λ��ͬһĿ¼��  
	
	; �����������ѡ��Ϊ1��10��
	GUICtrlCreateLabel("���Ƶ�ʣ�", 20, 158, 150, 30)
	$comboDelay = GUICtrlCreateCombo("5", 20, 180, 50, 30)	;Ĭ��5
	GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9|10") 

	$btnStart = GUICtrlCreateButton("��ʼ", 100, 171, 50, 30)
	GUICtrlSetOnEvent(-1, "StartClicker")
	
	$btnStop = GUICtrlCreateButton("ֹͣ", 190, 171, 50, 30)
	GUICtrlSetOnEvent(-1, "StopClicker")
	
	$btnAbout = GUICtrlCreateButton("����", 280, 171, 50, 30)  
	GUICtrlSetOnEvent(-1, "OpenAboutURL")
	
	$lblDescription = GUICtrlCreateEdit(""&@CRLF& "ȷ����Ϸ������"&@CRLF& _
					""&@CRLF& "�����ʼ���Զ���Ⲣ�����Ϸ����"&@CRLF& _
					""&@CRLF& "֧��ͬʱ���Banana, Burger, Egg, Cats��Ϸ"&@CRLF& _
					""&@CRLF& "��ESC��������ֱ���˳�����"&@CRLF& _
					"" ,20, 20, 320, 135)

	GUISetState(@SW_SHOW,$hGUI)
EndFunc

; ��������ڣ����� CreateGUI����
CreateGUI()
; ���ֽű���������ֱ���յ��˳��ź�
While 1 
    Sleep(1000)
WEnd