class Production
  attr_reader :symbol, :production, :next_symbol_index, :origin

  def initialize (symbol, production, next_symbol_index, origin)
    @symbol = symbol
    @production = production
    @next_symbol_index = next_symbol_index
    @origin = origin
  end

  def next_symbol ()
    @production[@next_symbol_index]
  end

  def is_finished? ()
    @production[@next_symbol_index] == nil
  end

  def equals_to? (production)
    @symbol == production.symbol and
    @production == production.production and
    @next_symbol_index == production.next_symbol_index and
    @origin == production.origin
  end

  def scan_char ()
    @next_symbol_index += 1
  end

  def clone ()
    Production.new(@symbol, @production, @next_symbol_index, @origin)
  end
end

class CFL
  def initialize (terminals, rules, initial_symbol)
    @dummy_symbol = '@'

    @terminals = terminals
    @rules = rules
    @initial_symbol = initial_symbol

    @productions = []
  end

  def init (expression)
    for i in (0..expression.length) do
      @productions[i] = []
    end
  end

  def create_new_production (symbol, production, origin)
    Production.new(symbol, production, 0, origin)
  end

  def is_terminal? (symbol)
    @terminals.include?(symbol)
  end

  def already_include? (production, set)
    set.any? {|pdr| production.equals_to?(pdr)}
  end

  def add_to_set (production, set)
    unless self.already_include?(production, set)
      set.push(production)
    end
  end

  def complete (production, complete_in)
    @productions[production.origin].each {|production|
      clone = production.clone
      clone.scan_char

      self.add_to_set(clone, @productions[complete_in])
    }
  end

  def scanner (production, symbol_index, expression)
    if (production.next_symbol == expression[symbol_index])
      clone = production.clone
      clone.scan_char

      self.add_to_set(clone, @productions[symbol_index + 1])
    end
  end

  def predictor (production, symbol_index)
    @rules[production.next_symbol.to_sym].each {|rule|
      new_production = self.create_new_production(production.next_symbol, rule, symbol_index)
      self.add_to_set(new_production, @productions[symbol_index])
    }
  end

  def recognize (expression)
    self.init(expression)

    initial_production = self.create_new_production(@dummy_symbol, @initial_symbol, 0)
    self.add_to_set(initial_production, @productions[0])

    for symbol_index in (0..expression.length) do
      @productions[symbol_index].each {|production|
        if production.is_finished?
          self.complete(production, symbol_index)
        else
          if self.is_terminal?(production.next_symbol)
            self.scanner(production, symbol_index, expression)
          else
            self.predictor(production, symbol_index)
          end
        end
      }
    end

    final_production = initial_production.clone
    final_production.scan_char
    @productions[expression.length].any? {|production|
      production.equals_to?(final_production)
    }
  end
end