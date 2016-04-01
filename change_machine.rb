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
    pull(cents_owed) || 'Unable to make change'
  end

  def coin_worth
    { quarter: 25,
      dime: 10,
      nickel: 5,
      penny: 1 }
  end

  def pull(cents_owed)
    return unless cents_owed > 0

    coins = {}
    coin_worth.each do |coin, value|
      plural_coin = plurals[coin]
      coin_count = cents_owed / value
      if sufficient_coins(plural_coin, coin_count) && coin_count > 0
        coins[plural_coin] = coin_count
        @coin_repo[plural_coin] -= coin_count
        cents_owed -= coin_count * value
      end
    end

    return if cents_owed > 0
    coins.to_a
  end

  def sufficient_coins(type, count)
    @coin_repo[type] >= count
  end
end
