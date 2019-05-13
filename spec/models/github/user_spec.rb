require 'rails_helper'

RSpec.describe Github::User, type: :model do
  describe 'dump' do
    let(:github_user_1) { build(:github_user) }
    let(:github_user_2) { build(:github_user) }
    let(:repository_1) do
      create(:github_repository, github_user: github_user_1, branch: 'staging', github_ruby_gem_info: build(:github_ruby_gem_info))
    end
    let(:repository_2) do
      create(:github_repository, github_user: github_user_1, github_ruby_gem_info: build(:github_ruby_gem_info, ruby_version_path: '../'))
    end
    let(:repository_3) do
      create(:github_repository, github_user: github_user_2, github_ruby_gem_info: build(:github_ruby_gem_info, gemfile_path: './app'))
    end

    before do
      repository_1
      repository_2
      repository_3
    end

    it do
      ret = Github::User.dump
      expect(ret).to match(
                         [
                             {
                                 name: github_user_1.name, repositories:
                                 [
                                     {
                                         repository: repository_1.repository, branch: repository_1.branch,
                                         github_ruby_gem_info: {
                                             gemfile_path: repository_1.github_ruby_gem_info.gemfile_path,
                                             ruby_version_path: repository_1.github_ruby_gem_info.ruby_version_path,
                                         }
                                     },
                                     {
                                         repository: repository_2.repository, branch: repository_2.branch,
                                         github_ruby_gem_info: {
                                             gemfile_path: repository_2.github_ruby_gem_info.gemfile_path,
                                             ruby_version_path: repository_2.github_ruby_gem_info.ruby_version_path,
                                         }
                                     },
                                 ]
                             },
                             {
                                 name: github_user_2.name, repositories:
                                 [
                                     {
                                         repository: repository_3.repository, branch: repository_3.branch,
                                         github_ruby_gem_info: {
                                             gemfile_path: repository_3.github_ruby_gem_info.gemfile_path,
                                             ruby_version_path: repository_3.github_ruby_gem_info.ruby_version_path,
                                         }
                                     },
                                 ]
                             }
                         ]
                     )
    end
  end

  describe 'restore' do
    let(:github_user_1) { build(:github_user) }
    let(:github_user_2) { build(:github_user) }
    let(:repository_1) do
      build(:github_repository, github_user: github_user_1, branch: 'staging', github_ruby_gem_info: build(:github_ruby_gem_info))
    end
    let(:repository_2) do
      build(:github_repository, github_user: github_user_1, github_ruby_gem_info: build(:github_ruby_gem_info, ruby_version_path: '../'))
    end
    let(:repository_3) do
      build(:github_repository, github_user: github_user_2, github_ruby_gem_info: build(:github_ruby_gem_info, gemfile_path: './app'))
    end

    before do
      repository_1
      repository_2
      repository_3
    end

    it do
      data = [
          {
              name: github_user_1.name, repositories:
              [
                  {
                      repository: repository_1.repository, branch: repository_1.branch,
                      github_ruby_gem_info: {
                          gemfile_path: repository_1.github_ruby_gem_info.gemfile_path,
                          ruby_version_path: repository_1.github_ruby_gem_info.ruby_version_path,
                      }
                  },
                  {
                      repository: repository_2.repository, branch: repository_2.branch,
                      github_ruby_gem_info: {
                          gemfile_path: repository_2.github_ruby_gem_info.gemfile_path,
                          ruby_version_path: repository_2.github_ruby_gem_info.ruby_version_path,
                      }
                  },
              ]
          },
          {
              name: github_user_2.name, repositories:
              [
                  {
                      repository: repository_3.repository, branch: repository_3.branch,
                      github_ruby_gem_info: {
                          gemfile_path: repository_3.github_ruby_gem_info.gemfile_path,
                          ruby_version_path: repository_3.github_ruby_gem_info.ruby_version_path,
                      }
                  },
              ]
          }
      ]

      Github::User.restore(data)
      expect(Github::User.dump).to eq(data)
    end
  end
end
