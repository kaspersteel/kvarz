Sub SplitSheetToSheetsWithLinks()
    Dim sourceSheetName As String
    Dim wsSource As Worksheet
    Dim wsNew As Worksheet
    Dim lastRow As Long
    Dim lastCol As Long
    Dim rowsPerSheet As Long
    Dim sheetIndex As Integer
    Dim startRow As Long
    Dim r As Long, c As Long
    Dim headerRow As Long
    Dim lastCell As Range
    Dim totalSheets As Long
    Dim totalDataRows As Long
    Dim userInput As Variant
    Dim rowsInCurrentSheet As Long
    Dim formulasArr() As Variant
    Dim headerFormulas() As Variant
    
    ' Имя исходного листа
    sourceSheetName = ActiveSheet.Name
    Set wsSource = ActiveSheet
    
    headerRow = 1 ' Номер строки с заголовком
    
    Set lastCell = wsSource.Cells.Find(What:="*", LookIn:=xlFormulas, LookAt:=xlPart, _
                                      SearchOrder:=xlByRows, SearchDirection:=xlPrevious)
    If lastCell Is Nothing Then
        MsgBox "Лист '" & sourceSheetName & "' пустой!", vbExclamation
        Exit Sub
    Else
        lastRow = lastCell.Row
    End If
    
    lastCol = wsSource.Cells(headerRow, wsSource.Columns.Count).End(xlToLeft).Column
    
    ' Запрос количества строк
    Do
        userInput = Application.InputBox("Введите количество строк данных на каждом новом листе для листа '" & sourceSheetName & "' (целое число больше 0):", _
                                         "Настройка", 10000, Type:=1)
        If userInput = False Then
            MsgBox "Операция отменена пользователем.", vbInformation
            Exit Sub
        ElseIf userInput < 1 Then
            MsgBox "Пожалуйста, введите число больше 0.", vbExclamation
        Else
            rowsPerSheet = CLng(userInput)
            Exit Do
        End If
    Loop
    
    totalDataRows = lastRow - headerRow
    totalSheets = (totalDataRows + rowsPerSheet - 1) \ rowsPerSheet
    
    sheetIndex = 1
    startRow = headerRow + 1
    
    Application.ScreenUpdating = False
    Application.Calculation = xlCalculationManual
    Application.EnableEvents = False
    Application.StatusBar = "Начинается разбивка таблицы на листы..."
    
    Do While startRow <= lastRow
        Set wsNew = ThisWorkbook.Sheets.Add(After:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count))
        On Error Resume Next
        wsNew.Name = sourceSheetName & "_" & sheetIndex
        If Err.Number <> 0 Then
            MsgBox "Не удалось создать лист с именем: " & sourceSheetName & "_" & sheetIndex & ". Возможно, лист с таким именем уже существует.", vbCritical
            Err.Clear
        End If
        On Error GoTo 0
        
        ' Копируем заголовок формулами одной операцией
        ReDim headerFormulas(1 To 1, 1 To lastCol)
        For c = 1 To lastCol
            headerFormulas(1, c) = "='" & sourceSheetName & "'!" & wsSource.Cells(headerRow, c).Address(False, False)
        Next c
        wsNew.Range(wsNew.Cells(headerRow, 1), wsNew.Cells(headerRow, lastCol)).Formula = headerFormulas
        
        ' Определяем количество строк для текущего листа
        rowsInCurrentSheet = Application.Min(rowsPerSheet, lastRow - startRow + 1)
        
        ' Формируем массив формул для блока данных
        ReDim formulasArr(1 To rowsInCurrentSheet, 1 To lastCol)
        
        For r = 1 To rowsInCurrentSheet
            ' Обновляем прогресс каждые 100 строк и в начале/конце
            If r = 1 Or r Mod 100 = 0 Or r = rowsInCurrentSheet Then
                Application.StatusBar = "Обработка листа " & sheetIndex & " из " & totalSheets & _
                                        " — " & Format(r / rowsInCurrentSheet, "0%") & " строк"
            End If
            
            For c = 1 To lastCol
                ' Формируем адрес ячейки исходного листа, смещённой на нужное количество строк
                Dim sourceRow As Long
                sourceRow = startRow + r - 1
                
                ' Проверка на выход за пределы исходного листа
                If sourceRow > lastRow Then
                    formulasArr(r, c) = "" ' Пусто, если вышли за пределы данных
                Else
                    formulasArr(r, c) = "='" & sourceSheetName & "'!" & wsSource.Cells(sourceRow, c).Address(False, False)
                End If
            Next c
        Next r
        
        ' Присваиваем формулы блоком
        wsNew.Range(wsNew.Cells(headerRow + 1, 1), wsNew.Cells(headerRow + rowsInCurrentSheet, lastCol)).Formula = formulasArr
        
        startRow = startRow + rowsInCurrentSheet
        sheetIndex = sheetIndex + 1
    Loop
    
    Application.StatusBar = False
    Application.Calculation = xlCalculationAutomatic
    Application.EnableEvents = True
    Application.ScreenUpdating = True
    
    MsgBox "Таблица разбита на листы с формулами-ссылками.", vbInformation
End Sub