require 'rails_helper'

describe V1::Github::GemData, type: :model do
  describe 'execute' do
    subject { V1::Github::GemData.new(commit) }

    context 'get gemfile from github' do
      let(:commit) do
        c = build(:github_commit)
        c.github_repository.github_ruby_gem_info = build(:github_ruby_gem_info)
        c
      end

      let(:body) do
        <<~GEMFILE
          GEM
            remote: https://rubygems.org/
            specs:
              ota42y_rubygems_hands_on (0.1.2)
                ota42y_test_gem
              ota42y_test_gem (0.2.0)

          PLATFORMS
            ruby

          DEPENDENCIES
            ota42y_rubygems_hands_on (>= 0.1.2)

          BUNDLED WITH
             1.16.1
GEMFILE
      end

      before do
        stub_request(:get, "https://raw.githubusercontent.com/rails/rails/#{commit.commit_hash}/Gemfile.lock").
          to_return(body: body)
      end

      it do
        expect(subject.build!).to eq true

        gemfile_lock = subject.gemfile_lock
        gem = gemfile_lock.specifications.select { |n| n.name == 'ota42y_rubygems_hands_on' }
        expect(gem[0].platform).to eq 'ruby'
        expect(gem[0].version).to eq Gem::Version.new('0.1.2')
      end
    end
  end
end
