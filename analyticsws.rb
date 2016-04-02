require 'sinatra/base'
require 'securerandom'
require 'json'
require 'octocore'
require 'octocore/counter/helpers'

require_relative 'lib/helper'
require 'time'

def from_custom_str(str)
  if str.class.equal?String
    if str == 'now'
      Time.now.floor
    elsif str.to_i > 0
      Time.at(str.to_i).floor
    end
  end
end


class AnalyticsWS < Sinatra::Base
  extend Octo::Sinatra::Helper
  extend Octo::Counter::Helper


  configure do
    enable :logging
    file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
    file.sync = true
    use Rack::CommonLogger, file
  end

  get '/:enterprise_id/count/:counter_name/:counter_type/:timestamp/:limit' do
    content_type :json
    params.deep_symbolize_keys!
    logger.info params
    counter_class = params[:counter_name].classify.to_sym
    logger.info "#{ counter_class }, #{Octo.constants}"
    if Octo.constants.include?counter_class
      clazz = Octo.const_get(counter_class)

      cnst = params[:counter_type].upcase.to_sym
      index = Octo::Counter.constants.index(cnst)
      counter_type = if index
                       Octo::Counter.const_get(cnst)
                     end
      if counter_type.nil?
        response = { code: 404, message: "No Such counter type #{ cnst }"}
      else
        args = {
            enterprise_id: params[:enterprise_id],
            ts: from_custom_str(params[:timestamp]),
            type: counter_type
        }
        res = clazz.public_send(:where, args)
        # set the default response first
        response = { code: 404, message: 'No data found for this range.'}
        if res
          if res.length == 1
            response = {
                id: res.uid,
                count: res.count,
                ts: res.ts.to_i
            }
          elsif res.length > 1
            response = res.collect do |r|
              {
                  id: r.uid,
                  count: r.count,
                  ts: r.ts.to_i
              }
            end
          end
        end
      end
      response.to_json
    else
      {
          code: 403,
          message: 'No counter found'
      }.to_json
    end

  end

  get '/:enterprise_id/trend/:trend_name/:trend_type/:timestamp/:limit' do
    content_type :json
    params.deep_symbolize_keys!
    logger.info params
    trend_class = params[:trend_name].classify.to_sym
    logger.info "#{ trend_class }, #{Octo.constants}"
    if Octo.constants.include?trend_class
      clazz = Octo.const_get(trend_class)

      cnst = params[:trend_type].upcase.to_sym
      index = Octo::Counter.constants.index(cnst)
      trend_type = if index
                     Octo::Counter.const_get(cnst)
                   end
      if trend_type.nil?
        response = { code: 404, message: "No Such trend type #{ cnst }"}
      else
        args = {
            enterprise_id: params[:enterprise_id],
            ts: from_custom_str(params[:timestamp]),
            type: trend_type
        }
        res = clazz.public_send(:where, args)
        # set the default response first
        response = { code: 404, message: 'No data found for this range.'}
        if res
          response = res.as_json
        end
      end
      response.to_json
    else
      {
          code: 403,
          message: 'No trend found'
      }.to_json
    end
  end

end
