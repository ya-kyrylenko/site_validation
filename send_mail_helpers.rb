require 'httparty'
require 'mailgun'

SUCCESS_CODE   = 200
# you need to replace API_KEY and DOMAIN with the correct data for mailgun gem
API_KEY        = 'API_KEY'
DOMAIN         = 'DOMAIN'
ERROR_MESSAGE  = '[Error] Pokupon website is working incorrectly'
LIVE_MESSAGE   = '[Live] Pokupon website returned to working mode'
MESSAGE_PARAMS =  {
  from:    'site_response@check.com',
  to:      'alert@pokupon.ua'
}

def status_code_from(url, previous_code)
  response = HTTParty.get(url)
  request_code = response.code
  return request_code if request_code == previous_code

  request_message = response.message
  site_works = request_code == SUCCESS_CODE ? true : false
  options = { site_url: url, code: request_code, message: request_message,
    response: site_works }
  send_request_mail(options)
  request_code
end

def send_request_mail(site_url:, code:, message:, response:)
  mg_client = Mailgun::Client.new API_KEY
  params = MESSAGE_PARAMS
  params[:subject] = response ? LIVE_MESSAGE : ERROR_MESSAGE
  params[:text] = "url: '#{site_url}'; status: '#{code}'; message: '#{message}'"
  mg_client.send_message DOMAIN, params
end
