require 'spec_helper'

describe Message do
  include Concurrency

  describe '#add_tag' do
    let!(:message1) { create(:customer_message) }
    let!(:message2) { create(:customer_message) }
    example '2つのセッションが並行して同じタグを追加する', :concurrent do
      proc1 = -> {
        class << Tag
          alias_method :create_without_delay!, :create!
          def create!(*args)
            sleep(0.2)
            create_without_delay!(*args)
          end
        end
        message1.add_tag('ABC')
      }
      proc2 = -> {
        class << Tag
          alias_method :find_by_without_delay, :find_by
          def find_by(*args)
            sleep(0.1)
            find_by_without_delay(*args)
          end
        end
        message2.add_tag('ABC')
      }
      run_in_parallel(proc1, proc2)
      expect(MessageTagLink.count).to eq(2)
      expect(Tag.count).to eq(1)
    end
  end
end
