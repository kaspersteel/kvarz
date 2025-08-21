javascript: /* Константы для уровней логирования */ const LOG_LEVELS = {
  DEBUG: 1,
  INFO: 2,
  WARN: 3,
  ERROR: 4,
};
/* Методы консоли для соответствующих уровней логирования */ const LOG_METHODS =
  {
    [LOG_LEVELS.DEBUG]: console.debug,
    [LOG_LEVELS.INFO]: console.info,
    [LOG_LEVELS.WARN]: console.warn,
    [LOG_LEVELS.ERROR]: console.error,
  };
/* Текущий уровень логирования по умолчанию */ let currentLogLevel =
  LOG_LEVELS.INFO;
/* Глобальные переменные */ let isPinnedRowVisible = false;
let rowObserver = null;
/* Вычисляем текущий день и месяц в формате 01..31 и 1..12 */ const currentDay =
  new Date().getDate().toString().padStart(2, "0");
const currentMonth = new Date().getMonth() + 1;
/* Функция логирования с поддержкой уровней */ function log(
  level,
  message,
  ...params
) {
  /* Проверяем, соответствует ли уровень логирования текущему */ if (
    currentLogLevel <= level
  ) {
    const levelStr =
      Object.keys(LOG_LEVELS).find((key) => LOG_LEVELS[key] === level) ||
      "UNKNOWN";
    const logMessage = `[${levelStr}][${message}]`;
    const logMethod = LOG_METHODS[level] || console.log;
    logMethod(logMessage, ...params);
  }
}
/* Вспомогательная функция для проверки объекта */ const isDefined = (value) =>
  value !== null && value !== undefined;
/* Функция debounce с возможностью отмены */ const debounce = (func, delay) => {
  let timeout;
  const debounced = (...args) => {
    if (timeout) clearTimeout(timeout);
    timeout = setTimeout(() => func(...args), delay);
  };
  debounced.cancel = () => {
    if (timeout) {
      clearTimeout(timeout);
      timeout = null;
    }
  };
  return debounced;
};
/* Добавляет CSS-класс к строке классов (строке или массиву) */ function addClass(
  originalClass,
  classToAdd,
) {
  if (!originalClass) return classToAdd;
  const classes = Array.isArray(originalClass)
    ? originalClass
    : originalClass.split(" ");
  if (!classes.includes(classToAdd)) {
    classes.push(classToAdd);
  }
  return classes.join(" ");
}
/* Удаляет CSS-класс из строки классов */ function removeClass(
  originalClass,
  classToRemove,
) {
  if (!originalClass) return "";
  const classes = Array.isArray(originalClass)
    ? originalClass
    : originalClass.split(" ");
  const filtered = classes.filter((c) => c !== classToRemove);
  return filtered.join(" ");
}
/*   * Функция для выделения столбца через изменение columnDefs (добавление CSS-класса)  * При этом сохраняется постоянное выделение столбца текущей даты  */ function highlightColumnByClass(
  gridApi,
) {
  let currentHighlightedColumn = null;
  /* Классы для выделения */ const currentDayHeaderClass = "highlighted-header";
  const currentDayCellClass = "highlighted-column";
  const selectedHeaderClass = "selected-header";
  const selectedCellClass = "selected-column";
  return function (columnId) {
    try {
      const columnDefs = gridApi.getColumnDefs();
      if (!columnDefs) {
        log(
          LOG_LEVELS.WARN,
          "highlightColumnByClass",
          "columnDefs не доступны",
        );
        return;
      }
      /* Если кликнули по текущему дню, ничего не делаем */ if (
        columnId === currentDay
      ) {
        log(
          LOG_LEVELS.DEBUG,
          "highlightColumnByClass",
          `Попытка выделить столбец currentDay`,
        );
        return;
      }
      /* Если кликнули по уже выделенному столбцу — снимаем выделение только с выделяемого (не трогаем currentDay) */ if (
        currentHighlightedColumn === columnId
      ) {
        const clearedColumnDefs = columnDefs.map((def) => {
          const newDef = { ...def };
          /* Удаляем выделение выделяемого столбца */ if (
            def.colId === columnId
          ) {
            newDef.headerClass = removeClass(
              newDef.headerClass,
              selectedHeaderClass,
            );
            newDef.cellClass = removeClass(newDef.cellClass, selectedCellClass);
          }
          /* Оставляем выделение столбца текущего дня без изменений */ return newDef;
        });
        gridApi.setColumnDefs(clearedColumnDefs);
        currentHighlightedColumn = null;
        log(
          LOG_LEVELS.INFO,
          "highlightColumnByClass",
          `Снято выделение со столбца: ${columnId}`,
        );
        return;
      }
      /* Выделяем выбранный столбец, снимая выделение с предыдущего выделенного  */ const newColumnDefs =
        columnDefs.map((def) => {
          const newDef = { ...def };
          if (def.colId === columnId) {
            /* Добавляем выделение выделяемому столбцу */ newDef.headerClass =
              addClass(newDef.headerClass, selectedHeaderClass);
            newDef.cellClass = addClass(newDef.cellClass, selectedCellClass);
          } else {
            /* Убираем выделение с остальных столбцов (кроме currentDay) */ newDef.headerClass =
              removeClass(newDef.headerClass, selectedHeaderClass);
            newDef.cellClass = removeClass(newDef.cellClass, selectedCellClass);
          }
          return newDef;
        });
      gridApi.setColumnDefs(newColumnDefs);
      currentHighlightedColumn = columnId;
      log(
        LOG_LEVELS.INFO,
        "highlightColumnByClass",
        `Выделен столбец: ${columnId}`,
      );
    } catch (error) {
      log(
        LOG_LEVELS.ERROR,
        "highlightColumnByClass",
        `Ошибка при выделении столбца: ${error.message}`,
      );
    }
  };
}
/*   * Функция для добавления CSS-класса к столбцу (header или cell)  */ function addClassToColumnDef(
  gridApi,
) {
  return function (columnId, className, target = "header") {
    try {
      const columnDefs = gridApi.getColumnDefs();
      const indexOfColumn = columnDefs.findIndex(
        (def) => def.colId === columnId,
      );
      if (indexOfColumn >= 0) {
        const newColumnDefs = [...columnDefs];
        let classProperty;
        if (target === "header") {
          classProperty = "headerClass";
        } else if (target === "cell") {
          classProperty = "cellClass";
        } else {
          log(
            LOG_LEVELS.ERROR,
            "addClassToColumnDef",
            `Недопустимый target: ${target}. Допустимые значения: 'header', 'cell'`,
          );
          return;
        }
        const originalClass = newColumnDefs[indexOfColumn][classProperty];
        newColumnDefs[indexOfColumn][classProperty] = originalClass
          ? `${originalClass} ${className}`
          : className;
        gridApi.setColumnDefs(newColumnDefs);
        log(
          LOG_LEVELS.INFO,
          "addClassToColumnDef",
          `Класс "${className}" добавлен к ${target} столбца: ${columnId}`,
        );
      } else {
        log(
          LOG_LEVELS.WARN,
          "addClassToColumnDef",
          `Столбец с colId ${columnId} не найден`,
        );
      }
    } catch (error) {
      log(
        LOG_LEVELS.ERROR,
        "addClassToColumnDef",
        `Ошибка при добавлении класса: ${error.message}`,
      );
    }
  };
}
/*   * Удаляет выделение заголовков и очищает выделение в gridApi  */ function clearHeaderHighlight(
  gridDiv,
  gridApi,
) {
  try {
    gridDiv
      .querySelectorAll(".ag-header-cell")
      .forEach((header) => header.removeAttribute("data-highlighted"));
    if (gridApi?.clearRangeSelection) {
      gridApi.clearRangeSelection();
    }
    log(LOG_LEVELS.INFO, "clearHeaderHighlight", "Сброс выделения заголовков");
  } catch (error) {
    log(
      LOG_LEVELS.ERROR,
      "clearHeaderHighlight",
      `Ошибка при сбросе выделения: ${error.message}`,
    );
  }
}
/*   * Обработчик кликов по заголовкам столбцов с выделением через изменение columnDefs  */ function createOnHeaderClickHandlerUsingClass(
  gridDiv,
  highlightColumnFn,
) {
  return function onHeaderClick(event) {
    try {
      if (!isDefined(gridDiv)) {
        log(LOG_LEVELS.WARN, "onHeaderClick", "gridDiv недоступен");
        return;
      }
      const clickedHeader = event.target.closest(".ag-header-cell");
      if (!isDefined(clickedHeader)) {
        log(
          LOG_LEVELS.DEBUG,
          "onHeaderClick",
          "Клик вне заголовков столбцов, обработка завершена",
        );
        return;
      }
      const columnId = clickedHeader.getAttribute("col-id");
      if (isDefined(columnId)) {
        highlightColumnFn(columnId);
      } else {
        log(
          LOG_LEVELS.WARN,
          "onHeaderClick",
          "Заголовок столбца не содержит атрибута col-id",
        );
      }
    } catch (error) {
      log(
        LOG_LEVELS.ERROR,
        "onHeaderClick",
        `Ошибка при обработке клика: ${error.message}`,
      );
    }
  };
}
/*   * Добавляет обработчик кликов на заголовки столбцов  */ function addHeaderClickListenersUsingClass(
  gridDiv,
  gridApi,
  highlightColumnFn,
) {
  const headersContainer = gridDiv?.querySelector(".ag-header-container");
  if (isDefined(headersContainer)) {
    const onHeaderClick = createOnHeaderClickHandlerUsingClass(
      gridDiv,
      highlightColumnFn,
    );
    headersContainer.addEventListener("click", onHeaderClick);
    log(
      LOG_LEVELS.INFO,
      "addHeaderClickListeners",
      "Обработчики кликов по заголовкам добавлены (через классы)",
    );
    return () => headersContainer.removeEventListener("click", onHeaderClick);
  } else {
    log(
      LOG_LEVELS.WARN,
      "addHeaderClickListeners",
      "Контейнер заголовков не найден",
    );
    return () => {};
  }
}
/*   * Создает функцию для управления видимостью первой строки  */ function createManageRowVisibility(
  gridDiv,
  gridApi,
) {
  return function manageRowVisibility() {
    try {
      log(
        LOG_LEVELS.DEBUG,
        "manageRowVisibility",
        "Начало процедуры управления видимостью строки",
      );
      if (!isDefined(gridDiv)) {
        log(LOG_LEVELS.WARN, "manageRowVisibility", "gridDiv недоступен");
        return null;
      }
      const firstRowElement = gridDiv.querySelector(`[row-index="0"]`);
      if (!isDefined(firstRowElement)) {
        log(
          LOG_LEVELS.DEBUG,
          "manageRowVisibility",
          "Первая строка отсутствует в DOM",
        );
        return null;
      }
      return firstRowElement;
    } catch (error) {
      log(LOG_LEVELS.ERROR, "manageRowVisibility", `Ошибка: ${error.message}`);
      return null;
    }
  };
}
/*   * Инициализация IntersectionObserver для отслеживания видимости первой строки  */ function initRowObserver(
  gridApi,
) {
  if (!isDefined(gridApi)) {
    log(LOG_LEVELS.WARN, "initRowObserver", "gridApi недоступен");
    return null;
  }
  return new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        if (isPinnedRowVisible) {
          log(
            LOG_LEVELS.INFO,
            "RowObserver",
            "Строка вернулась в видимую область, снимаю закрепление",
          );
          hidePinnedRow(gridApi);
        }
      } else {
        if (!isPinnedRowVisible) {
          log(
            LOG_LEVELS.INFO,
            "RowObserver",
            "Строка покинула видимую область, применяю закрепление",
          );
          const firstRowNode = gridApi.getDisplayedRowAtIndex(0);
          showPinnedRow(gridApi, firstRowNode);
        }
      }
    });
  });
}
/*   * Отображает закрепленную строку  */ function showPinnedRow(
  gridApi,
  firstRowNode,
) {
  try {
    if (!isDefined(firstRowNode) || !isDefined(gridApi)) {
      throw new Error("Недоступны данные первой строки или API");
    }
    gridApi.setPinnedTopRowData([firstRowNode.data]);
    isPinnedRowVisible = true;
    log(LOG_LEVELS.INFO, "showPinnedRow", "Закреплена строка", {
      rowData: firstRowNode.data,
    });
  } catch (error) {
    log(LOG_LEVELS.ERROR, "showPinnedRow", `Ошибка: ${error.message}`);
  }
}
/*   * Скрывает закрепленную строку  */ function hidePinnedRow(gridApi) {
  try {
    gridApi.setPinnedTopRowData([]);
    isPinnedRowVisible = false;
    log(LOG_LEVELS.INFO, "hidePinnedRow", "Снято закрепление строки");
  } catch (error) {
    log(LOG_LEVELS.ERROR, "hidePinnedRow", `Ошибка: ${error.message}`);
  }
}
/*   * Функция для управления жизненным циклом обработчиков и observer  */ function setup(
  gridDiv,
  gridApi,
) {
  const manageRowVisibility = createManageRowVisibility(gridDiv, gridApi);
  const addClassToColumn = addClassToColumnDef(gridApi);
  const highlight = highlightColumnByClass(gridApi);
  const debouncedManageRowVisibility = debounce(() => {
    const firstRowElement = manageRowVisibility();
    if (firstRowElement && rowObserver) {
      try {
        rowObserver.observe(firstRowElement);
      } catch (error) {
        log(
          LOG_LEVELS.ERROR,
          "debouncedManageRowVisibility",
          `Ошибка при наблюдении за строкой: ${error.message}`,
        );
      }
    }
  }, 150);
  const removeHeaderClickListener = addHeaderClickListenersUsingClass(
    gridDiv,
    gridApi,
    highlight,
  );
  const onFirstDataRendered = () => {
    log(LOG_LEVELS.INFO, "firstDataRendered", "Таблица впервые отрисована");
    const firstRowNode = gridApi.getDisplayedRowAtIndex(0);
    if (
      firstRowNode &&
      firstRowNode.data &&
      +firstRowNode.data.month_tab === currentMonth
    ) {
      addClassToColumn(currentDay, "highlighted-header", "header");
      addClassToColumn(currentDay, "highlighted-column", "cell");
      log(
        LOG_LEVELS.DEBUG,
        "firstDataRendered",
        `Выделен столбец текущего дня: ${currentDay} (совпадение month_tab)`,
      );
    } else {
      log(
        LOG_LEVELS.DEBUG,
        "firstDataRendered",
        "Столбец текущего дня не выделен (несовпадение month_tab)",
      );
    }
    rowObserver = initRowObserver(gridApi);
    debouncedManageRowVisibility();
  };
  const onModelUpdated = () => {
    log(LOG_LEVELS.INFO, "modelUpdated", "Модель данных таблицы обновлена");
    debouncedManageRowVisibility();
    logFirstRowData();
  };
  const onResize = () => {
    log(LOG_LEVELS.INFO, "resize", "Размер окна изменился");
    debouncedManageRowVisibility();
  };
  gridApi.addEventListener("firstDataRendered", onFirstDataRendered);
  gridApi.addEventListener("modelUpdated", onModelUpdated);
  window.addEventListener("resize", onResize);
  function logFirstRowData() {
    const firstRowNode = gridApi.getDisplayedRowAtIndex(0);
    const firstRowElement = gridDiv?.querySelector(`[row-index="0"]`);
    if (firstRowNode && firstRowNode.data && firstRowElement) {
      log(LOG_LEVELS.DEBUG, "MAIN", "Данные первой строки:", firstRowNode);
      log(LOG_LEVELS.DEBUG, "MAIN", "Первая строка:", firstRowNode);
      log(LOG_LEVELS.DEBUG, "MAIN", "Элемент первой строки:", firstRowElement);
    } else {
      log(LOG_LEVELS.DEBUG, "logFirstRowData", "Диагностика:", {
        firstRowNodeExists: !!firstRowNode,
        firstRowDataExists: !!(firstRowNode && firstRowNode.data),
        firstRowElementExists: !!firstRowElement,
      });
    }
  }
  function cleanup() {
    removeHeaderClickListener();
    gridApi.removeEventListener("firstDataRendered", onFirstDataRendered);
    gridApi.removeEventListener("modelUpdated", onModelUpdated);
    window.removeEventListener("resize", onResize);
    debouncedManageRowVisibility.cancel();
    if (rowObserver) {
      rowObserver.disconnect();
      rowObserver = null;
    }
    log(LOG_LEVELS.INFO, "cleanup", "Все обработчики и observer удалены");
  }
  return { cleanup };
}
/* Главная точка входа */ try {
  log(LOG_LEVELS.INFO, "MAIN", "Запуск PinFirstRowAndSelectFullColumn");
  log(
    LOG_LEVELS.INFO,
    "MAIN",
    `Текущий уровень логирования: ${currentLogLevel}`,
  );
  const gridDiv = parent.document.querySelector(
    '.ag-grid-vue[data-attribute="tab"]',
  );
  if (!gridDiv) {
    throw new Error("[ERROR] Таблица AG Grid не найдена");
  }
  log(LOG_LEVELS.DEBUG, "MAIN", "gridDiv:", gridDiv);
  const vueInstance = gridDiv.__vue__;
  if (!vueInstance) {
    throw new Error("[ERROR] Vue-инстанс для таблицы не найден");
  }
  log(LOG_LEVELS.DEBUG, "MAIN", "vueInstance:", vueInstance);
  const gridApi = vueInstance.gridApi;
  if (!gridApi) {
    throw new Error("[ERROR] API AG Grid недоступен через Vue-компонент");
  }
  log(LOG_LEVELS.DEBUG, "MAIN", "gridApi:", gridApi);
  log(LOG_LEVELS.INFO, "MAIN", "Инстансы получены успешно");
  const { cleanup } = setup(
    gridDiv,
    gridApi,
  ); /* При необходимости вызвать cleanup() для удаления обработчиков и observer      Например, при размонтировании компонента Vue */
} catch (error) {
  log(LOG_LEVELS.ERROR, "MAIN", `Ошибка: ${error.message}`);
}
