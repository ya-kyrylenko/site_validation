require_relative 'send_mail_helpers'

TIMEOUT = 60
urls = ['https://pokupon.ua/', 'https://partner.pokupon.ua/']
urls_data = urls.map { |url| [url, SUCCESS_CODE] }.to_h

loop do
  urls_data.each do |url, code|
    urls_data[url] = status_code_from(url, code)
  end
  sleep TIMEOUT
end
