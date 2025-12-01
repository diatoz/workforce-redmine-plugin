module Workforce
  VERSION = "1.2.0"
  CUSTOM_FIELD_NOT_SUPPORTED_FORMATS = %w[user version enumeration attachment]
  CUSTOM_FIELD_FORMAT_MAPPING = {
    "float" => "NUMBER",
    "int" => "NUMBER",
    "date" => "DATE",
    "text" => "TEXT",
    "string" => "TEXT",
    "link"  => "URL",
    "bool" => "TEXT",
    "list" => "TEXT",
    "enumeration" => "SINGLE_SELECT",
    "attachment" => nil,
    "user"  => nil,
    "version" => nil
  }.freeze
  ISSUE_MANDATORY_ATTRIBUTES = %w[subject description status_id priority_id assigned_to_id due_date].freeze
  ISSUE_SUPPORTED_ATTRIBUTES = %w[project_id author_id start_date done_ratio estimated_hours].freeze
  ISSUE_SUPPORTED_ATTRIBUTES_FORMAT_MAPPING = {
    "project_id" => "TEXT",
    "author_id" => "EMAIL",
    "start_date" => "DATE",
    "done_ratio" => "NUMBER",
    "estimated_hours" => "NUMBER"
  }.freeze

  mattr_accessor :logger

  def self.apply_patches
    patch_dir = Rails.root.join('plugins', 'workforce', 'lib', 'workforce', 'patches')
    Dir.glob("#{patch_dir}/**/*.rb").sort.each do |file|
      require file
    end
  end
end
