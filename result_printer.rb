# encoding: utf-8

# Класс ResultPrinter занимается выводом на экран состояния и результата игры.
class ResultPrinter
  def initialize
    @status_image = []

    current_path = File.dirname(__FILE__)
    counter = 0

    while counter <= 7
      file_name = current_path + "/image/#{counter}.txt"
      begin
        file = File.new(file_name, "r:UTF-8")
        @status_image << file.read
        file.close
      rescue SystemCallError
        # Если случилась такая ошибка мы продолжаем работать дальше, т.к. без
        # изображения виселицы вполне можно играть.
        @status_image << "\n [ изображение не найдено ] \n"
      end

      counter += 1
    end
  end

  # Основной метод, печатающий состояния объекта класса Game, который нужно
  # передать ему в качестве параметра.
  def print_status(game)
    # Перед каждым выводом статуса очищаем экран методом cls
    cls

    # Выводим на экран слово с подчеркиваниями методом get_work_for_print
    puts "\nСлово: #{get_word_for_print(game.letters, game.good_letters)}"

    # Выводим текущее количество ошибок и все «промахи»
    puts "Ошибки: #{game.bad_letters.join(", ")}"

    # Выводим саму виселицу, состояние которой определяется количеством ошибок
    print_viselitsa(game.errors)

    if game.status == -1
      # Если статус игры -1 (проигрыш) — выводим загаданное слово и говорим, что
      # пользователь проиграл.
      puts "\nВы проиграли :(\n"
      puts "Загаданное слово было: " + game.letters.join("")
      puts
    elsif game.status == 1
      # Если статус игры 1 (выигрыш) — поздравляем пользователя с победой.
      puts "Поздравляем, вы выиграли!\n\n"
    else
      # Если ни то ни другое (статус 0 — игра продолжается), просто выводим
      # текущее количество оставшихся попыток.
      puts "У вас осталось ошибок: " + (7 - game.errors).to_s
    end
  end

  # Служебный метод класса, возвращающий строку, изображающую загаданное слово
  # с открытыми угаданными буквами
  def get_word_for_print(letters, good_letters)
    result = ""

    for item in letters do
      if good_letters.include?(item)
        result += item + " "
      else
        result += "__ "
      end
    end

    return result
  end

  # Метод, рисующий виселицу в зависимотси от кол-ва ошибок
  def print_viselitsa(errors)
    puts @status_image[errors]
  end

  def cls
    system("clear") || system("cls")
  end
end
