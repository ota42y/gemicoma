require 'rails_helper'

describe HomeController, type: :request do
  describe 'index' do
    subject { get url }

    before { stub_request(:get, "#{::V1::RubygemsSpecification::DEFAULT_RUBYGEM_URI}specs.4.8.gz").to_return(body: gz_body) }

    let(:gz_body) { Gem::Util.gzip(Marshal.dump(gems)) }
    let(:gems) do
      [
        ['rails', Gem::Version.create('5.1.0'), 'ruby'],
        ['rails', Gem::Version.create('5.2.0'), 'ruby'],
        ['no_platform', Gem::Version.create('5.1.0'), 'ruby'],
      ]
    end

    let(:url) { '/' }

    let(:health_rate) { (2.0 / 3) * 100.0 }

    it do
      revision = build(:revision, repository: create(:github_repository), status: :downloaded)
      dependency_file = build(:revision_dependency_file, :gemfile_lock, revision: revision)
      dependency_file.revision_ruby_specifications.build(name: 'rails', version: '5.0.0', platform: 'ruby')
      dependency_file.revision_ruby_specifications.build(name: 'unknown_gem', version: '1.0.0', platform: 'ruby')
      dependency_file.revision_ruby_specifications.build(name: 'no_platform', version: '1.0.0', platform: 'none')
      dependency_file.save!

      subject

      expect(response.status).to eq 200
      expect(response.body).to include(revision.repository.github_path)
      expect(response.body).to include(health_rate.floor(2).to_s)
    end
  end
end
