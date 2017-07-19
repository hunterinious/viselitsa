# encoding: utf-8

# В отличие от require этот метод ищет файлы .rb (расширение можно не указывать)
# в той же папке, где лежит сама программа, а не в той папке, откуда мы
# запускаем программу.

require_relative "lib/game.rb"
require_relative "lib/result_printer.rb"
require_relative "lib/word_reader.rb"

current_path = File.dirname(__FILE__)

word_reader = WordReader.new

word = word_reader.read_from_file(current_path + '/data/words.txt')

# в конструктор пеедается загадное слово
game = Game.new(word)

printer = ResultPrinter.new(game,current_path)

# Основной цикл программы, в котором развивается игра выходим из цикла, когда
# объект game (класса Game) сообщит нам, c помощью метода status о том, что игра
# закончена (status будет равен 1/-1).
while game.in_progress?
  # Выводим статус игры с помощью метода print_status класса ResultPrinter,
  # которому на вход надо передать объект класса Game, у которого будет взята
  # вся необходимая информация для вывода состояния на экран.
  printer.print_status(game)

  game.ask_next_letter
end

# В конце вызываем метод print_status у объекта класса ResultPrinter ещё раз,
# чтобы вывести игроку результаты игры.
printer.print_status(game)


