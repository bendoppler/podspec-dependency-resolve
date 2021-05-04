require 'pod/target/commands/resolve/dependency'

RSpec.describe Pod::Target::Commands::Resolve::Dependency do
  it "executes `resolve-dependency` command successfully" do
    output = StringIO.new
    options = {}
    command = Pod::Target::Commands::Resolve::Dependency.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
