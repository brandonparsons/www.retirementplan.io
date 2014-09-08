class QuandlService

  def initialize
    @conn = Faraday.new(url: 'http://www.quandl.com/api/v1') # datasets/YAHOO/TSX_XRE_TO.json
  end

  def data(ticker)
    Rails.cache.fetch("etf_data/#{ticker}", expires_in: 12.hours) do
      extract_data_for(ticker)
    end
  end

  private

  def extract_data_for(ticker)
    base                  = Hashie::Mash.new data_for(ticker)
    description_parts     = base.description.match(/^(.*)(Currency: .*)$/)
    date_index            = base.column_names.index("Date")
    adjusted_close_index  = base.column_names.index("Adjusted Close")

    return Hashie::Mash.new({
      description: description_parts[1].strip,
      currency: description_parts[2],
      dates: base.data.map{|row| row[date_index]}.reverse,
      close_prices: base.data.map{|row| row[adjusted_close_index]}.reverse
    })
  end

  def data_for(ticker)
    source_code, table_code = search(ticker)
    get("datasets/#{source_code}/#{table_code}.json?trim_start=2010-01-01&collapse=monthly&auth_token=#{ENV['QUANDL_TOKEN']}")
  end

  def search(query)
    resp = get("datasets.json?query=#{query}&auth_token=#{ENV['QUANDL_TOKEN']}")
    source_code = resp['docs'].first['source_code']
    table_code = resp['docs'].first['code']
    return source_code, table_code
  end

  def get(url)
    JSON.parse( @conn.get(url).body )
  end

end

