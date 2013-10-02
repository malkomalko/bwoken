require 'slop'
require 'rake/file_list'
require 'fileutils'

require 'bwoken'
require 'bwoken/build'
require 'bwoken/device'
require 'bwoken/formatter'
require 'bwoken/formatters/passthru_formatter'
require 'bwoken/formatters/colorful_formatter'
require 'bwoken/script_runner'

module Bwoken
  module CLI
    class Test

      def self.help_banner
        <<-BANNER
Run your tests. If you don't specify which tests, bwoken will run them all

  bwoken test --simulator # runs all tests in the simulator

You can specify a device family if you only want to run, say, iPad tests:

  bwoken test --family ipad

If you only want to run a specific test, you can focus on it:

  bwoken test --focus login # runs iPhone and iPad tests named "login"


== Options ==
BANNER
      end

      attr_accessor :options

      # opts - A slop command object (acts like super-hash)
      #       :clobber    - remove all generated files, including iOS build
      #       :family     - enum of [nil, 'iphone', 'ipad'] (case-insensitive)
      #       :flags      - custom build flag array (default: []) TODO: not yet implmented
      #       :focus      - which tests to run (default: [], meaning "all")
      #       :formatter  - custom formatter (default: 'colorful')
      #       :scheme     - custom scheme (default: nil)
      #       :simulator  - should force simulator use (default: nil)
      #       :skip-build - do not build the iOS binary
      #       :verbose    - be verbose
      #       :product-name - the name of the generated .app file if it is different from the name of the project/workspace
      def initialize opts
        opts = opts.to_hash if opts.is_a?(Slop)
        self.options = opts.to_hash.tap do |o|
          o[:formatter] = 'passthru' if o[:verbose]
          o[:formatter] = select_formatter(o[:formatter])
          o[:simulator] = use_simulator?(o[:simulator])
          o[:family] = o[:family]
        end
      end

      def run
        clobber if options[:clobber]
        compile unless options[:'skip-build']
        clean
        test
      end

      def compile
        Build.new do |b|
          b.formatter = options[:formatter]
          b.scheme = options[:scheme] if options[:scheme]
          b.simulator = options[:simulator]
          b.configuration = options[:configuration]
        end.compile
      end

      def test
        Bwoken.app_name = options[:'product-name']

        ScriptRunner.new do |s|
          s.app_dir = Build.app_dir(options[:simulator])
          s.family = options[:family]
          s.focus = options[:focus]
          s.formatter = options[:formatter]
          s.simulator = options[:simulator]
        end.execute
      end

      def clobber
        FileUtils.rm_rf Bwoken.tmp_path
        FileUtils.rm_rf Bwoken::Build.build_path
      end

      def clean
        FileUtils.rm_rf Bwoken.tmp_path
      end

      def select_formatter formatter_name
        case formatter_name
        when 'passthru' then Bwoken::PassthruFormatter.new
        else Bwoken::ColorfulFormatter.new
        end
      end

      def use_simulator? want_forced_simulator
        want_forced_simulator || ! Bwoken::Device.connected?
      end

      def ensure_directory dir
        FileUtils.mkdir_p dir
      end

    end

  end
end
