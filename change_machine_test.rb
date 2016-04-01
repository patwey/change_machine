require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require_relative 'change_machine'

class ChangeMachineTest < Minitest::Test
  def setup
    @change_machine = ChangeMachine.new()
  end

  def fill_change_machine(pennies = 0, nickels = 0, dimes = 0, quarters = 0)
    @change_machine.fill([[:pennies, pennies], [:nickels, nickels], [:dimes, dimes], [:quarters, quarters]])
  end

  def test_it_exists
    assert @change_machine
  end

  def test_it_can_be_filled_with_pennies
    @change_machine.fill([[:pennies, 5]])

    assert_equal 5, @change_machine.coin_repo[:pennies]
  end

  def test_it_can_be_filled_with_nickels
    @change_machine.fill([[:nickels, 4]])

    assert_equal 4, @change_machine.coin_repo[:nickels]
  end

  def test_it_can_be_filled_with_dimes
    @change_machine.fill([[:dimes, 3]])

    assert_equal 3, @change_machine.coin_repo[:dimes]
  end

  def test_it_can_be_filled_with_a_quarter
    @change_machine.fill([[:quarter, 1]])

    assert_equal 1, @change_machine.coin_repo[:quarters]
  end

  def test_it_can_be_filled_with_mixed_change
    expected_repo = { pennies: 2, nickels: 4, dimes: 1, quarters: 3 }
    @change_machine.fill(expected_repo.to_a)

    assert_equal expected_repo, @change_machine.coin_repo
  end

  def test_it_can_make_change_when_it_has_enough_coins
    fill_change_machine(100, 100, 100, 100)

    item_cost = 75
    amt_paid = 100
    expected_change = [[:quarters, 1]]

    assert_equal expected_change, @change_machine.make_change(item_cost, amt_paid)
  end

  def test_it_will_not_make_change_if_user_underpays
    fill_change_machine(100, 100, 100, 100)

    item_cost = 100
    amt_paid = 0

    assert_equal 'Insufficient Payment', @change_machine.make_change(item_cost, amt_paid)
  end

  def test_it_will_not_make_change_with_coins_it_doesnt_have
    item_cost = 75
    amt_paid = 100

    assert_equal 'Unable to make change', @change_machine.make_change(item_cost, amt_paid)
  end

  def test_it_will_make_change_less_efficiently_if_it_has_to
    fill_change_machine(100, 0, 0, 0)

    item_cost = 1
    amt_paid = 100
    expected_change = [[:pennies, 99]]

    assert_equal expected_change, @change_machine.make_change(item_cost, amt_paid)
  end

  def test_it_will_make_mixed_inefficient_change_if_it_has_to
    fill_change_machine(100, 0, 0, 1)

    item_cost = 70
    amt_paid = 100
    expected_change = [[:quarters, 1], [:pennies, 5]]

    assert_equal expected_change, @change_machine.make_change(item_cost, amt_paid)
  end
end
