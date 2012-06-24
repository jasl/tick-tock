class Content
  include Mongoid::Document

  def filled?
    raise 'You must implement this!'
  end

  def blank!
    raise 'You must implement this!'
  end

  protected

  def identify
  end
end