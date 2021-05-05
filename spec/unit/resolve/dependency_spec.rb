require 'pod/target/commands/resolve/dependency'

RSpec.describe Pod::Target::Commands::Dependency do
  it "executes `resolve-dependency` command successfully" do
    output = StringIO.new
    options = {}
    command = Pod::Target::Commands::Dependency.new(options)

    command.execute()

    expect(output.string).to eq("OK\n")
  end
end
