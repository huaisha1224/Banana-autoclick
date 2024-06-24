#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=favicon.ico
#AutoIt3Wrapper_Res_Comment=赛博游戏连点器
#AutoIt3Wrapper_Res_Description=自动检测并点击Banana、Burger、Egg、Cats游戏窗口
#AutoIt3Wrapper_Res_Fileversion=2024.6.21.2
#AutoIt3Wrapper_Res_ProductVersion=1.0.1
#AutoIt3Wrapper_Res_LegalCopyright=怀沙2049
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=None
#AutoIt3Wrapper_Res_Field=ProductName|赛博游戏连点器
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region ;**** 参数创建于 ACNWrapper_GUI ****
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#NoTrayIcon
#RequireAdmin

#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>

Global $hGUI, $btnStart, $btnStop, $btnAbout, $lblDescription, $isClicking, $hWnd, $windowSize, $GameName, $counter = 0 ,$isRunning 
Global $gameNames[4] = ["Banana", "Burger", "Egg", "Cats"] ; 全局模式声明游戏名称列表
$isRunning = False  ;添加全局变量表示运行状态

Func GatGameWindowSize($GameName)
    ;通过传入的游戏窗口名获取游戏的句柄，最终获取游戏的窗口坐标    
    $hWnd = 0 ; 初始化窗口句柄为未找到
    $hWnd = WinGetHandle($GameName)
    WinActivate($GameName)  ;激活窗口
    ;ConsoleWrite("游戏名称：" &$GameName & "游戏句柄："& $hWnd &@CRLF)
    If $hWnd <> 0 Then
        ; 如果找到窗口句柄，就获取游戏的当前坐标和游戏窗口的大小
        $windowSize = WinGetPos($GameName)
        ClickAtGameCenter($windowSize)  ;执行点击
        ;ConsoleWrite("X - 坐标: " & $windowSize[0] & @CRLF & "Y - 坐标: " & $windowSize[1] & @CRLF & "宽度: " & $windowSize[2] & @CRLF & "高度: " & $windowSize[3])
        Sleep(10000) ;可选的延时
        Return $windowSize
    EndIf
EndFunc

Func ClickAtGameCenter($windowSize)
    ;通过X和Y坐标以及游戏窗口的宽度和高度计算点击位置并执行点击操作
	;ConsoleWrite("点击游戏：" &$GameName)
	Local $clickX = $windowSize[0] + $windowSize[2] / 2
	Local $clickY = $windowSize[1] + $windowSize[3] / 2
	MouseClick("left", $clickX+20, $clickY+40) 
EndFunc

Func GetGameName()
    ; 单次执行逻辑，不涉及循环，输出游戏名称
    If $counter >= UBound($gameNames) Then
        $counter = 0; 重置计数器
    EndIf
    $GameName = $gameNames[$counter];
    GatGameWindowSize($GameName); 调用获取游戏句柄和坐标函数
    $counter += 1; 在确保索引有效后才增加计数器
EndFunc

Func MainLoop()
    ;主循环，在执行期间不断调用 GetGameName，直到 isRunning 为 False
    While $isRunning
        GetGameName()
        Sleep(100) ; 合适的延时，避免占用过多 CPU 资源
        If Not $isRunning Then ExitLoop
    WEnd
EndFunc

Func StartClicker()
	;开始函数
    $isRunning = True ; 开始按钮点击后设置为 True
    AdlibRegister("MainLoop", 100) ;每 100ms 调用一次 MainLoop
EndFunc

Func StopClicker()
	;暂停函数
	;ConsoleWrite("进入暂停状态: "& @CRLF)
    $isRunning = False ; 停止按钮点击后设置为 False
    AdlibUnRegister("MainLoop")
EndFunc

Func ExitApp()
    ;退出函数
    ;ConsoleWrite("进入退出循环: "& @CRLF)
    StopClicker()  ; 确保停止所有操作再退出
    GUIDelete($hGUI)
    Exit
EndFunc

Func OpenAboutURL()
    ;打开Url函数
    ShellExecute('https://www.bilibili.com/video/BV1vf421Q7xS/')
EndFunc

Func CreateGUI()
	; 创建 GUI 界面  
	$hGUI = GUICreate("赛博游戏连点器        By：怀沙2049", 400, 210)  
	Opt('GuiOneventmode', 1) ; 开启GUI事件驱动模式
	GUISetOnEvent($GUI_EVENT_CLOSE, "ExitApp")  
	GUISetIcon(@ScriptDir & "\favicon.ico") ; 假设 favicon.ico 与脚本位于同一目录下  
	

	$btnStart = GUICtrlCreateButton("开始", 20, 155, 80, 30)
	GUICtrlSetOnEvent(-1, "StartClicker")
	
	$btnStop = GUICtrlCreateButton("停止", 140, 155, 80, 30)
	GUICtrlSetOnEvent(-1, "StopClicker")
	
	$btnAbout = GUICtrlCreateButton("关于", 260, 155, 80, 30)  
	GUICtrlSetOnEvent(-1, "OpenAboutURL")
	
	
	$lblDescription = GUICtrlCreateEdit(""&@CRLF& "确保游戏已启动"&@CRLF& _
					""&@CRLF& "点击开始后，自动检测并点击游戏窗口"&@CRLF& _
					""&@CRLF& "支持同时点击Banana, Burger, Egg, Cats游戏"&@CRLF& _
					""&@CRLF& "按ESC按键可以直接退出程序"&@CRLF& _
					"" ,20, 20, 320, 135)

	GUISetState(@SW_SHOW,$hGUI)
EndFunc

; 主程序入口，调用 CreateGUI函数
CreateGUI()
; 保持脚本持续运行直到收到退出信号
While 1 
    Sleep(1000)
WEnd