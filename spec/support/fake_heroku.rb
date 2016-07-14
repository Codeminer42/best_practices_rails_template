require 'pathname'

class FakeHeroku
  RECORDER = Pathname(__dir__).join('..', '..', 'tmp', 'heroku_commands')

  def initialize(args)
    @args = args
  end

  def run!
    if @args.first == "plugins"
      puts "heroku-pipelines@0.29.0"
    end

    File.open(RECORDER, 'a') do |file|
      file.puts @args.join(' ')
    end
  end

  def self.clear!
    FileUtils.rm_rf RECORDER
  end

  def self.has_gem_included?(project_path, gem_name)
    gemfile = File.open(File.join(project_path, 'Gemfile'), 'a')

    File.foreach(gemfile).any? do |line|
      line.match(/#{Regexp.quote(gem_name)}/)
    end
  end

  def self.has_configured_buildpacks_sequentially?(environment, buildpack_urls)
    lines = commands_ran.each_line.grep(
      /.*buildpacks:(add|clear).*#{environment}.*/
    )
    app_name = app_name_for(environment)

    if lines.shift !~ /^buildpacks:clear -a #{app_name} --remote #{environment}/
      fail "Expected #{environment} to have cleared buildpacks before "\
           "adding new ones"
    end

    if lines.count != buildpack_urls.count
      fail "Expected #{environment} to have #{buildpack_urls.count} "\
           "buildpacks configured but has #{lines.count}"
    end

    lines.zip(buildpack_urls).all? do |line, buildpack_url|
      line =~ /^buildpacks:add #{buildpack_url} -a #{app_name} --remote #{environment}/
    end
  end

  def self.has_created_app_for?(environment, flags = nil)
    app_name = app_name_for(environment)

    command = if flags
                "create #{app_name} #{flags} --remote #{environment}\n"
              else
                "create #{app_name} --remote #{environment}\n"
              end

    File.foreach(RECORDER).any? { |line| line == command }
  end

  def self.has_configured_vars?(remote_name, var, value = '.+')
    commands_ran =~ /^config:add #{var}=#{value} --remote #{remote_name}\n/
  end

  def self.has_setup_pipeline_for?(app_name)
    commands_ran =~ /^pipelines:create #{app_name} -a #{app_name}-staging --stage staging/ &&
      commands_ran =~ /^pipelines:add #{app_name} -a #{app_name}-production --stage production/
  end

  def self.commands_ran
    @commands_ran ||= File.read(RECORDER)
  end
  private_class_method :commands_ran

  def self.app_name_for(environment)
    "#{Code42TemplateTestHelpers::APP_NAME.dasherize}-#{environment}"
  end
  private_class_method :app_name_for
end
