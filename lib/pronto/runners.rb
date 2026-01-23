# frozen_string_literal: true

module Pronto
  class Runners
    def initialize(runners = Runner.runners, config = Config.new)
      @runners = runners
      @config = config
    end

    def run(patches)
      filtered = reject_excluded(config.excluded_files('all'), patches)
      return [] if filtered.none?

      apply_max_warnings(run_all_runners(filtered, patches.commit))
    end

    private

    attr_reader :config, :runners

    def active_runners
      runners.select { |runner| active_runner?(runner) }
    end

    def active_runner?(runner)
      return true if config.runners.empty? && config.skip_runners.empty?

      if config.runners.empty?
        !config.skip_runners.include?(runner.title)
      else
        active_runner_names = config.runners - config.skip_runners
        active_runner_names.include?(runner.title)
      end
    end

    def reject_excluded(excluded_files, patches)
      return patches unless excluded_files.any?

      patches.reject do |patch|
        excluded_files.include?(patch.new_file_full_path.to_s)
      end
    end

    def exceeds_max?(warnings)
      config.max_warnings && warnings.count >= config.max_warnings
    end

    def run_runner(runner, runner_patches, commit)
      Array(runner.new(runner_patches, commit).run).flatten.compact
    end

    def apply_max_warnings(result)
      config.max_warnings ? result.take(config.max_warnings) : result
    end

    def run_all_runners(filtered, commit)
      result = []
      active_runners.each do |runner|
        break if exceeds_max?(result)

        config.logger.log("Running #{runner}")
        runner_patches = reject_excluded(config.excluded_files(runner.title), filtered)
        next if runner_patches.none?

        result.concat(run_runner(runner, runner_patches, commit))
      end
      result
    end
  end
end
