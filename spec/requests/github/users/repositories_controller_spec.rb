require 'rails_helper'

describe Github::Users::RepositoriesController, type: :request do
  describe '#show' do
    subject { get url }

    before { stub_request(:get, "#{::V1::RubygemsLoader::DEFAULT_RUBYGEM_URI}specs.4.8.gz").to_return(body: gz_body) }

    let(:gz_body) { Gem::Util.gzip(Marshal.dump(gems)) }
    let(:gems) { [] }

    let(:url) { "/github/users/#{github_user}/repositories/#{repository_name}" }

    context 'when correct params' do
      let(:github_user) { 'ota42y' }
      let(:repository_name) { 'test' }

      let(:gems) do
        [
          ['rails', Gem::Version.create('5.1.0'), 'ruby'],
          ['rails', Gem::Version.create('5.2.0'), 'ruby'],
          ['no_platform', Gem::Version.create('5.1.0'), 'ruby'],
        ]
      end

      it do
        user = ::Github::User.find_or_create_by!(name: github_user)

        # @type [Github::Repository] repository
        repository = user.github_repositories.find_or_create_by!(repository: repository_name, branch: 'master')

        travel(-1 * 1.minute) do
          create(:revision, repository: repository, status: :done)
        end

        # @type [Revision] revision
        revision = create(:revision, repository: repository, status: :done)
        # @type [Revision::DependencyFile] dependency_file
        dependency_file = create(:revision_dependency_file, :gemfile_lock, revision: revision)

        dependency_file.revision_ruby_specifications.create!(name: 'rails', version: '5.0.0', platform: 'ruby')
        dependency_file.revision_ruby_specifications.create!(name: 'unknown_gem', version: '1.0.0', platform: 'ruby')
        dependency_file.revision_ruby_specifications.create!(name: 'no_platform', version: '1.0.0', platform: 'none')

        subject

        expect(response.status).to eq 200
        expect(response.body).to include('5.2.0')
        expect(response.body).to include(revision.created_at.rfc3339)
        expect(response.body).to include('btn-danger')
        expect(response.body).to include("/github/users/#{user.name}/repositories/#{repository.repository}/update_job")

        expect(response.body).to include((0.6666 * 100.0).floor(2).to_s)
      end
    end

    context 'when no data' do
      let(:github_user) { 'ota42y' }
      let(:repository_name) { 'test' }

      it 'no github user' do
        subject
        expect(response.status).to eq 404
      end

      it 'no repository' do
        ::Github::User.find_or_create_by!(name: github_user)

        subject
        expect(response.status).to eq 404
      end

      it 'no revision' do
        user = ::Github::User.find_or_create_by!(name: github_user)
        user.github_repositories.find_or_create_by!(repository: repository_name, branch: 'master')

        subject

        expect(response.status).to eq 200
      end
    end
  end
end
