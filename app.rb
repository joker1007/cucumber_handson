# coding: utf-8
require "bundler"

Bundler.require(:default)

require "sinatra/base"

require File.join(File.dirname(File.expand_path(__FILE__)), "vending_machine")

class VendingMachineApp < Sinatra::Base
  VENDING_MACHINE = VendingMachine.new

  3.times do
    VENDING_MACHINE.add_juice_stock(Juice.new("DoctorPepper", 120))
  end

  3.times do
    VENDING_MACHINE.add_juice_stock(Juice.new("RedBull", 120))
  end

  set :haml,  {format: :html5}

  get "/" do
    haml :index
  end

  post "/insert_money" do
    VENDING_MACHINE.accept_money(params[:money].to_i)
    haml :index
  end

  post '/purchase' do
    @payback = 0
    @juice = VENDING_MACHINE.sell(params[:name]) do |payback|
      @payback = payback
    end
    haml :index
  end

  post '/add_juice' do
    @added = []
    params[:count].to_i.times do
      juice = Juice.new(params[:juice][:name], params[:juice][:price].to_i)
      VENDING_MACHINE.add_juice_stock(juice)
      @added.push juice
    end
    haml :index
  end

  get '/refund' do
    payback = VENDING_MACHINE.payback
    @refund = [1000,500,100,50,10].each_with_object({:all => payback}) do |coin, h|
      quo = payback / coin
      h[coin] = quo
      payback = payback - quo * coin
      break h if payback <= 0
    end
    haml :index
  end

  helpers do
    def purchase_button(juice)
      if VENDING_MACHINE.purchasable?(juice.name)
        <<-HTML
        <form method="POST" action="/purchase">
          <input type="hidden" name="name" value="#{juice.name}">
          <input type="submit" value="購入">
        </form>
        HTML
      else
        '<input type="submit" value="購入" disabled>'
      end
    end
  end
end
