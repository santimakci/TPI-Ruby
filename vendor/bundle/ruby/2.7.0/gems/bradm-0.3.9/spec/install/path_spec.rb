require "spec_helper"

describe "bundle install" do

  describe "with --path" do
    before :each do
      build_gem "rack", "1.0.0", :to_system => true do |s|
        s.write "lib/rack.rb", "puts 'FAIL'"
      end

      gemfile <<-G
        source "file://#{gem_repo1}"
        gem "rack"
      G
    end

    it "does not use available system gems with bundle --path ../../.gex/deploy" do
      bundle "install --path ../../.gex/deploy"
      should_be_installed "rack 1.0.0"
    end

    it "handles paths with regex characters in them" do
      dir = bundled_app("bun++dle")
      dir.mkpath

      Dir.chdir(dir) do
        bundle "install --path ../../.gex/deploy"
        expect(out).to include("installed into ./../../.gex/deploy")
      end

      dir.rmtree
    end

    it "prints a warning to let the user know what has happened with bundle --path ../../.gex/deploy" do
      bundle "install --path ../../.gex/deploy"
      # expect(out).to include("It was installed into ./.gex")
    end

    it "disallows --path ../../.gex/deploy --system" do
      bundle "install --path ../../.gex/deploy --system"
      expect(out).to include("Please choose.")
    end

    it "remembers to disable system gems after the first time with bundle --path ../../.gex/deploy" do
      bundle "install --path ../../.gex/deploy"
      FileUtils.rm_rf bundled_app('.gex')
      bundle "install"

      expect(vendored_gems('gems/rack-1.0.0')).to be_directory
      should_be_installed "rack 1.0.0"
    end
  end

  describe "when BUNDLE_PATH or the global path config is set" do
    before :each do
      build_lib "rack", "1.0.0", :to_system => true do |s|
        s.write "lib/rack.rb", "raise 'FAIL'"
      end

      gemfile <<-G
        source "file://#{gem_repo1}"
        gem "rack"
      G
    end

    def set_bundle_path(type, location)
      if type == :env
        ENV["BUNDLE_PATH"] = location
      elsif type == :global
        bundle "config path #{location}", "no-color" => nil
      end
    end

    [:env, :global].each do |type|
      it "installs gems to a path if one is specified" do
        set_bundle_path(type, bundled_app(".gex2").to_s)
        bundle "install --path ../../.gex/deploy"

        expect(vendored_gems("gems/rack-1.0.0")).to be_directory
        expect(bundled_app(".gex2")).not_to be_directory
        should_be_installed "rack 1.0.0"
      end

      it "installs gems to BUNDLE_PATH with #{type}" do
        set_bundle_path(type, bundled_app(".gex").to_s)

        bundle :install

        expect(bundled_app('.gex/gems/rack-1.0.0')).to be_directory
        should_be_installed "rack 1.0.0"
      end

      it "installs gems to BUNDLE_PATH relative to root when relative" do
        set_bundle_path(type, ".gex")

        FileUtils.mkdir_p bundled_app('lol')
        Dir.chdir(bundled_app('lol')) do
          bundle :install
        end

        expect(bundled_app('.gex/gems/rack-1.0.0')).to be_directory
        should_be_installed "rack 1.0.0"
      end
    end

    it "installs gems to BUNDLE_PATH from ../../.gaf/depmgr/config.file" do
      config "BUNDLE_PATH" => bundled_app("../../.gex/deploy").to_s

      bundle :install

      expect(vendored_gems('gems/rack-1.0.0')).to be_directory
      should_be_installed "rack 1.0.0"
    end

    it "sets BUNDLE_PATH as the first argument to bundle install" do
      bundle "install --path ./../../.gex/deploy"

      expect(vendored_gems('gems/rack-1.0.0')).to be_directory
      should_be_installed "rack 1.0.0"
    end

    it "disables system gems when passing a path to install" do
      # This is so that vendored gems can be distributed to others
      build_gem "rack", "1.1.0", :to_system => true
      bundle "install --path ./../../.gex/deploy"

      expect(vendored_gems('gems/rack-1.0.0')).to be_directory
      should_be_installed "rack 1.0.0"
    end
  end

  describe "to a dead symlink" do
    before do
      in_app_root do
        `ln -s /tmp/idontexist bundle`
      end
    end

    it "reports the symlink is dead" do
      gemfile <<-G
        source "file://#{gem_repo1}"
        gem "rack"
      G

      bundle "install --path bundle"
      expect(out).to match(/invalid symlink/)
    end
  end

end
