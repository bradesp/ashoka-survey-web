class Reports::Excel::Metadata
  def initialize(responses, access_token, options={})
    @responses = responses
    @access_token = access_token
    @options = options
  end

  def headers
    if disable_filtering?
      ["Added By", "Organization", "Last updated at", "Address", "IP Address", "State"]
    else
      ["Added By", "Organization", "Last updated at", "State"]
    end
  end

  def for(response)
    if disable_filtering?
      [user_name_for(response.user_id), organization_name_for(response.organization_id), formatted_last_update_for(response),
        response.location, response.ip_address, response.state]
    else
      [user_name_for(response.user_id), organization_name_for(response.organization_id), formatted_last_update_for(response), response.state]
    end
  end

  def formatted_last_update_for(response)
    response.last_update.strftime("%d/%m/%Y")
  end

  def disable_filtering?
    ActiveRecord::ConnectionAdapters::Column.value_to_boolean(@options[:disable_filtering])
  end

  def user_name_for(id)
    @user_names ||= User.users_for_ids(@access_token, @responses.map(&:user_id).uniq)
    @user_names[id]
  end

  def organization_name_for(id)
    @organizations ||= Organization.all(@access_token)
    organization = @organizations.find { |o| o.id == id }
    organization ? organization.name : ""
  end
end
