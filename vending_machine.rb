# coding: utf-8
require "bundler/setup"

class VendingMachine
  attr_reader :juice_stocks, :sales

  ACCEPTABLE_MONEY_LIST = [
    10, 50, 100, 500, 1000
  ]

  def initialize(juice_stocks = [Juice.new("Coke", 120)]*5)
    @accepted_moneys = []
    @purchased = 0
    @sales = 0
    @juice_stocks = juice_stocks
  end

  def total_accepted_money
    @accepted_moneys.inject(0) do |sum, money|
      sum += money.value
    end
  end

  # インターフェースの利便性を考慮して、引数に数字リテラルを想定する
  def accept_money(money_value)
    # 受け付ける対象じゃない場合、そのままmoneyを返す
    return money_value unless ACCEPTABLE_MONEY_LIST.include?(money_value)

    @accepted_moneys << Money.new(money_value)
  end

  def payback
    payback_money = current_money
    @accepted_moneys.clear
    @purchased = 0

    payback_money
  end

  def purchasable?(juice_name)
    target = @juice_stocks.find{|juice| juice.name == juice_name}
    target && current_money >= target.price
  end

  def get_purchasable_juice_names
    @juice_stocks.select{|juice| juice.price <= current_money}.map{|juice| juice.name}.uniq
  end


  def sell(juice_name)
    return unless purchasable?(juice_name)
    target = @juice_stocks.find{|juice| juice.name == juice_name}
    reduce_juice_stock(juice_name)
    @purchased += target.price
    @sales += target.price

    if block_given?
      yield payback
    else
      puts "#{payback}円"
    end

    target
  end

  def get_juice_stock_count(juice_name)
    @juice_stocks.select{|juice| juice.name == juice_name}.size
  end

  def add_juice_stock(juice)
    @juice_stocks << juice
  end


  private 
  def current_money
    total_accepted_money - @purchased
  end

  def reduce_juice_stock(juice_name)
    target_index = @juice_stocks.index{|juice| juice.name == juice_name}
    target_index && @juice_stocks.delete_at(target_index)
  end

end

class Juice
  attr_accessor :name, :price
  def initialize(name, price)
    @name = name
    @price = price
  end

  def == (other)
    @name == other.name && @price == other.price
  end
end

class Money
  attr_reader :value

  def initialize(value)
    @value = value
  end
end
