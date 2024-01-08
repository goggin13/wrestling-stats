require "net/http"

class DownloadService
  def self.download(url)
    result = Net::HTTP.get_response(URI(url))
    Rails.logger.info "[DownloadService] requesting #{url}"
    if result.is_a?(Net::HTTPSuccess)
      Rails.logger.info "[DownloadService] success"
      result.body
    else
      Rails.logger.info "[DownloadService] failed: #{result.class}"
      Rails.logger.info "[DownloadService] failed: #{result.body}"
      raise "Download Service failed to download #{url}"
    end
  end

  def self.redirects_to(url)
    result = Net::HTTP.get_response(URI(url))
    Rails.logger.info "[DownloadService] querying #{url}"
    if result.is_a?(Net::HTTPMovedPermanently)
      location = result["location"]
      Rails.logger.info "[DownloadService] redirects to #{location}"
      location
    else
      Rails.logger.info "[DownloadService] failed: #{result.class}"
      Rails.logger.info "[DownloadService] failed: #{result.body}"
      raise "Download Service failed to download #{url}"
    end
  end
end
