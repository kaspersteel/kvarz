@echo off
setlocal enabledelayedexpansion

chcp 65001 >nul

rem --- Функция очистки пробелов (trim) ---
:trim_input
rem %1 - входная переменная, %2 - выходная переменная
setlocal enabledelayedexpansion
set "str=!%~1!"
:trim_loop_start
if "!str:~0,1!"==" " set "str=!str:~1!" & goto trim_loop_start
:trim_loop_end
if "!str:~-1!"==" " set "str=!str:~0,-1!" & goto trim_loop_end
endlocal & set "%~2=%str%"
exit /b 0

rem --- Проверка прав администратора ---
net session >nul 2>&1
if errorlevel 1 (
    echo Запустите скрипт с правами администратора!
    pause
    exit /b 1
)

rem --- Временные файлы ---
set "TMP_SUFFIX=%random%"
set "MSG_FILE=%~dp0manage_routes_temp_%TMP_SUFFIX%.log"
set "LOG_FILE=%~dp0manage_routes_logfile.log"

rem --- Получение текущего времени ---
for /f "tokens=1-3 delims=/: " %%a in ("%date% %time%") do (
    set CURRENT_TIME=%%c-%%a-%%b %time:~0,8%
)

rem --- Получить список интерфейсов с IPv4 ---
echo Получение списка сетевых интерфейсов...
powershell -NoProfile -Command ^
"try {
    $adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
    $ips = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -in $adapters.Name }
    if ($ips.Count -eq 0) { Write-Error 'Нет активных IPv4 интерфейсов' ; exit 1 }
    $uniqueNames = $ips | Select-Object -ExpandProperty InterfaceAlias -Unique
    $uniqueNames | ForEach-Object { Write-Output $_ }
} catch {
    Write-Error $_
    exit 1
}" > "%MSG_FILE%" 2>&1

if errorlevel 1 (
    echo Ошибка при получении интерфейсов:
    type "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Ошибка PowerShell при получении интерфейсов >> "%LOG_FILE%"
    del "%MSG_FILE%"
    pause
    exit /b 1
)

rem --- Считать интерфейсы в переменные ---
set INTERFACE_COUNT=0
for /f "usebackq delims=" %%i in ("%MSG_FILE%") do (
    set /a INTERFACE_COUNT+=1
    set "INTF_!INTERFACE_COUNT!=%%i"
)
del "%MSG_FILE%"

if %INTERFACE_COUNT% EQU 0 (
    echo Не найдено активных IPv4 интерфейсов.
    pause
    exit /b 1
)

rem --- Вывести интерфейсы ---
echo Доступные интерфейсы:
for /l %%i in (1,1,%INTERFACE_COUNT%) do (
    echo  %%i. !INTF_%%i!
)
echo  0. Отмена

rem --- Выбор интерфейса ---
:select_interface
set /p USER_CHOICE=Введите номер интерфейса (0 - отмена): 
call :trim_input USER_CHOICE USER_CHOICE

if "!USER_CHOICE!"=="" (
    echo Некорректный ввод. Повторите.
    goto select_interface
)
for /f "delims=0123456789" %%x in ("!USER_CHOICE!") do (
    echo Некорректный ввод. Введите число.
    goto select_interface
)
if !USER_CHOICE! LSS 0 (
    echo Некорректный ввод. Повторите.
    goto select_interface
)
if !USER_CHOICE! GTR %INTERFACE_COUNT% (
    if !USER_CHOICE! NEQ 0 (
        echo Некорректный ввод. Повторите.
        goto select_interface
    )
)

if !USER_CHOICE! EQU 0 (
    echo Отмена.
    exit /b 0
)

set "SELECTED_INTF=!INTF_%USER_CHOICE%!"
echo Выбран интерфейс: !SELECTED_INTF!

rem --- Получение IP и маски выбранного интерфейса ---
powershell -NoProfile -Command ^
"try {
    $ip = Get-NetIPAddress -InterfaceAlias '%SELECTED_INTF%' -AddressFamily IPv4 | Select-Object -First 1
    if (-not $ip) { Write-Error 'IP-адрес не найден' ; exit 1 }
    Write-Output $ip.IPAddress
    Write-Output $ip.PrefixLength
} catch {
    Write-Error $_
    exit 1
}" > "%MSG_FILE%" 2>&1

if errorlevel 1 (
    echo Ошибка при получении IP-адреса интерфейса:
    type "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Ошибка PowerShell при получении IP интерфейса >> "%LOG_FILE%"
    del "%MSG_FILE%"
    pause
    exit /b 1
)

set /p INTF_IP=<"%MSG_FILE%"
set /p INTF_PREFIX=<"%MSG_FILE%"  & set /a skip=1
for /f "skip=1 delims=" %%a in ("%MSG_FILE%") do (
    set INTF_PREFIX=%%a
    goto :break_loop
)
:break_loop
del "%MSG_FILE%"

rem --- Конвертация префикса в маску ---
call :prefix_to_mask %INTF_PREFIX% INTF_MASK

echo IP интерфейса: %INTF_IP%
echo Маска интерфейса: %INTF_MASK%

rem --- Главное меню ---
:main_menu
echo.
echo Выберите действие:
echo  1. Добавить маршрут
echo  2. Удалить маршрут
echo  0. Выход
set /p ACTION_CHOICE=Введите номер действия: 
call :trim_input ACTION_CHOICE ACTION_CHOICE

if "!ACTION_CHOICE!"=="" (
    echo Некорректный ввод. Повторите.
    goto main_menu
)
for /f "delims=0123456789" %%x in ("!ACTION_CHOICE!") do (
    echo Некорректный ввод. Введите число.
    goto main_menu
)
if !ACTION_CHOICE! LSS 0 (
    echo Некорректный ввод. Повторите.
    goto main_menu
)
if !ACTION_CHOICE! GTR 2 (
    if !ACTION_CHOICE! NEQ 0 (
        echo Некорректный ввод. Повторите.
        goto main_menu
    )
)

if !ACTION_CHOICE! EQU 0 (
    echo Выход.
    exit /b 0
)

rem --- Запрос IP назначения ---
:input_dest_ip
set /p DEST_IP=Введите IP назначения (0 - отмена): 
call :trim_input DEST_IP DEST_IP
if "!DEST_IP!"=="0" (
    echo Отмена операции.
    goto main_menu
)
call :check_ip_validity "%DEST_IP%"
if errorlevel 1 (
    echo Некорректный IP. Повторите.
    goto input_dest_ip
)

rem --- Запрос маски подсети ---
:input_mask
set /p DEST_MASK=Введите маску подсети (например 255.255.255.0) (0 - отмена): 
call :trim_input DEST_MASK DEST_MASK
if "!DEST_MASK!"=="0" (
    echo Отмена операции.
    goto main_menu
)
call :check_mask_validity "%DEST_MASK%"
if errorlevel 1 (
    echo Некорректная маска. Повторите.
    goto input_mask
)

rem --- Проверка принадлежности IP к сети интерфейса ---
call :check_ip_in_subnet "%DEST_IP%" "%INTF_IP%" "%INTF_MASK%"
if errorlevel 1 (
    echo Внимание: введённый IP не принадлежит подсети выбранного интерфейса.
    set /p CONTINUE_CHOICE=Продолжить? (д/н): 
    call :trim_input CONTINUE_CHOICE CONTINUE_CHOICE
    if /i "!CONTINUE_CHOICE!" NEQ "д" (
        echo Отмена операции.
        goto main_menu
    )
)

rem --- Добавление или удаление маршрута ---
if !ACTION_CHOICE! EQU 1 (
    rem Добавление маршрута
    set /p PERMANENT=Сделать маршрут постоянным? (д/н): 
    call :trim_input PERMANENT PERMANENT
    if /i "!PERMANENT!"=="д" (
        set "PERMANENT_FLAG=-p"
    ) else (
        set "PERMANENT_FLAG="
    )
    route add %DEST_IP% mask %DEST_MASK% %INTF_IP% %PERMANENT_FLAG% > "%MSG_FILE%" 2>&1
    if errorlevel 1 (
        echo Ошибка при добавлении маршрута:
        type "%MSG_FILE%"
        echo LOG: [%CURRENT_TIME%] Ошибка добавления маршрута >> "%LOG_FILE%"
    ) else (
        echo Маршрут успешно добавлен.
        echo LOG: [%CURRENT_TIME%] Маршрут добавлен >> "%LOG_FILE%"
    )
    del "%MSG_FILE%"
) else if !ACTION_CHOICE! EQU 2 (
    rem Удаление маршрута
    route delete %DEST_IP% mask %DEST_MASK% > "%MSG_FILE%" 2>&1
    if errorlevel 1 (
        echo Ошибка при удалении маршрута:
        type "%MSG_FILE%"
        echo LOG: [%CURRENT_TIME%] Ошибка удаления маршрута >> "%LOG_FILE%"
    ) else (
        echo Маршрут успешно удалён.
        echo LOG: [%CURRENT_TIME%] Маршрут удалён >> "%LOG_FILE%"
    )
    del "%MSG_FILE%"
)

goto main_menu

rem --------------------
rem --- Функции проверки и конвертации ---

:prefix_to_mask
rem %1 - префикс, %2 - выходная переменная
setlocal enabledelayedexpansion
set /a bits=%~1
set /a mask=0xffffffff << (32 - bits)
set "m1=!mask:~24,8!"
set "m2=!mask:~16,8!"
set "m3=!mask:~8,8!"
set "m4=!mask:~0,8!"
endlocal & set "%~2=%~1"
rem Лучше сделать через powershell для корректности:
for /f "delims=" %%a in ('powershell -NoProfile -Command ^
    "(0..3 | ForEach-Object { (($args[0] -band (0xFF000000 -shr ($_*8))) -shr (24 - ($_*8)) }) -join \".\" )" ^
    -args (0xffffffff << (32 - %bits%) -band 0xffffffff)') do set "%2=%%a"
exit /b 0

:check_ip_validity
rem %1 - IP для проверки
setlocal enabledelayedexpansion
set "ip=%~1"
for /f "tokens=1-4 delims=." %%a in ("!ip!") do (
    for %%x in (%%a %%b %%c %%d) do (
        set /a oct=%%x 2>nul
        if "!oct!"=="" (
            endlocal & exit /b 1
        )
        if !oct! LSS 0 (
            endlocal & exit /b 1
        )
        if !oct! GTR 255 (
            endlocal & exit /b 1
        )
    )
)
endlocal & exit /b 0

:check_mask_validity
rem %1 - маска
setlocal enabledelayedexpansion
set "mask=%~1"
set "valid_masks=128.0.0.0 192.0.0.0 224.0.0.0 240.0.0.0 248.0.0.0 252.0.0.0 254.0.0.0 255.0.0.0 255.128.0.0 255.192.0.0 255.224.0.0 255.240.0.0 255.248.0.0 255.252.0.0 255.254.0.0 255.255.0.0 255.255.128.0 255.255.192.0 255.255.224.0 255.255.240.0 255.255.248.0 255.255.252.0 255.255.254.0 255.255.255.0 255.255.255.128 255.255.255.192 255.255.255.224 255.255.255.240 255.255.255.248 255.255.255.252 255.255.255.254 255.255.255.255"
for %%m in (%valid_masks%) do (
    if "!mask!"=="%%m" (
        endlocal & exit /b 0
    )
)
endlocal & exit /b 1

:check_ip_in_subnet
rem %1 - IP для проверки, %2 - IP интерфейса, %3 - маска интерфейса
powershell -NoProfile -Command ^
"try {
    $ipCheck = [System.Net.IPAddress]::Parse('%~1')
    $ipIntf = [System.Net.IPAddress]::Parse('%~2')
    $mask = [System.Net.IPAddress]::Parse('%~3')
    $ipCheckBytes = $ipCheck.GetAddressBytes()
    $ipIntfBytes = $ipIntf.GetAddressBytes()
    $maskBytes = $mask.GetAddressBytes()
    for ($i=0; $i -lt 4; $i++) {
        if (($ipCheckBytes[$i] -band $maskBytes[$i]) -ne ($ipIntfBytes[$i] -band $maskBytes[$i])) {
            exit 1
        }
    }
    exit 0
} catch {
    exit 1
}"
exit /b %errorlevel%