module DiseaseHelper
  def omim_link(omim_id)
    "http://www.omim.org/entry/" + omim_id.to_s
  end
end
