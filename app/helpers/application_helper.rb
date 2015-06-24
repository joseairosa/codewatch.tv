module ApplicationHelper
  def timezone_offset(timezone)
    ActiveSupport::TimeZone.all.find { |tz| tz.to_s == timezone }.formatted_offset
  end
end
