require 'rails_helper'

describe User do
  describe 'find_with_omniauth' do
    subject { User.find_with_omniauth(provider: provider, uid: uid) }

    context 'unknown provider' do
      let(:provider) { 'unknown' }
      let(:uid) { create(:user).id }

      it { expect(subject).to eq nil }
    end

    context 'github' do
      context 'correct' do
        let(:provider) { 'github' }
        let(:uid) { github_auth.uid }

        let(:github_auth) { create(:github_auth, user: user) }
        let(:user) { create(:user) }

        it { expect(subject.id).to eq user.id }
      end

      context 'no data' do
        let(:provider) { 'github' }
        let(:uid) { 0 }

        it { expect(subject).to eq nil }
      end
    end
  end

  describe 'create_with_omniauth' do
    subject { User.create_with_omniauth(auth) }

    xcontext 'unknown provider' do
      let(:auth) { { provider: 'unknown' } }

      it { expect { subject }.to raise_error }
    end

    context 'github' do
      context 'correct' do
        let(:last_id) { ::Github::Auth.last&.id.to_i }
        let(:auth) do
          {
            provider: 'github',
            uid: last_id + 1,
            info: { nickname: 'github_user' },
            credentials: { token: SecureRandom.hex(40) },
          }.with_indifferent_access
        end

        it do
          expect { subject }.to change(::User, :count).by(1).
                                  and change(::Github::Auth, :count).by(1)
        end
      end
    end
  end
end
