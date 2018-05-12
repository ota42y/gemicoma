require 'rails_helper'

describe Github::Users::RepositoriesController, type: :request do
  describe '#show' do
    subject { get url }

    let(:url) { "/github/users/#{github_user}/repositories/#{repository_name}" }

    context 'when correct params' do
      let(:github_user) { 'ota42y' }
      let(:repository_name) { 'test' }

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

        gem = ::Dump::Rubygems::Rubygem.create!(name: 'rails')
        ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: gem, number: '5.1.0', platform: 'ruby')
        ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: gem, number: '5.2.0', platform: 'ruby')

        no_platform = ::Dump::Rubygems::Rubygem.create!(name: 'no_platform')
        ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: no_platform, number: '5.1.0', platform: 'ruby')

        subject

        expect(response.status).to eq 200
        expect(response.body).to include('5.2.0')
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
    end
  end
end
