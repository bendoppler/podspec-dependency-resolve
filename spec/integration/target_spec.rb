RSpec.describe "`pod-target target` command", type: :cli do
  it "executes `pod-target help target` command successfully" do
    output = `pod-target help target`
    expected_output = <<-OUT
Usage:
  pod-target target

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
