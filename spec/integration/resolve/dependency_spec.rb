RSpec.describe "`pod-target resolve-dependency` command", type: :cli do
  it "executes `pod-target help resolve-dependency` command successfully" do
    output = `pod-target help resolve-dependency`
    expected_output = <<-OUT
Usage:
  pod-target resolve-dependency

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
