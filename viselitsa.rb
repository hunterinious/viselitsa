# encoding: utf-8

# В отличие от require этот метод ищет файлы .rb (расширение можно не указывать)
# в той же папке, где лежит сама программа, а не в той папке, откуда мы
# запускаем программу.
current_path = File.dirname(__FILE__)

require_relative "game.rb"
require_relative "result_printer.rb"
require_relative "word_reader.rb"

printer = ResultPrinter.new

reader = WordReader.new

word = reader.read_from_file(current_path + '/data/words.txt')

# в конструктор пеедается загадное слово
game = Game.new(word)

# Основной цикл программы, в котором развивается игра выходим из цикла, когда
# объект game (класса Game) сообщит нам, c помощью метода status о том, что игра
# закончена (status будет равен 1/-1).
while game.status == 0
  # Выводим статус игры с помощью метода print_status класса ResultPrinter,
  # которому на вход надо передать объект класса Game, у которого будет взята
  # вся необходимая информация для вывода состояния на экран.
  printer.print_status(game)

  game.ask_next_letter
end

# В конце вызываем метод print_status у объекта класса ResultPrinter ещё раз,
# чтобы вывести игроку результаты игры.
printer.print_status(game)


