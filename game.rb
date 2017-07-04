# encoding: utf-8
#
# Основной класс игры Game. Хранит состояние игры и предоставляет функции для
# развития игры (ввод новых букв, подсчет кол-ва ошибок и т. п.).
class Game
  # принимает на вход загадное слово
  def initialize(word)
    # масив букв
    @letters = get_letters(word)

    # Переменная @errors будет хранить текущее количество ошибок, всего можно
    # сделать не более 7 ошибок. Начальное значение — 0.
    @errors = 0

    # Переменные @good_letters и @bad_lettes будут содержать массивы, хранящие
    # угаданные и неугаданные буквы. В начале игры они пустые.
    @good_letters = []
    @bad_letters = []

    # Специальная переменная-индикатор состояния игры (см. метод get_status)
    @status = 0
  end

  # Метод, который возвращает массив букв загаданного слова
  def get_letters(word)
    if word == nil || word == ""
      abort "в файле нету слов"
    end

    word.encode('UTF-8').split("")
  end

  # Метод, возвращающий статус игры (геттер для @status)
  #
  #  0 – игра активна
  # -1 – игра закончена поражением
  #  1 – игра закончена победой
  def status
    @status
  end

  # Основной метод игры "сделать следующий шаг". В качестве параметра принимает
  # букву, которую ввел пользователь.
  def check_letter(user_letter)
    # Предварительная проверка: если статус игры равен 1 или -1, значит игра
    # закончена и нет смысла дальше делать шаг. Выходим из метода возвращая
    # пустое значение.
    if @status == -1 || @status == 1
      return
    end

    # Если введенная буква уже есть в списке "правильных" или "ошибочных" букв,
    # то ничего не изменилось, выходим из метода.
    if @good_letters.include?(user_letter) || @bad_letters.include?(user_letter)
      return
    end

    # буквы  (е ё)  (и й) должны распознаватся как одинаковые и если отгадано е то выводится и ё
   if @letters.include?(user_letter) ||
     (user_letter == "е" && @letters.include?("ё")) ||
     (user_letter == "ё" && @letters.include?("е")) ||
     (user_letter == "и" && @letters.include?("й")) ||
     (user_letter == "й" && @letters.include?("и"))

    @good_letters << user_letter

    if user_letter == "е"
      @good_letters << "ё"
    end

    if user_letter == "ё"
      @good_letters << "е"
    end

    if user_letter == "и"
      @good_letters << "й"
    end

    if user_letter == "й"
      @good_letters << "и"
    end

      # Дополнительная проверка — угадано ли на этой букве все слово целиком.
      # Если да — меняем значение переменной @status на 1 — победа.
      if (@letters - @good_letters).empty?
        @status = 1
      end
    else
      # Если в слове нет введенной буквы — добавляем эту букву в массив
      # «плохих» букв и увеличиваем счетчик ошибок.
      @bad_letters << user_letter
      @errors += 1

      # Если ошибок больше 7 — статус игры меняем на -1, проигрыш.
      if @errors >= 7
        @status = -1
      end
    end
  end

  # Метод, спрашивающий юзера букву и возвращающий ее как результат.
  def ask_next_letter
    puts "\nВведите следующую букву"

    letter = ""
    while letter == ""
      letter = STDIN.gets.encode("UTF-8").chomp.downcase
    end

    # После получения ввода, передаем управление в основной метод игры
    check_letter(letter)
  end

  def errors
    @errors
  end

  def letters
    @letters
  end

  def good_letters
    @good_letters
  end

  def bad_letters
    @bad_letters
  end
end
