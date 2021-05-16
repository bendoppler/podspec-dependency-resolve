require 'pod/target/commands/target'

RSpec.describe Pod::Target::Commands::Target do
  it "executes `target` command successfully" do
    output = StringIO.new
    options = {}
    command = Pod::Target::Commands::Target.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
