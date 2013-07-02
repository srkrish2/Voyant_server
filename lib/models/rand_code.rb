module RandCode
  protected
  def rand_code(size=30)
    return (0...size).map{ ('a'..'z').to_a[rand(26)] }.join
  end
end
