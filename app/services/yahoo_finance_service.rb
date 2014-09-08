require 'open-uri'

class YahooFinanceService

  def initialize(ticker)
    @ticker = ticker
    @url    = "https://finance.yahoo.com/q/pr?s=#{ticker}"
  end

  def data
    Rails.cache.fetch("yahoo_finance_service/etf_data/#{@ticker}", expires_in: 12.hours) do
      Hashie::Mash.new( adjusted_close_data.merge(summary_data) )
    end
  end


  private

  def adjusted_close_data
    time_period = 3.years.ago
    data = YahooFinance.historical_quotes(@ticker, time_period, Time.zone.now, period: :weekly)
    return {
      # Don't overlap keys with summary_data!
      dates:        data.map(&:trade_date).reverse,
      close_prices: data.map(&:adjusted_close).map(&:to_f).reverse
    }
  end

  def summary_data
    doc = Nokogiri::HTML(open(@url))

    if summary_node = doc.at('table:contains("Fund Summary")')
      summary_table = summary_node.text.strip.split("\n").map(&:strip).select{|row| !row.empty?}.join(" ")
      summary_data  = /^.*Fund Summary(.*)Fund Operations(.*)$/.match(summary_table)
      fund_mer = summary_data[2].match(/^.*Expense Ratio \(net\):*(\d+\.\d+)%.+$/)[1]
      return {
        # Don't overlap keys with adjusted_close_data!
        fund_summary: summary_data[1],
        fund_mer:     fund_mer.to_f.round(2)
      }
    elsif summary_node = doc.at('table:contains("Business Summary")')
      summary_table = summary_node.text.strip.split("\n").map(&:strip).select{|row| !row.empty?}.join(" ")
      summary_data  = /^.*Business Summary(.*).*$/.match(summary_table)
      return {
        # Don't overlap keys with adjusted_close_data!
        fund_summary: summary_data[1],
        fund_mer:     "Not available"
      }
    else
      return {
        # Don't overlap keys with adjusted_close_data!
        fund_summary: "Not available",
        fund_mer:     "Not available"
      }
    end
  end

end
