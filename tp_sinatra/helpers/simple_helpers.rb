def host
  request.host_with_port.to_s
end

def st_time(aTime)
  aTime.utc.iso8601
end

def make_link(rel, url, method = nil)
  link = {
    rel: rel,
    uri: host+url
  }

  link = link.merge({ method: method}) if method

  link
end
