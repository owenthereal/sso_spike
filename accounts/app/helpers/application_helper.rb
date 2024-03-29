module ApplicationHelper
  def oauth_hidden_fields
    oauth.params.map do |key, value|
      hidden_field_tag key, value
    end.join("\n").html_safe
  end

  def oauth_app_name
    oauth.client.try(:name)
  end
end
