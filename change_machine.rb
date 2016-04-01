class ChangeMachine
  attr_reader :coin_repo, :plurals, :worth

  def initialize(coins = [])
    @coin_repo ||= { pennies: 0, nickels: 0, dimes: 0, quarters: 0 }
    fill(coins)
  end

  def fill(coins)
    return unless coins.is_a?(Array)

    coins.each do |coin, count|
      pluralized_coin = pluralize_coin(coin)
      @coin_repo[pluralized_coin] += count if @coin_repo[pluralized_coin]
    end
  end

  def pluralize_coin(coin_name)
    plurals[coin_name] || coin_name
  end

  def plurals
    { :penny   => :pennies,
      :nickel  => :nickels,
      :dime    => :dimes,
      :quarter => :quarters }
  end

  def make_change(item_cost, amt_paid)
    change_owed = amt_paid - item_cost
    if change_owed > 0
      _make_change(change_owed)
    else
      'Insufficient Payment'
    end
  end

  def _make_change(cents_owed)
    coins_needed = necessary_coins(cents_owed)
    if pull(coins_needed)
      coins_needed
    else
      'Unable to make change'
    end
  end

  def necessary_coins(cents_owed)
    coins = {}
    plurals.keys.reverse.each do |coin|
      coin_count = cents_owed / worth[coin]
      coins[plurals[coin]] = coin_count
      cents_owed -= coin_count * worth[coin]
    end
    coins.to_a
  end

  def worth
    { quarter: 25,
      dime: 10,
      nickel: 5,
      penny: 1 }
  end

  def pull(coins)
    return false unless coins.is_a?(Array)

    coins.each do |coin, count|
      pluralized_coin = pluralize_coin(coin)
      if sufficent_coins(pluralized_coin, count)
        @coin_repo[pluralized_coin] -= count
      else
        return false
      end
    end
  end

  def sufficent_coins(type, count)
    @coin_repo[type] >= count
  end
end
