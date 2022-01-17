require "net/http"

class DownloadService
  def self.download(url)
    result = Net::HTTP.get_response(URI(url))
    Rails.logger.info "[DownloadService] requesting #{url}"
    if result.is_a?(Net::HTTPSuccess)
      Rails.logger.info "[DownloadService] success"
      result.body
    else
      Rails.logger.info "[DownloadService] failed"
      raise "Download Service failed to download #{url}"
    end
  end
end
