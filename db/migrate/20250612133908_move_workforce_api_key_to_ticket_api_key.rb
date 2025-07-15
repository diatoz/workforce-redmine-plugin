class MoveWorkforceApiKeyToTicketApiKey < ActiveRecord::Migration[6.1]
  def change
    setting = Setting.find_by(name: 'plugin_workforce')
    return unless setting

    value = setting.value
    if value.is_a?(Hash) && value['api_key']
      value['ticket_api_key'] = value.delete('api_key')
      setting.update(value: value)
    end
  end
end
