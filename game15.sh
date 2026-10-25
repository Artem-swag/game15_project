#!/bin/sh
# Ветка: feature/board
# Ответственный: Разработчик 1

# Игровое поле. 0 - пустая клетка
BOARD="1 2 3 4 5 6 7 8 9 10 11 0 12 13 14 15 "

# Функция отрисовки поля
draw_board() {
    clear
    echo " ПЯТНАШКИ "
    echo "Управление: w(вверх), s(вниз), a(влево), d(вправо), q(выход)"
    echo "-----------------"

    i=0
    for num in $BOARD; do
        if [ "$num" -eq 0 ]; then
            printf "|    "
        else
            # Форматируем вывод для красоты (2 знака)
            printf "| %2s " "$num"
        fi

        i=$((i + 1))
        # Каждые 4 элемента переносим строку
        if [ $((i % 4)) -eq 0 ]; then
            echo "|"
            echo "-----------------"
        fi
    done
}

# Ветка: feature/moves
# Ответственный: Разработчик 1

move_tile() {
    dir=$1
    empty_idx=-1
    i=0

    # Находим индекс пустой клетки (0)
    for num in $BOARD; do
        if [ "$num" -eq 0 ]; then
            empty_idx=$i
            break
        fi
        i=$((i + 1))
    done

    target_idx=-1

    case $dir in
        w) # Вверх
            if [ $empty_idx -ge 4 ]; then target_idx=$((empty_idx - 4)); fi ;;
        s) # Вниз
            if [ $empty_idx -le 11 ]; then target_idx=$((empty_idx + 4)); fi ;;
        a) # Влево
            if [ $((empty_idx % 4)) -ne 0 ]; then target_idx=$((empty_idx - 1)); fi ;;
        d) # Вправо
            if [ $((empty_idx % 4)) -ne 3 ]; then target_idx=$((empty_idx + 1)); fi ;;
    esac

    if [ $target_idx -ne -1 ]; then
        # Меняем местами пустую клетку и целевую через временные переменные
        val1=0
        val2=0
        i=0
        new_board=""

        for num in $BOARD; do
            if [ $i -eq $empty_idx ]; then
                val1=$num
            elif [ $i -eq $target_idx ]; then
                val2=$num
            fi
            i=$((i + 1))
        done

        # Собираем строку заново
        i=0
        for num in $BOARD; do
            if [ $i -eq $empty_idx ]; then
                new_board="$new_board $val2"
            elif [ $i -eq $target_idx ]; then
                new_board="$new_board $val1"
            else
                new_board="$new_board $num"
            fi
            i=$((i + 1))
        done
        BOARD="$new_board"
    fi
}

# Ветка: feature/win-check
# Ответственный: Разработчик 1

check_win() {
    WIN_BOARD="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 0"
    if [ "$BOARD" = "$WIN_BOARD" ]; then
        return 0 # Победа
    else
        return 1 # Не победа
    fi
}

# Основной цикл с проверкой
while true; do
    draw_board
    
    if check_win; then
        echo "ПОЗДРАВЛЯЮ! Вы собрали пятнашки!"
        break
    fi
    
    read -p "Ход: (w/a/s/d/q): " key
    echo ""
    if [ "$key" = "q" ]; then break; fi
    move_tile "$key"
done
