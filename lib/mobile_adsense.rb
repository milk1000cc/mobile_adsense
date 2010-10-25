require 'open-uri'

module MobileAdsense
  def mobile_adsense(options)
    raise ArgumentError, ':client option must be defined' unless options[:client]

    dt = '%.0f' % (1000 * Time.zone.now.to_f)
    scheme = request.ssl? ? 'https://' : 'http://'
    user_agent = request.user_agent

    options = options.dup
    options[:client] = "ca-mb-#{ options[:client] }" unless options[:client] =~ /^ca\-mb\-/
    options = {
      :ad_type => 'text_image',
      :channel => '',
      :dt => dt,
      :format => 'mobile_single',
      :ip => request.ip,
      :markup => 'xhtml',
      :oe => 'utf8',
      :output => 'xhtml',
      :ref => (request.referer || ''),
      :url => scheme + request.env['HTTP_HOST'] + request.env['REQUEST_URI'],
      :useragent => user_agent
    }.merge(google_screen_res).merge(google_muid).merge(google_via_and_accept(user_agent)).merge(options)

    ad_url = 'http://pagead2.googlesyndication.com/pagead/ads?'
    ad_url += options.map { |k, v|
      v = google_color(v, dt) if k =~ /color_/
      "#{ k }=#{ ERB::Util.u(v) }"
    }.join('&')

    begin
      URI(ad_url).read
    rescue StandardError, Timeout::Error
      ''
    end
  end

  def google_color(color, time)
    color_array = color.split(',')
    color_array[time % color_array.size]
  end

  def google_screen_res
    screen_res =
      request.env['HTTP_UA_PIXELS'] ||
      request.env['HTTP_X_UP_DEVCAP_SCREENPIXELS'] ||
      request.env['HTTP_X_JPHONE_DISPLAY'] ||
      ''
    res_array = screen_res.split(/[x,*]/)
    (res_array.size == 2) ? { :u_w => res_array[0], :u_h => res_array[1] } : {}
  end

  def google_muid
    muid =
      request.env['HTTP_X_DCMGUID'] ||
      request.env['HTTP_X_UP_SUBNO'] ||
      request.env['HTTP_X_JPHONE_UID'] ||
      request.env['HTTP_X_EM_UID']
    muid ? { :muid => muid } : {}
  end

  def google_via_and_accept(ua)
    return {} if ua
    via_and_accept = {}
    via = request.env['HTTP_VIA']
    via_and_accept[:via] = request.env['HTTP_VIA'] if via
    accept = request.env['HTTP_ACCEPT']
    via_and_accept[:accept] = request.env['HTTP_ACCEPT'] if accept
    via_and_accept
  end
end
