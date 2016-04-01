require 'sinatra'
require 'pry'
require_relative 'change_machine'

class ChangeMachineApp < Sinatra::Base
  get '/' do
    erb :home
  end

  post '/' do
    @@change_machine = ChangeMachine.new(change_machine_params.to_a)
    redirect '/machine'
  end

  get '/machine' do
    erb :make_change, :locals => { :change_machine => @@change_machine }
  end

  post '/machine' do
    change = @@change_machine.make_change(params[:item_cost].to_i, params[:amount_paid].to_i)
    erb :change, :locals => { :change => change }
  end

  def change_machine_params
    { pennies: params[:pennies].to_i,
      nickels: params[:nickels].to_i,
      dimes: params[:dimes].to_i,
      quarters: params[:quarters].to_i }
  end
end
