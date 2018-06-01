require 'rails_helper'

describe ::V1::DependencyGraph do
  let(:gems) do
    [
      ['rails', Gem::Version.create('5.1.0'), 'ruby'],
      ['rails', Gem::Version.create('5.2.0'), 'ruby'],
      ['no_platform', Gem::Version.create('5.1.0'), 'ruby'],
    ]
  end
  let(:specification) do
    specification = V1::RubygemsSpecification.default_rubygem
    specification.instance_variable_set(:@all_specs, gems)
    specification
  end

  let(:empty_specification) do
    specification = V1::RubygemsSpecification.default_rubygem
    specification.instance_variable_set(:@all_specs, [])
    specification
  end

  it 'when not good rate' do
    dependency_file = build(:revision_dependency_file, :gemfile_lock)
    dependency_file.revision_ruby_specifications.build(name: 'rails', version: '5.0.0', platform: 'ruby')
    dependency_file.revision_ruby_specifications.build(name: 'unknown_gem', version: '1.0.0', platform: 'ruby')
    dependency_file.revision_ruby_specifications.build(name: 'no_platform', version: '1.0.0', platform: 'none')

    graph = ::V1::DependencyGraph.new(dependency_file, specification)

    expect(graph.dependencies.empty?).to eq false

    expect(graph.dependencies[0].name).to eq 'rails'
    expect(graph.dependencies[0].version).to eq '5.0.0'
    expect(graph.dependencies[0].new_version).to eq '5.2.0'

    expect(graph.dependencies[1].name).to eq 'unknown_gem'
    expect(graph.dependencies[1].version).to eq '1.0.0'
    expect(graph.dependencies[1].new_version).to eq '-'

    expect(graph.dependencies[2].name).to eq 'no_platform'
    expect(graph.dependencies[2].version).to eq '1.0.0'
    expect(graph.dependencies[2].new_version).to eq '-'
    expect(graph.health_rate.floor(4)).to eq 0.6666
  end

  it 'when when 100 percent' do
    dependency_file = build(:revision_dependency_file, :gemfile_lock)
    dependency_file.revision_ruby_specifications.build(name: 'rails', version: '5.2.0', platform: 'ruby')
    dependency_file.revision_ruby_specifications.build(name: 'unknown_gem', version: '1.0.0', platform: 'ruby')
    dependency_file.revision_ruby_specifications.build(name: 'no_platform', version: '1.0.0', platform: 'none')

    graph = ::V1::DependencyGraph.new(dependency_file, specification)

    expect(graph.dependencies[0].name).to eq 'rails'
    expect(graph.dependencies[0].version).to eq '5.2.0'
    expect(graph.dependencies[0].new_version).to eq '5.2.0'

    expect(graph.dependencies[1].name).to eq 'unknown_gem'
    expect(graph.dependencies[1].version).to eq '1.0.0'
    expect(graph.dependencies[1].new_version).to eq '-'

    expect(graph.dependencies[2].name).to eq 'no_platform'
    expect(graph.dependencies[2].version).to eq '1.0.0'
    expect(graph.dependencies[2].new_version).to eq '-'

    expect(graph.health_rate).to eq 1.0
  end

  it 'when no data' do
    graph = ::V1::DependencyGraph.new(nil, empty_specification)

    expect(graph.dependencies.empty?).to eq true
  end
end
