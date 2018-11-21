require 'rails_helper'

describe Ruby::GemsController, type: :request do
  describe '#show' do
    subject { get url }

    let(:url) { "/ruby/gems/#{gem_name}" }
    let(:gem_name) { 'rails' }

    context 'when log in' do
      let(:github_user_name) { github_user.name }
      let(:github_user) { github_repository.github_user }
      let(:github_repository) { create(:github_repository) }
      let(:github_auth) { create(:github_auth, user: build(:user)) }
      let(:repository_name) { :name_1 }

      before do
        github_login(github_auth.uid)
      end

      it 'no data' do
        subject
        expect(response.status).to eq 200
        expect(response.body).to include(gem_name)
      end

      it 'data exist' do
        user = ::Github::User.find_or_create_by!(name: github_user)

        # @type [Github::Repository] repository
        repository = user.github_repositories.find_or_create_by!(repository: repository_name, branch: 'master')
        revision = create(:revision, repository: repository, status: :done)
        dependency_file = create(:revision_dependency_file, :gemfile_lock, revision: revision)
        dependency_file.revision_ruby_specifications.create!(name: gem_name, version: '5.2.0', platform: 'ruby')
        dependency_file.revision_ruby_specifications.create!(name: 'rspec', version: '5.2.0', platform: 'ruby')
        revision.update_revision

        # old revision
        revision = create(:revision, repository: repository, status: :done)
        dependency_file = create(:revision_dependency_file, :gemfile_lock, revision: revision)
        dependency_file.revision_ruby_specifications.create!(name: gem_name, version: '5.1.0', platform: 'ruby')

        repository = user.github_repositories.find_or_create_by!(repository: 'very_old', branch: 'master')
        revision = create(:revision, repository: repository, status: :done)
        dependency_file = create(:revision_dependency_file, :gemfile_lock, revision: revision)
        dependency_file.revision_ruby_specifications.create!(name: gem_name, version: '5.0.0', platform: 'ruby')
        revision.update_revision

        repository = user.github_repositories.find_or_create_by!(repository: 'old', branch: 'master')
        revision = create(:revision, repository: repository, status: :done)
        dependency_file = create(:revision_dependency_file, :gemfile_lock, revision: revision)
        dependency_file.revision_ruby_specifications.create!(name: gem_name, version: '5.1.0', platform: 'ruby')
        revision.update_revision

        subject

        expect(response.status).to eq 200
        rails_520 = response.body.index('5.2.0') # rubocop:disable Naming/VariableNumber
        rails_510 = response.body.index('5.1.0') # rubocop:disable Naming/VariableNumber
        rails_500 = response.body.index('5.0.0') # rubocop:disable Naming/VariableNumber
        expect(rails_520).not_to eq nil
        expect(rails_510).not_to eq nil
        expect(rails_500).not_to eq nil

        sorted = [rails_520, rails_510, rails_500]
        expect(sorted.sort).to eq sorted
      end
    end
  end
end
