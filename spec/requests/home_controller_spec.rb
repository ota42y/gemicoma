require 'rails_helper'

describe HomeController, type: :request do
  describe 'index' do
    subject { get url }

    let(:url) { '/' }

    it do
      gem = ::Dump::Rubygems::Rubygem.create!(name: 'rails')
      ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: gem, number: '5.1.0', platform: 'ruby')
      ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: gem, number: '5.2.0', platform: 'ruby')

      no_platform = ::Dump::Rubygems::Rubygem.create!(name: 'no_platform')
      ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: no_platform, number: '5.1.0', platform: 'ruby')

      revision = build(:revision, repository: create(:github_repository), status: :downloaded)
      dependency_file = build(:revision_dependency_file, :gemfile_lock, revision: revision)
      dependency_file.revision_ruby_specifications.build(name: 'rails', version: '5.0.0', platform: 'ruby')
      dependency_file.revision_ruby_specifications.build(name: 'unknown_gem', version: '1.0.0', platform: 'ruby')
      dependency_file.revision_ruby_specifications.build(name: 'no_platform', version: '1.0.0', platform: 'none')
      dependency_file.save!

      subject

      expect(response.status).to eq 200
      expect(response.body).to include(revision.repository.github_path)

      graph = ::V1::DependencyGraph.new(dependency_file)
      expect(response.body).to include((graph.health_rate * 100.0).floor(2).to_s)
    end
  end
end
