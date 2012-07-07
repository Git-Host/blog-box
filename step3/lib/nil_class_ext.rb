module NilClassExt
  def blank?; true; end
  
  def present?; false; end
end

class NilClass
  include NilClassExt
end
