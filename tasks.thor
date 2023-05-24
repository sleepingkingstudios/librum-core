# frozen_string_literal: true

require 'sleeping_king_studios/tasks'

lib_path = File.expand_path('./lib')

$LOAD_PATH << lib_path unless $LOAD_PATH.include?(lib_path)

SleepingKingStudios::Tasks.configure do |config|
  config.ci do |ci|
    ci.rspec.update format: 'progress'

    ci.steps = %i[rspec rubocop simplecov]
  end

  config.file do |file|
    file.template_paths =
      [
        '~/Projects/ruby/sleeping_king_studios-templates/lib',
        file.class.default_template_path
      ]
  end
end

load 'loader/tasks.thor'
load 'sleeping_king_studios/tasks/ci/tasks.thor'
load 'sleeping_king_studios/tasks/file/tasks.thor'
