def github_login(github_uid)
  OmniAuth.config.mock_auth[:github] = { 'provider' => 'github', 'uid' => github_uid }
  get '/auth/github/callback'
end

def github_logout
  OmniAuth.config.mock_auth[:github] = nil
end
