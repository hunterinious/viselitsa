# encoding: utf-8
#
# Основной класс игры Game. Хранит состояние игры и предоставляет функции для
# развития игры (ввод новых букв, подсчет кол-ва ошибок и т. п.).
class Game
  attr_reader :letters, :good_letters, :bad_letters
  attr_accessor :status, :errors

  MAX_ERRORS = 7
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
    @status = :in_progress

    @double_words = {
        "е" => "ё",
        "ё" => "е",
        "и" => "й",
        "й" => "и"
    }
  end

  # Метод, который возвращает массив букв загаданного слова
  def get_letters(word)
    if word == nil || word == ""
      abort "в файле нету слов"
    end

    word.encode('UTF-8').split("")
  end

  # Методы, возвращающие статус игры (
  #  0 – игра активна
  # -1 – игра закончена поражением
  #  1 – игра закончена победой
  def in_progress?
    status == :in_progress
  end

  def won?
    status == :won
  end

  def lost?
    status == :lost || errors >= MAX_ERRORS
  end

  # кол-во сотавшихся ошибок
  def errors_left
    MAX_ERRORS - errors
  end

  # кол-во макс допустимых ошибок
  def max_errors
    MAX_ERRORS
  end

  def is_good?(user_letter)
    letters.include?(user_letter) ||
    (user_letter == "е" && letters.include?("ё")) ||
    (user_letter == "ё" && letters.include?("е")) ||
    (user_letter == "и" && letters.include?("й")) ||
    (user_letter == "й" && letters.include?("и"))
  end

  # угадано ли все слово целиком
  def solved?
    (letters - good_letters).empty?
  end

  # Повторяется ли буква, которая уже есть в отгаданых
  # или же плохих(не существующих в слове)
  def repeated?(user_letter)
    good_letters.include?(user_letter) || bad_letters.include?(user_letter)
  end

  # Основной метод игры "сделать следующий шаг". В качестве параметра принимает
  # букву, которую ввел пользователь.
  def check_letter(user_letter)
    # Предварительная проверка: если статус игры равен 1 или -1, значит игра
    # закончена и нет смысла дальше делать шаг. Выходим из метода возвращая
    # пустое значение.
    return if status == :lost || status == :won
    # Если введенная буква уже есть в списке "правильных" или "ошибочных" букв,
    # то ничего не изменилось, выходим из метода.
    return if repeated?(user_letter)

    # буквы  (е ё)  (и й) должны распознаватся как одинаковые и если отгадано е то выводится и ё
    if is_good?(user_letter)

     good_letters << user_letter

     if @double_words.value?(user_letter)
       good_letters << @double_words.key(user_letter)
     end

      # Дополнительная проверка — угадано ли на этой букве все слово целиком.
      # Если да — меняем значение переменной @status на 1 — победа.
     self.status = :won if solved?
    else
      # Если в слове нет введенной буквы — добавляем эту букву в массив
      # «плохих» букв и увеличиваем счетчик ошибок.
      bad_letters << user_letter
      self.errors += 1

      # Если ошибок больше 7 — статус игры меняем на -1, проигрыш.
      if errors >= MAX_ERRORS
        self.status = :lost
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
end
