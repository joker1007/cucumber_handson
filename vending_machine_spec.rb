#coding:utf-8

require File.dirname(__FILE__) + '/vending_machine'

require "rspec-parameterized"

describe VendingMachine do 

  describe "#accept_money(money)" do
    with_them do
      it "should add money to total_accepted_money" do
        expect {
          subject.accept_money(money)
        }.to change(subject, :total_accepted_money).by(expected)
      end
    end

    where(:money, :expected) do
      [
        [10, 10],
        [100, 100],
        [1, 0],
        [5, 0],
        [5000, 0],
        [10000, 0],
      ]
    end

    context "multi accept" do
      with_them do
        it "should add money to total_accepted_money" do
          expect {
            subject.accept_money(money1)
            subject.accept_money(money2)
          }.to change(subject, :total_accepted_money).by(expected)
        end
      end

      where(:money1, :money2, :expected) do
        [
          [10, 10, 20],
          [100, 10, 110]
        ]
      end
    end
  end

  describe "#payback" do
    it "should clear total_accepted_money" do
      subject.accept_money(100)
      expect {
        subject.payback
      }.to change(subject, :total_accepted_money).from(100).to(0)
    end

    context "before sell" do
      with_them do
        it "should return total_accepted_money" do
          subject.accept_money(money)
          subject.payback.should == expected
        end
      end

      where(:money, :expected) do
        [
          [0, 0],
          [10, 10],
          [100, 100]
        ]
      end
    end
  end

  describe "#juice_stocks" do
    it "should return a juice array" do
      subject.juice_stocks.should == [Juice.new("Coke", 120)]*5
    end
  end

  describe "#purchasable?(juice_name)" do
    context "no coke" do
      subject { VendingMachine.new([]) } 

      it do
        subject.purchasable?("Coke").should be_false
      end
    end

    context "accept_money not yet" do
      it do
        subject.purchasable?("Coke").should be_false
      end
    end

    with_them do
      before do
        money_list.each do |money|
          subject.accept_money(money)
        end
      end

      it { subject.purchasable?("Coke").should == expected }
    end

    where(:money_list, :expected) do
      [
        [[], false],
        [[100, 10], false],
        [[100, 10, 10], true],
      ]
    end
  end

  describe "#sell(juice_name)" do
    context "purchasable coke" do
      before do
        subject.accept_money(100)
        subject.accept_money(10)
        subject.accept_money(10)
      end

      it "increments sales" do
        expect {
          subject.sell("Coke")
        }.to change(subject, :sales).by(120)
      end

      it "decrements juice stock count" do
        expect {
          subject.sell("Coke")
        }.to change {
          subject.get_juice_stock_count("Coke")
        }.by(-1)
      end

      it do
        subject.should_receive(:payback).and_return(0)
        subject.sell("Coke")
      end

      it do
        subject.stub!(:payback).and_return(0)
        expect {|b| subject.sell("Coke", &b)}.to yield_with_args(0)
      end
    end

    context "not purchasable coke" do
      before do
        subject.accept_money(100)
      end

      it do
        expect {
          subject.sell("Coke")
        }.to change(subject, :sales).by(0)
      end
    end
  end

  describe "#add_juice_stock" do
    subject { VendingMachine.new([])}
    
    it "accept juice" do
      juice = Juice.new(:redbull, 200)
      subject.add_juice_stock(juice)
      subject.juice_stocks.should == [juice]
    end
  end

  describe "#get_purchasable_juice_names" do
    with_them do
      subject { VendingMachine.new([Juice.new("Coke",120), Juice.new(:redbull,200)]) }
      it "return purchasable juice names" do
        money_list.each do |money|
          subject.accept_money(money)
        end
        subject.get_purchasable_juice_names.should == purchasable_juice_names
      end
    end
    where(:money_list, :purchasable_juice_names) do
      [
        [[100,10], []],
        [[100,10,10], ["Coke"]],
        [[100,50,10,10,10,10], ["Coke"]],
        [[100,100], ["Coke",:redbull]],
        [[100,100,10], ["Coke",:redbull]]
      ]
    end

  end
end

