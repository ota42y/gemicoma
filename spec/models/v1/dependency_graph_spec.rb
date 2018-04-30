require 'rails_helper'

describe ::V1::DependencyGraph do
  it 'when correct' do
    gem = ::Dump::Rubygems::Rubygem.create!(name: 'rails')
    ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: gem, number: '5.1.0', platform: 'ruby')
    ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: gem, number: '5.2.0', platform: 'ruby')

    no_platform = ::Dump::Rubygems::Rubygem.create!(name: 'no_platform')
    ::Dump::Rubygems::Version.create!(dump_rubygems_rubygem: no_platform, number: '5.1.0', platform: 'ruby')

    rails_gem = build(:github_ruby_commit_specification, name: 'rails', version: '5.0.0', platform: 'ruby')
    unknown_gem = build(:github_ruby_commit_specification, name: 'unknown_gem', version: '1.0.0', platform: 'ruby')
    no_platform = build(:github_ruby_commit_specification, name: 'no_platform', version: '1.0.0', platform: 'none')

    lock = V1::Dependency::GemLock.new(nil, [rails_gem, unknown_gem, no_platform])
    graph = ::V1::DependencyGraph.new(lock)

    expect(graph.dependencies.empty?).to eq false

    expect(graph.dependencies.first.name).to eq 'rails'
    expect(graph.dependencies.first.version).to eq '5.0.0'
    expect(graph.dependencies.first.new_version).to eq '5.2.0'

    expect(graph.dependencies[1].name).to eq 'unknown_gem'
    expect(graph.dependencies[1].version).to eq '1.0.0'
    expect(graph.dependencies[1].new_version).to eq '-'

    expect(graph.dependencies[2].name).to eq 'no_platform'
    expect(graph.dependencies[2].version).to eq '1.0.0'
    expect(graph.dependencies[2].new_version).to eq '-'
  end
end
