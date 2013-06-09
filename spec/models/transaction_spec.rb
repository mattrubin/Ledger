require 'spec_helper'

describe Transaction do
  before { @transaction = Transaction.new(description: "Coffee", value: 11.11) }

  subject { @transaction }

  it { should respond_to(:description) }
  it { should respond_to(:value) }
  it { should respond_to(:account_id) }
end

