@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Инициализация файлов
set "MSG_FILE=%~dp0manage_routs_temp.log"
set "LOG_FILE=%~dp0manage_routs_logfile.log"
if exist "%MSG_FILE%" del "%MSG_FILE%"
echo. > "%MSG_FILE%"
if not exist "%LOG_FILE%" echo. > "%LOG_FILE%"

:: Получение текущей даты и времени для логов
set "CURRENT_TIME=%date:~6,4%-%date:~3,2%-%date:~0,2% %time:~0,8%"

:: Проверка запуска с правами администратора
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Запустите скрипт с правами администратора! > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Ошибка: Скрипт запущен без прав администратора >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    pause
    exit /b 1
)

:: Инициализация счетчика интерфейсов
set "INTERFACE_COUNT=0"

:: Диагностика: вывод всех интерфейсов с их статусами
echo Физические интерфейсы с их статусами: > "%MSG_FILE%"
echo LOG: [%CURRENT_TIME%] Выполняется диагностика интерфейсов >> "%LOG_FILE%"
powershell -NoProfile -Command "Get-NetAdapter | Select-Object Name, Status | Out-String -Width 4096" >> "%MSG_FILE%"
if errorlevel 1 (
    echo Ошибка при получении списка интерфейсов. >> "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Ошибка PowerShell при получении интерфейсов >> "%LOG_FILE%"
)
type "%MSG_FILE%"
del "%MSG_FILE%"

:: Получение списка интерфейсов с IPv4-адресами (исключая Loopback)
echo Получение интерфейсов с IPv4-адресами... > "%MSG_FILE%"
echo LOG: [%CURRENT_TIME%] Получение интерфейсов с IPv4 >> "%LOG_FILE%"
for /f "usebackq tokens=*" %%I in (`powershell -NoProfile -Command "Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -ne 'Loopback Pseudo-Interface 1' } | Select-Object -ExpandProperty InterfaceAlias | Sort-Object -Unique"`) do (
    set /a INTERFACE_COUNT+=1
    set "INTF_!INTERFACE_COUNT!=%%I"
    echo DEBUG: Set INTF_!INTERFACE_COUNT!=%%I >> "%LOG_FILE%"
)
echo LOG: [%CURRENT_TIME%] Найдено интерфейсов: !INTERFACE_COUNT! >> "%LOG_FILE%"
type "%MSG_FILE%"
del "%MSG_FILE%"

:: Проверка наличия интерфейсов
if !INTERFACE_COUNT! EQU 0 (
    echo Не найдено сетевых интерфейсов с IPv4-адресами. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Ошибка: Нет интерфейсов с IPv4 >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    pause
    exit /b 1
)

:: Вывод списка интерфейсов
echo Выберите интерфейс: > "%MSG_FILE%"
for /L %%i in (1,1,!INTERFACE_COUNT!) do (
    echo   %%i. !INTF_%%i! >> "%MSG_FILE%"
)
echo   0. Отмена >> "%MSG_FILE%"
echo LOG: [%CURRENT_TIME%] Отображен список интерфейсов >> "%LOG_FILE%"
type "%MSG_FILE%"
del "%MSG_FILE%"

:: Выбор интерфейса
:select_interface
echo. > "%MSG_FILE%"
set /p USER_CHOICE=Введите номер интерфейса (0 - отмена): 
if "!USER_CHOICE!"=="" (
    echo Некорректный ввод. Введите номер из списка. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Некорректный ввод номера интерфейса >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :select_interface
)
:: Проверка, что введено число
for /f "delims=0123456789" %%x in ("!USER_CHOICE!") do (
    echo Некорректный ввод. Введите номер из списка. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Введено не число: !USER_CHOICE! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :select_interface
)
:: Проверка диапазона
if !USER_CHOICE! LSS 0 (
    echo Некорректный ввод. Введите номер из списка. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Номер меньше 0: !USER_CHOICE! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :select_interface
)
if !USER_CHOICE! GTR !INTERFACE_COUNT! (
    echo Некорректный ввод. Введите номер из списка. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Номер больше количества интерфейсов: !USER_CHOICE! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :select_interface
)

if "!USER_CHOICE!"=="0" (
    echo Отмена выбора интерфейса. Выход. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Выбрана отмена интерфейса >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :cleanup
)

:: Исправление: правильное получение имени интерфейса
set "INTERFACE_NAME=!INTF_!USER_CHOICE!!"
if "!INTERFACE_NAME!"=="" (
    echo Ошибка: Не удалось определить имя интерфейса для выбора !USER_CHOICE!. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Ошибка: INTF_!USER_CHOICE! не определен >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    pause
    goto :select_interface
)
echo Выбран интерфейс: !INTERFACE_NAME! > "%MSG_FILE%"
echo LOG: [%CURRENT_TIME%] Выполнен выбор интерфейса: !INTERFACE_NAME! >> "%LOG_FILE%"
type "%MSG_FILE%"
del "%MSG_FILE%"

:: Получение IPv4 адреса выбранного интерфейса
set "IP_ADDR="
for /f "usebackq tokens=*" %%i in (`powershell -NoProfile -Command "(Get-NetIPAddress -InterfaceAlias \"!INTERFACE_NAME!\" -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress"`) do (
    set "IP_ADDR=%%i"
)
if errorlevel 1 (
    echo Ошибка при выполнении PowerShell для получения IP-адреса. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Ошибка PowerShell при получении IP для !INTERFACE_NAME! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    pause
    exit /b 1
)
if "!IP_ADDR!"=="" (
    echo Внимание: не удалось получить IPv4 адрес для интерфейса "!INTERFACE_NAME!". > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] IP-адрес не найден для !INTERFACE_NAME! >> "%LOG_FILE%"
) else (
    echo IP адрес интерфейса: !IP_ADDR! > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Получен IP-адрес: !IP_ADDR! >> "%LOG_FILE%"
)
type "%MSG_FILE%"
del "%MSG_FILE%"

:: Текущие маршруты для интерфейса
echo Текущие маршруты для интерфейса "!INTERFACE_NAME!": > "%MSG_FILE%"
echo LOG: [%CURRENT_TIME%] Запрос маршрутов для !INTERFACE_NAME! >> "%LOG_FILE%"
powershell -NoProfile -Command "Get-NetRoute -InterfaceAlias '!INTERFACE_NAME!' | Select-Object DestinationPrefix, NextHop | Out-String -Width 4096" >> "%MSG_FILE%"
if errorlevel 1 (
    echo Ошибка при получении маршрутов для интерфейса "!INTERFACE_NAME!". >> "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Ошибка PowerShell при получении маршрутов >> "%LOG_FILE%"
)
type "%MSG_FILE%"
del "%MSG_FILE%"

:: Получение шлюза для интерфейса
set "GATEWAY="
for /f "usebackq tokens=*" %%g in (`powershell -NoProfile -Command "(Get-NetRoute -InterfaceAlias '!INTERFACE_NAME!' -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue | Select-Object -First 1).NextHop"`) do (
    set "GATEWAY=%%g"
)
if "!GATEWAY!"=="" (
    for /f "usebackq tokens=*" %%g in (`powershell -NoProfile -Command "(Get-NetRoute -InterfaceAlias '!INTERFACE_NAME!' -ErrorAction SilentlyContinue | Where-Object { $_.NextHop -ne '0.0.0.0' } | Select-Object -First 1).NextHop"`) do (
        set "GATEWAY=%%g"
    )
)
if errorlevel 1 (
    echo Ошибка при выполнении PowerShell для получения шлюза. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Ошибка PowerShell при получении шлюза для !INTERFACE_NAME! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    pause
    exit /b 1
)
if "!GATEWAY!"=="" (
    echo Внимание: шлюз для интерфейса "!INTERFACE_NAME!" не определен. Маршруты могут быть недоступны. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Шлюз не найден для !INTERFACE_NAME! >> "%LOG_FILE%"
) else (
    echo Шлюз для интерфейса "!INTERFACE_NAME!": !GATEWAY! > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Получен шлюз: !GATEWAY! >> "%LOG_FILE%"
)
type "%MSG_FILE%"
del "%MSG_FILE%"

:: Основной цикл
:main_loop
echo Выберите действие: > "%MSG_FILE%"
echo LOG: [%CURRENT_TIME%] Запрос действия пользователя >> "%LOG_FILE%"
call :get_action_choice "Выберите действие"
echo LOG: [%CURRENT_TIME%] Выбрано действие: !CHOICE! >> "%LOG_FILE%"
type "%MSG_FILE%"
del "%MSG_FILE%"
if !CHOICE!==0 (
    echo Отмена. Завершение работы. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Выбрана отмена >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :ask_restart
)

:: Добавление маршрута
if !CHOICE!==1 (
    goto :ask_route_type
)

:: Удаление маршрута
if !CHOICE!==2 (
    goto :delete_route
)

goto :main_loop

:ask_route_type
echo. > "%MSG_FILE%"
call :get_yesno_choice "Постоянный маршрут?"
echo LOG: [%CURRENT_TIME%] Запрос типа маршрута, выбрано: !CHOICE! >> "%LOG_FILE%"
type "%MSG_FILE%"
del "%MSG_FILE%"
if !CHOICE!==0 (
    echo Отмена добавления маршрута. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Отмена добавления маршрута >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :main_loop
)
if !CHOICE!==1 (
    set "ROUTE_PARAM=-p"
) else (
    set "ROUTE_PARAM="
)

:input_target_net_add
echo. > "%MSG_FILE%"
set /p TARGET_NET=Введите IP адрес назначения (0 - отмена): 
if "!TARGET_NET!"=="0" (
    echo Отмена добавления маршрута. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Отмена ввода IP адреса добавления >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :main_loop
)
call :check_ip !TARGET_NET!
if errorlevel 1 (
    echo Некорректный IP адрес. Попробуйте ещё раз. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Некорректный IP: !TARGET_NET! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :input_target_net_add
)

:input_target_mask_add
echo. > "%MSG_FILE%"
set /p TARGET_MASK=Введите маску подсети (0 - отмена): 
if "!TARGET_MASK!"=="0" (
    echo Отмена добавления маршрута. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Отмена ввода маски подсети >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :main_loop
)
call :check_mask !TARGET_MASK!
if errorlevel 1 (
    echo Некорректная маску подсети. Попробуйте ещё раз. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Некорректная маска: !TARGET_MASK! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :input_target_mask_add
)

echo Добавляем маршрут: !ROUTE_PARAM! add !TARGET_NET! mask !TARGET_MASK! !GATEWAY! > "%MSG_FILE%"
echo LOG: [%CURRENT_TIME%] Попытка добавить маршрут: !ROUTE_PARAM! !TARGET_NET! !TARGET_MASK! !GATEWAY! >> "%LOG_FILE%"
if "!GATEWAY!"=="" (
    echo Ошибка: шлюз не определен для интерфейса "!INTERFACE_NAME!". Нельзя добавить маршрут. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Шлюз не определен >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
) else (
    route !ROUTE_PARAM! add !TARGET_NET! mask !TARGET_MASK! !GATEWAY!
    if errorlevel 1 (
        echo Ошибка при добавлении маршрута. > "%MSG_FILE%"
        echo LOG: [%CURRENT_TIME%] Ошибка добавления маршрута >> "%LOG_FILE%"
    ) else (
        echo Маршрут добавлен успешно. > "%MSG_FILE%"
        echo LOG: [%CURRENT_TIME%] Маршрут добавлен успешно >> "%LOG_FILE%"
    )
    type "%MSG_FILE%"
    del "%MSG_FILE%"
)
echo.
goto :main_loop

:delete_route
:input_target_net_del
echo. > "%MSG_FILE%"
set /p DEL_TARGET_NET=Введите IP адрес назначения для удаления (0 - отмена): 
if "!DEL_TARGET_NET!"=="0" (
    echo Отмена удаления маршрута. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Отмена ввода IP для удаления >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :main_loop
)
call :check_ip !DEL_TARGET_NET!
if errorlevel 1 (
    echo Некорректный IP адрес. Попробуйте ещё раз. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Некорректный IP для удаления: !DEL_TARGET_NET! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :input_target_net_del
)

:input_target_mask_del
echo. > "%MSG_FILE%"
set /p DEL_TARGET_MASK=Введите маску подсети для удаления (0 - отмена): 
if "!DEL_TARGET_MASK!"=="0" (
    echo Отмена удаления маршрута. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Отмена ввода маски для удаления >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :main_loop
)
call :check_mask !DEL_TARGET_MASK!
if errorlevel 1 (
    echo Некорректная маска подсети. Попробуйте ещё раз. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Некорректная маска для удаления: !DEL_TARGET_MASK! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :input_target_mask_del
)

echo Удаляем маршрут: delete !DEL_TARGET_NET! mask !DEL_TARGET_MASK! !GATEWAY! > "%MSG_FILE%"
echo LOG: [%CURRENT_TIME%] Попытка удалить маршрут: !DEL_TARGET_NET! !DEL_TARGET_MASK! !GATEWAY! >> "%LOG_FILE%"
if "!GATEWAY!"=="" (
    echo Ошибка: шлюз не определен для интерфейса "!INTERFACE_NAME!". Нельзя удалить маршрут. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Шлюз не определен для удаления >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
) else (
    route delete !DEL_TARGET_NET! mask !DEL_TARGET_MASK! !GATEWAY!
    if errorlevel 1 (
        echo Ошибка при удалении маршрута. > "%MSG_FILE%"
        echo LOG: [%CURRENT_TIME%] Ошибка удаления маршрута >> "%LOG_FILE%"
    ) else (
        echo Маршрут удалён успешно. > "%MSG_FILE%"
        echo LOG: [%CURRENT_TIME%] Маршрут удален успешно >> "%LOG_FILE%"
    )
    type "%MSG_FILE%"
    del "%MSG_FILE%"
)
echo.
goto :main_loop

:check_ip
setlocal enabledelayedexpansion
set "ip=%~1"
set "octet_count=0"
for %%i in (%ip:.= %) do set /a octet_count+=1
if !octet_count! NEQ 4 (
    endlocal & exit /b 1
)
for /f "tokens=1-4 delims=." %%a in ("!ip!") do (
    for %%x in (%%a %%b %%c %%d) do (
        set /a octet=%%x 2>nul
        if "!octet!"=="" (
            endlocal & exit /b 1
        )
        if !octet! LSS 0 (
            endlocal & exit /b 1
        )
        if !octet! GTR 255 (
            endlocal & exit /b 1
        )
    )
)
endlocal & exit /b 0

:check_mask
setlocal enabledelayedexpansion
set "mask=%~1"
set "valid_masks=0.0.0.0 128.0.0.0 192.0.0.0 224.0.0.0 240.0.0.0 248.0.0.0 252.0.0.0 254.0.0.0 255.0.0.0 255.128.0.0 255.192.0.0 255.224.0.0 255.240.0.0 255.248.0.0 255.252.0.0 255.254.0.0 255.255.0.0 255.255.128.0 255.255.192.0 255.255.224.0 255.255.240.0 255.255.248.0 255.255.252.0 255.255.254.0 255.255.255.0 255.255.255.128 255.255.255.192 255.255.255.224 255.255.255.240 255.255.255.248 255.255.255.252 255.255.255.254 255.255.255.255"
echo !valid_masks! | findstr /C:"!mask!" >nul
if errorlevel 1 (
    endlocal & exit /b 1
)
endlocal & exit /b 0

:get_action_choice
setlocal enabledelayedexpansion
set "prompt=%~1"
set "choice="
:choice_input
echo. > "%MSG_FILE%"
set /p choice=%prompt% [1-Добавить, 2-Удалить, 0-Отмена]: 
if "!choice!"=="" (
    echo Некорректный ввод. Введите 1, 2 или 0. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Некорректный ввод действия: пустой >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :choice_input
)
if "!choice!"=="1" (
    endlocal & set "CHOICE=1" & exit /b 0
) else if "!choice!"=="2" (
    endlocal & set "CHOICE=2" & exit /b 0
) else if "!choice!"=="0" (
    endlocal & set "CHOICE=0" & exit /b 0
) else (
    echo Некорректный ввод. Введите 1, 2 или 0. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Некорректный ввод действия: !choice! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :choice_input
)

:get_yesno_choice
setlocal enabledelayedexpansion
set "prompt=%~1"
set "choice="
:yn_choice_input
echo. > "%MSG_FILE%"
set /p choice=%prompt% [1-Да, 2-Нет, 0-Отмена]: 
if "!choice!"=="" (
    echo Некорректный ввод. Введите 1, 2 или 0. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Некорректный ввод Да/Нет: пустой >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :yn_choice_input
)
if "!choice!"=="1" (
    endlocal & set "CHOICE=1" & exit /b 0
) else if "!choice!"=="2" (
    endlocal & set "CHOICE=2" & exit /b 0
) else if "!choice!"=="0" (
    endlocal & set "CHOICE=0" & exit /b 0
) else (
    echo Некорректный ввод. Введите 1, 2 или 0. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Некорректный ввод Да/Нет: !choice! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    goto :yn_choice_input
)

:ask_restart
echo. > "%MSG_FILE%"
call :get_yesno_choice "Перезапустить интерфейс \"!INTERFACE_NAME!\"?"
echo LOG: [%CURRENT_TIME%] Запрос перезапуска интерфейса, выбрано: !CHOICE! >> "%LOG_FILE%"
type "%MSG_FILE%"
del "%MSG_FILE%"
if !CHOICE!==1 (
    echo Перезапуск интерфейса "!INTERFACE_NAME!"... > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Начало перезапуска интерфейса !INTERFACE_NAME! >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
    netsh interface set interface name="!INTERFACE_NAME!" admin=disable
    timeout /t 3 /nobreak >nul
    netsh interface set interface name="!INTERFACE_NAME!" admin=enable
    echo Интерфейс перезапущен. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Интерфейс !INTERFACE_NAME! перезапущен >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
) else if !CHOICE!==2 (
    echo Интерфейс не перезапускался. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Перезапуск интерфейса отклонен >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
) else (
    echo Отмена выбора перезагрузки интерфейса. > "%MSG_FILE%"
    echo LOG: [%CURRENT_TIME%] Отмена перезапуска интерфейса >> "%LOG_FILE%"
    type "%MSG_FILE%"
    del "%MSG_FILE%"
)
goto :main_loop

:cleanup
set "INTERFACE_COUNT="
set "INTF_="
set "IP_ADDR="
set "GATEWAY="
set "USER_CHOICE="
set "INTERFACE_NAME="
set "CHOICE="
set "ROUTE_PARAM="
set "TARGET_NET="
set "TARGET_MASK="
set "DEL_TARGET_NET="
set "DEL_TARGET_MASK="
echo Работа скрипта завершена. > "%MSG_FILE%"
echo LOG: [%CURRENT_TIME%] Скрипт завершен, переменные очищены >> "%LOG_FILE%"
type "%MSG_FILE%"
del "%MSG_FILE%"
endlocal
exit /b 0