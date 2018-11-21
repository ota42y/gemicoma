require 'rails_helper'

describe Admin::Github::AllFetchesController, type: :request do
  describe '#create' do
    subject { post url, params: params }

    let(:url) { '/admin/github/all_fetch' }
    let(:params) { {} }

    let(:github_auth) { create(:github_auth, user: build(:user)) }
    let(:admin_user) { create(:admin, user: github_auth.user) }

    context 'correct' do
      before do
        admin_user
        github_login(github_auth.uid)
      end

      it do
        expect { subject }.to enqueue_job(::FetchAllMasterJob)

        expect(response.status).to eq 302
      end

      it 'check redirect' do
        expect(subject).to redirect_to('/')
      end
    end

    it 'not login' do
      subject

      expect(response.status).to eq 404
    end
  end
end
