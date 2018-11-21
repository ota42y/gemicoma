require 'rails_helper'

describe Ruby::VersionsController, type: :request do
  describe '#index' do
    subject { get url }

    let(:url) { '/ruby/versions' }

    let(:github_user_name) { github_user.name }
    let(:github_user) { github_repository.github_user }
    let(:github_repository) { create(:github_repository) }
    let(:github_auth) { create(:github_auth, user: build(:user)) }
    let(:repository_name) { :name_1 }

    it 'no data' do
      subject
      expect(response.status).to eq 200
    end

    it 'data exist' do
      user = ::Github::User.find_or_create_by!(name: github_user)

      # @type [Github::Repository] repository
      repository = user.github_repositories.find_or_create_by!(repository: repository_name, branch: 'master')
      revision = create(:revision, repository: repository, status: :done)

      dependency_file = create(:revision_dependency_file, :gemfile_lock, revision: revision)
      dependency_file.create_revision_ruby_version(version: 'ruby 2.5.3p105')

      revision.update_revision

      repository = user.github_repositories.find_or_create_by!(repository: 'no gem data repository', branch: 'master')
      revision = create(:revision, repository: repository, status: :done)

      create(:revision_dependency_file, :gemfile_lock, revision: revision)

      revision.update_revision

      repository = user.github_repositories.find_or_create_by!(repository: 'old ruby', branch: 'master')
      revision = create(:revision, repository: repository, status: :done)

      dependency_file = create(:revision_dependency_file, :gemfile_lock, revision: revision)
      dependency_file.create_revision_ruby_version(version: 'ruby 2.5.0p105')

      revision.update_revision

      subject

      expect(response.status).to eq 200
      expect(response.body).to include(repository_name.to_s)
      index_253 = response.body.index('ruby 2.5.3p105') # rubocop:disable Naming/VariableNumber
      index_250 = response.body.index('ruby 2.5.0p105') # rubocop:disable Naming/VariableNumber
      index_none = response.body.index('---')

      expect(index_253).not_to eq nil
      expect(index_250).not_to eq nil
      expect(index_none).not_to eq nil

      pos = [index_253, index_250, index_none]
      expect(pos.sort).to eq pos
    end
  end
end
